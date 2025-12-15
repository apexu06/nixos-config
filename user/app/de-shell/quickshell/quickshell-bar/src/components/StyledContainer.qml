import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.src

WrapperRectangle {
    id: root

    property bool hoverEnabled: false
    property color backgroundColor: Theme.layer1
    property color hoverColor: Theme.layer2
    property alias customRadius: root.radius
    property alias customOpacity: root.opacity

    Layout.fillHeight: true

    leftMargin: 12
    rightMargin: 12
    border.width: 1
    border.color: "transparent"

    color: hover.hovered ? root.hoverColor : root.backgroundColor
    radius: width / 2

    HoverHandler {
        id: hover
        enabled: root.hoverEnabled
    }

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }

    Behavior on border.color {
        ColorAnimation {
            duration: 150
        }
    }

    Behavior on width {
        NumberAnimation {
            duration: 150
        }
    }
}
