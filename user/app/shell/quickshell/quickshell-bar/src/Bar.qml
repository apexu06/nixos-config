pragma ComponentBehavior: Bound
import QtQuick.Layouts
import QtQuick
import Quickshell.Io
import qs.src.components
import qs.src
import qs.src.widgets
import qs.src.widgets.clock

Rectangle {
    id: root
    required property var screen

    anchors.fill: parent

    // border {
    //     color: Theme.border
    //     width: 1
    // }
    color: Theme.layer0

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8

        WorkspaceWidget {}
        Item {
            Layout.fillWidth: true
        }
        ClockWidget {}

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
