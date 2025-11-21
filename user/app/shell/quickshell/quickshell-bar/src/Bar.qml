pragma ComponentBehavior: Bound
import QtQuick.Layouts
import QtQuick
import Quickshell.Io
import Quickshell
import Quickshell.Wayland
import qs.src.components
import qs.src
import qs.src.widgets
import qs.src.widgets
import qs.src.widgets.clock

Rectangle {
    id: root
    required property ShellScreen screen
    implicitHeight: 50
    anchors.left: parent.left
    anchors.right: parent.right
    color: Theme.layer0

    NotificationWidget {}

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8

        RowLayout {
            id: leftSide
            spacing: 8
            Layout.preferredWidth: Math.max(leftSide.implicitWidth, rightSide.implicitWidth)

            NiriWorkspaceWidget {
                screen: root.screen
            }

            ActiveWindowWidget {}

            Item {
                Layout.fillWidth: true
            }
        }

        ClockWidget {}
        MprisWidget {}

        RowLayout {
            id: rightSide
            spacing: 8
            Layout.preferredWidth: Math.max(leftSide.implicitWidth, rightSide.implicitWidth)

            Item {
                Layout.fillWidth: true
            }

            StyledContainer {
                RowLayout {
                    spacing: 8
                    NetworkWidget {}
                    VolumeWidget {}
                    BatteryWidget {}
                }
            }

            TrayWidget {}

            StyledContainer {
                leftMargin: 4
                rightMargin: 4

                StyledIcon {
                    iconName: "power_settings_new"
                    onClicked: Quickshell.execDetached("wlogout")
                }
            }
        }
    }
}
