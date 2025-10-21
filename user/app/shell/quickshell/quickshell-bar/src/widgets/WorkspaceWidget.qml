import qs.src.components
import qs.src
import QtQuick.Layouts
import Quickshell.Hyprland
import QtQuick

StyledContainer {
    Layout.alignment: Qt.AlignLeft
    backgroundColor: Theme.tlayer0

    RowLayout {
        spacing: 0
        anchors.centerIn: parent

        Repeater {
            model: 6
            delegate: Item {
                id: item

                required property int index

                property int workspaceId: index + 1
                readonly property bool isActive: workspaceId === Hyprland.focusedWorkspace?.id
                readonly property bool exists: Hyprland.workspaces.values.some(w => w.id === workspaceId)
                readonly property bool isUrgent: {
                    var ws = Hyprland.workspaces.values[workspaceId];
                    return ws ? ws.urgent : false;
                }

                width: 24
                height: 10

                Rectangle {
                    id: workspace
                    radius: width / 2
                    width: item.isActive ? 24 : 10
                    height: 10

                    anchors.centerIn: parent

                    color: item.isActive ? Theme.accent : item.exists ? Theme.fg : Theme.layer3

                    PropertyAnimation on color {
                        loops: Animation.Infinite
                        duration: 1200
                        from: workspace.color
                        to: Theme.destructive
                        running: item.isUrgent
                        easing.type: Easing.InOutQuad
                    }

                    Behavior on color {
                        ColorAnimation {
                            duration: 200
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Behavior on width {
                        NumberAnimation {
                            duration: 200
                            easing.type: Easing.OutQuad
                        }
                    }
                }
            }
        }
    }
}
