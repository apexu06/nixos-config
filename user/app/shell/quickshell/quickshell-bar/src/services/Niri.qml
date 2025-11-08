pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property list<NiriWorkspace> workspaces: []

    function handleEvent(event) {
        if (event.WorkspaceActivated) {
            const {
                id,
                focused
            } = event.WorkspaceActivated;

            root.workspaces.find(w => w.id === id).focused = focused;

            if (focused) {
                root.workspaces.forEach(ws => ws.focused = !(ws.id !== id));
            }
        }

        if (event.WorkspacesChanged) {
            updateWorkspaces(event.WorkspacesChanged.workspaces);
        }
    }

    function updateWorkspaces(data) {
        root.workspaces = [];
        try {
            data.sort((a, b) => a.idx - b.idx).forEach(ws => {
                const workspace = {
                    id: ws.id,
                    name: ws.name,
                    output: ws.output,
                    urgent: ws.is_urgent,
                    active: ws.is_active,
                    focused: ws.is_focused,
                    activeWindowId: ws.active_window_id ?? -1
                };
                root.workspaces.push(workspaceComp.createObject(root, workspace));
            });
        } catch (e) {
            print(e);
        }
    }

    Process {
        id: listener
        running: true
        command: ["niri", "msg", "--json", "event-stream"]

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

    Process {
        id: init
        running: true
        command: ["niri", "msg", "--json", "workspaces"]
        stdout: SplitParser {
            onRead: data => {
                root.updateWorkspaces(JSON.parse(data));
            }
        }
    }

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
