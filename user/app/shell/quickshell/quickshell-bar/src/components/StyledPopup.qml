import QtQuick
import Quickshell

PopupWindow {
    id: root
    color: "transparent"

    property int animationDuration: 300
    property alias width: root.implicitWidth
    property alias height: root.implicitHeight
    required property Component content

    implicitWidth: popupContent.implicitWidth
    implicitHeight: popupContent.implicitHeight

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onExited: {
            root.visible = false;
        }
    }

    StyledContainer {
        id: popupContent
        radius: 16

        scale: root.visible ? 1.0 : 0.7
        opacity: root.visible ? 1.0 : 0.0
        transformOrigin: Item.Top
        topMargin: 8
        leftMargin: 8
        rightMargin: 8
        bottomMargin: 8

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
            id: loader
            active: root.visible
            sourceComponent: root.content
        }

        implicitWidth: loader.item ? loader.item.implicitWidth : 0
        implicitHeight: loader.item ? loader.item.implicitHeight + 3 * margin : 0
    }
}
