import app from "ags/gtk4/app"
import { Astal, Gtk, Gdk } from "ags/gtk4"
import { createPoll } from "ags/time"
import AstalHyprland from "gi://AstalHyprland?version=0.1"
import { createState, For, Accessor, With } from "ags"

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const time = createPoll("", 1000, "date")
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
      </centerbox>
    </window>
  )
}

function Workspaces() {
  const hyprland = AstalHyprland.get_default()

  type Workspaces = {
    allWorkspaces: AstalHyprland.Workspace[]
    focused: number
  }

  const [workspaces, setWorkspaces] = createState<Workspaces>({
    allWorkspaces: hyprland.get_workspaces(),
    focused: hyprland.focused_workspace.get_id(),
  })

  hyprland.connect("workspace-added", () => {
    setWorkspaces({
      ...workspaces.get(),
      allWorkspaces: hyprland.get_workspaces(),
    })
  })

  hyprland.connect("workspace-removed", () => {
    setWorkspaces({
      ...workspaces.get(),
      allWorkspaces: hyprland.get_workspaces(),
    })
  })

  hyprland.connect("notify::focused-workspace", () => {
    setWorkspaces({
      ...workspaces.get(),
      focused: hyprland.focused_workspace.get_id(),
    })
  })

  function onClicked(id: number) {
    hyprland.get_workspace(id).focus()
  }

  return (
    <box class="workspace-container">
      <With value={workspaces}>
        {(ws) => (
          <box>
            {ws.allWorkspaces
              .sort((a, b) => a.get_id() - b.get_id())
              .map((w) => {
                return (
                  <button
                    onClicked={() => onClicked(w.get_id())}
                    class={`workspace-button ${w.get_id() === ws.focused ? "focused" : ""}`}
                  >
                    <label label={w.get_id().toString()} />
                  </button>
                )
              })}
          </box>
        )}
      </With>
    </box>
  )
}
