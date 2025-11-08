pragma ComponentBehavior: Bound
import QtQuick.Layouts
import QtQuick
import Quickshell.Io
import Quickshell
import qs.src.components
import qs.src
import qs.src.widgets
import qs.src.widgets.clock

Rectangle {
    id: root
    required property ShellScreen screen
    anchors.fill: parent
    color: Theme.layer0

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

            Item {
                Layout.fillWidth: true
            }
        }

        ClockWidget {}

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
        }
    }
}
