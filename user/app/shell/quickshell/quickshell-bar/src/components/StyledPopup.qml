import QtQuick
import Quickshell

PopupWindow {
    id: root
    color: "transparent"

    property int animationDuration: 300
    property alias width: root.implicitWidth
    property alias height: root.implicitHeight
    required property Component content

    implicitWidth: 400
    implicitHeight: 300

    StyledContainer {
        id: popupContent
        anchors.fill: parent
        radius: 16

        scale: root.visible ? 1.0 : 0.7
        opacity: root.visible ? 1.0 : 0.0
        transformOrigin: Item.Top

        Behavior on scale {
            NumberAnimation {
                duration: root.animationDuration
                easing.type: Easing.OutBack
                easing.overshoot: 1.5
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: root.animationDuration
                easing.type: Easing.OutCubic
            }
        }

        Loader {
            active: root.visible
            sourceComponent: root.content
        }
    }
}
