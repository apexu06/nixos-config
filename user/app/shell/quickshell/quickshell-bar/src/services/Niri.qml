pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property list<NiriWorkspace> workspaces: []
    property list<NiriWindow> windows: []
    property NiriWindow focusedWindow: null

    onWindowsChanged: focusedWindow = windows.find(w => w.focused) ?? null

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

        if (event.WindowsChanged) {
            root.windows = [];
            const windows = event.WindowsChanged.windows;

            windows.forEach(w => {
                root.windows.push(toWindow(w));
            });
        }

        if (event.WindowOpenedOrChanged) {
            const win = toWindow(event.WindowOpenedOrChanged.window);
            const idx = root.windows.findIndex(w => w.id === win.id);

            if (idx !== -1) {
                root.windows[idx] = win;
            } else {
                root.windows.push(win);
            }
        }

        if (event.WindowClosed) {
            const id = event.WindowClosed.id;
            root.windows = root.windows.filter(w => w.id !== id);
        }

        if (event.WindowFocusChanged) {
            const id = event.WindowFocusChanged.id;
            const idx = root.windows.findIndex(w => w.id === id);

            root.focusedWindow = root.windows[idx];
            root.windows.forEach(w => {
                w.focused = (w.id === id);
            });
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

    function toWindow(data) {
        const w = {
            id: data.id,
            title: data.title,
            appId: data.app_id,
            pid: data.pid,
            workspaceId: data.workspace_id,
            urgent: data.is_urgent,
            floating: data.is_floating,
            focused: data.is_focused
        };
        return windowComp.createObject(root, w);
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
                    const data = JSON.parse(line);
                    root.handleEvent(data);
                }
            }
        }
    }

    component NiriWindow: QtObject {
        required property int id
        required property string title
        required property string appId
        required property int pid
        required property int workspaceId
        required property bool urgent
        required property bool floating
        required property bool focused
    }

    Component {
        id: windowComp
        NiriWindow {}
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
