pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // workspace data
    property list<NiriWorkspace> workspaces: []      // maps id → workspace object

    Process {
        id: listener
        running: true
        command: ["niri", "msg", "subscribe"]

        stdout: SplitParser {
            onRead: data => {
                const lines = data.split("\n");
                for (const line of lines) {
                    if (line.trim() === "")
                        continue;
                    try {
                        const data = JSON.parse(line);
                        root.handleEvent(data);
                    } catch (e) {
                        console.warn("Failed to parse Niri IPC event:", line);
                    }
                }
            }
        }
    }

    function handleEvent(event) {
        // Events look like { "event": "workspace_changed", "focused": {...}, "workspaces": [...] }
        switch (event.event) {
        case "workspace_changed":
        case "workspace_created":
        case "workspace_destroyed":
        case "focused_workspace_changed":
            updateWorkspaces(event);
            break;
        default:
            break;
        }
    }

    function updateWorkspaces(event) {
        if (event.workspaces) {
            const newMap = {};
            for (const ws of event.workspaces) {
                newMap[ws.id] = ws;
            }
            root.workspaces = newMap;
        }
        if (event.focused) {
            root.focusedWorkspace = event.focused;
        }
    }

    // --- initial state fetch ---
    Process {
        id: init
        running: true
        command: ["niri", "msg", "--json", "workspaces"]
        stdout: SplitParser {
            onRead: jsonData => {
                try {
                    const data = JSON.parse(jsonData);
                    let workspaces = data.forEach(ws => {
                        const workspace = {
                            id: ws.id,
                            name: ws.name,
                            output: ws.output,
                            urgent: ws.is_urgent,
                            active: ws.is_active,
                            focused: ws.is_focused,
                            activeWindowId: ws.active_window_id
                        };

                        root.workspaces.push(workspaceComp.createObject(root));
                    });
                    console.log(root.workspaces);
                    // root.focusedWorkspace = data.find(w => w.focused) ?? null;
                } catch (e) {
                    console.warn("Failed to load initial workspaces:", e);
                }
            }
        }
    }

    // "id": 1,
    //     "idx": 1,
    //     "name": null,
    //     "output": "eDP-1",
    //     "is_urgent": false,
    //     "is_active": true,
    //     "is_focused": true,
    //     "active_window_id": 5

    component NiriWorkspace: QtObject {
        required property int id
        required property string name
        required property string output
        required property bool urgent
        required property bool active
        required property bool focused
        required property int activeWindowId
    }

    Component {
        id: workspaceComp
        NiriWorkspace {}
    }
}
