import QtQuick
import Quickshell.Widgets
import ".."

WrapperRectangle {
    id: root

    property alias backgroundColor: root.color
    property alias customRadius: root.radius
    property alias customOpacity: root.opacity

    implicitHeight: parent.height - 12
    margin: 6
    leftMargin: 12
    rightMargin: 12
    border.width: 1
    border.color: Theme.border

    color: Theme.withAlpha(Theme.layer0, 0.4)
    radius: 100000
}

// }
