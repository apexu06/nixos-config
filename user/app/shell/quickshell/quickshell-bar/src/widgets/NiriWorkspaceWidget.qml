import qs.src.components
import qs.src.services
import qs.src
import QtQuick.Layouts
import QtQuick
import Quickshell

StyledContainer {
    required property ShellScreen screen

    RowLayout {
        spacing: 0
        anchors.centerIn: parent

        implicitWidth: 400

        Repeater {
            model: Array.from(Niri.workspaces).filter(ws => ws.output === screen.name)
            delegate: Item {
                id: item
                required property Niri.NiriWorkspace modelData
                required property int index

                width: 24
                height: 10

                Rectangle {
                    id: workspace
                    radius: width / 2
                    width: item.modelData.focused ? 24 : 10
                    height: 10

                    anchors.centerIn: parent
                    color: item.modelData.focused ? Theme.accent : item.modelData.active || item.modelData.activeWindowId !== -1 ? Theme.fg : Theme.layer3

                    PropertyAnimation on color {
                        loops: Animation.Infinite
                        duration: 1200
                        from: workspace.color
                        to: Theme.destructive
                        running: item.modelData.urgent
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
