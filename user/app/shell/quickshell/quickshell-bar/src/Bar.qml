pragma ComponentBehavior: Bound
import QtQuick.Layouts
import QtQuick
import "./components"
import "./widgets/clock"
import "./widgets/"

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
        anchors.leftMargin: 8
        anchors.rightMargin: 8

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
}
