import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { createPoll } from "ags/time"
import AstalHyprland from "gi://AstalHyprland?version=0.1"
import { createState, For, Accessor, With } from "ags"

const PERSISTENT_WORKSPACES = 3

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor

  return (
    <window
      visible
      name="bar"
      class="Bar"
      gdkmonitor={gdkmonitor}
      anchor={TOP | LEFT | RIGHT}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      application={app}
    >
      <centerbox orientation={Gtk.Orientation.HORIZONTAL} class="main">
        <Workspaces $type="start" />
        <box $type="end">
          <Clock />
        </box>
      </centerbox>
    </window>
  )
}

function Clock() {
  function pad(n: number) {
    return n.toString().padStart(2, "0")
  }
  const time = createPoll("", 1000, 'date -u "+%Y-%m-%dT%H:%M:%SZ"', (date) => {
    const newDate = new Date(date)
    return `${pad(newDate.getHours())}:${pad(newDate.getMinutes())}:${pad(newDate.getSeconds())}`
  })

  return (
    <menubutton>
      <label label={time} />
      <popover>
        <Gtk.Calendar />
      </popover>
    </menubutton>
  )
}

function Workspaces() {
  const hyprland = AstalHyprland.get_default()

  const START_WORKSPACE = 1

  type WorkspaceState = {
    focused: number
    existingWorkspaces: Set<number>
  }

  const [state, setState] = createState<WorkspaceState>({
    focused: hyprland.focused_workspace.get_id() ?? 1,
    existingWorkspaces: new Set(
      hyprland
        .get_workspaces()
        .filter((w) => !w.get_name().includes("special:magic"))
        .map((w) => w.get_id()),
    ),
  })

  const updateWorkspaces = () => {
    setState({
      ...state.get(),
      existingWorkspaces: new Set(
        hyprland
          .get_workspaces()
          .filter((w) => !w.get_name().includes("special:magic"))
          .map((w) => w.get_id()),
      ),
    })
  }

  hyprland.connect("workspace-added", updateWorkspaces)
  hyprland.connect("workspace-removed", updateWorkspaces)
  hyprland.connect("notify::focused-workspace", () => {
    setState({
      ...state.get(),
      focused: hyprland.focused_workspace.get_id(),
    })
  })

  function onClicked(id: number) {
    const workspace = hyprland.get_workspace(id)
    if (workspace) {
      workspace.focus()
    } else {
      hyprland.dispatch("workspace", id.toString())
    }
  }

  const getWorkspaceIds = (
    focused: number,
    existingWorkspaces: Set<number>,
  ) => {
    const workspaceSet = new Set<number>()

    for (
      let i = START_WORKSPACE;
      i < START_WORKSPACE + PERSISTENT_WORKSPACES;
      i++
    ) {
      workspaceSet.add(i)
    }

    workspaceSet.add(focused)

    existingWorkspaces.forEach((id) => workspaceSet.add(id))

    return Array.from(workspaceSet).sort((a, b) => a - b)
  }

  return (
    <box class="workspace-container">
      <With value={state}>
        {(st) => {
          const workspaceIds = getWorkspaceIds(
            st.focused,
            st.existingWorkspaces,
          )

          return (
            <box>
              {workspaceIds.map((id) => {
                const isFocused = id === st.focused

                return (
                  <button
                    onClicked={() => onClicked(id)}
                    class={`workspace-button ${isFocused ? "focused" : ""}`}
                  >
                    <label label={id.toString()} />
                  </button>
                )
              })}
            </box>
          )
        }}
      </With>
    </box>
  )
}
