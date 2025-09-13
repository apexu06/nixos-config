import AstalHyprland from "gi://AstalHyprland?version=0.1";
import { createState, With } from "gnim";

const PERSISTENT_WORKSPACES = 3;

export default function Workspaces() {
  const hyprland = AstalHyprland.get_default();

  const START_WORKSPACE = 1;

  type WorkspaceState = {
    focused: number;
    urgent: number;
    existingWorkspaces: Set<number>;
  };

  const [state, setState] = createState<WorkspaceState>({
    focused: hyprland.focused_workspace.get_id() ?? 1,
    urgent: -1,
    existingWorkspaces: new Set(
      hyprland
        .get_workspaces()
        .filter((w) => !w.get_name().includes("special:magic"))
        .map((w) => w.get_id()),
    ),
  });

  const updateWorkspaces = () => {
    setState({
      ...state.get(),
      existingWorkspaces: new Set(
        hyprland
          .get_workspaces()
          .filter((w) => !w.get_name().includes("special:magic"))
          .map((w) => w.get_id()),
      ),
    });
  };

  hyprland.connect("workspace-added", updateWorkspaces);
  hyprland.connect("workspace-removed", updateWorkspaces);
  hyprland.connect("urgent", (_, c) => {
    setState({
      ...state.get(),
      urgent: c.get_workspace().get_id(),
    });
  });

  hyprland.connect("notify::focused-workspace", () => {
    let s = state.get();
    setState({
      ...s,
      focused: hyprland.focused_workspace.get_id(),
      urgent: s.urgent === hyprland.focused_workspace.get_id() ? -1 : s.urgent,
    });
  });

  function onClicked(id: number) {
    const workspace = hyprland.get_workspace(id);
    if (workspace) {
      workspace.focus();
    } else {
      hyprland.dispatch("workspace", id.toString());
    }
  }

  const getWorkspaceIds = (
    focused: number,
    existingWorkspaces: Set<number>,
  ) => {
    const workspaceSet = new Set<number>();

    for (
      let i = START_WORKSPACE;
      i < START_WORKSPACE + PERSISTENT_WORKSPACES;
      i++
    ) {
      workspaceSet.add(i);
    }

    workspaceSet.add(focused);

    existingWorkspaces.forEach((id) => workspaceSet.add(id));

    return Array.from(workspaceSet).sort((a, b) => a - b);
  };

  return (
    <box class="workspace-container">
      <With value={state}>
        {(st) => {
          const workspaceIds = getWorkspaceIds(
            st.focused,
            st.existingWorkspaces,
          );

          return (
            <box>
              {workspaceIds.map((id) => {
                const isFocused = id === st.focused;
                const isUrgent = id === st.urgent;

                return (
                  <button
                    onClicked={() => onClicked(id)}
                    class={`workspace-button ${isFocused ? "focused" : ""} ${isUrgent ? "urgent" : ""}`}
                  >
                    <label label={id.toString()} />
                  </button>
                );
              })}
            </box>
          );
        }}
      </With>
    </box>
  );
}
