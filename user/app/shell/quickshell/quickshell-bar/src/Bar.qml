pragma ComponentBehavior: Bound
import QtQuick.Layouts
import QtQuick
import Quickshell.Io
import qs.src.components
import qs.src
import qs.src.widgets
import qs.src.widgets.clock

Rectangle {
    anchors.fill: parent
    radius: 12
    border {
        color: Theme.border
        width: 1
    }
    color: Theme.withAlpha(Theme.base00, 0.5)

    RowLayout {
        anchors.fill: parent
        anchors.margins: 6

        Workspaces {}
        Item {
            Layout.fillWidth: true
        }
        ClockWidget {}

        Item {
            Layout.fillWidth: true
        }

        StyledContainer {
            Volume {}
        }
    }

    Process {
        id: process
    }
}
