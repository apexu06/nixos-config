import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.src

WrapperRectangle {
    id: root

    property alias backgroundColor: root.color
    property alias customRadius: root.radius
    property alias customOpacity: root.opacity

    Layout.fillHeight: true
    leftMargin: 12
    rightMargin: 12
    border.width: 1
    border.color: Theme.border

    color: Theme.tlayer1
    radius: 100000

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }
}

// }
