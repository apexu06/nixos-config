pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.src

PopupWindow {
    id: root
    color: "transparent"

    property int animationDuration: 150
    property alias width: root.implicitWidth
    property alias height: root.implicitHeight
    required property Component content
    property bool closeOnOutsideClick: false
    property bool isClosing: false

    implicitWidth: popupContent.implicitWidth
    implicitHeight: popupContent.implicitHeight

    function close() {
        root.visible = false;
    }

    property var overlayWindow: closeOnOutsideClick ? overlayComponent.createObject(root) : null

    Component {
        id: overlayComponent
        PanelWindow {
            visible: root.visible
            color: "transparent"
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            exclusionMode: ExclusionMode.Ignore

            MouseArea {
                anchors.fill: parent
                onClicked: root.close()
            }
        }
    }

    StyledContainer {
        id: popupContent
        radius: 16
        y: root.visible ? 0 : -150
        margin: 8

        Behavior on y {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutBack
                easing.overshoot: 1.5
            }
        }

        child: Loader {
            id: loader
            active: root.visible
            sourceComponent: root.content
        }

        implicitWidth: loader.item ? loader.item.implicitWidth : 0
        implicitHeight: loader.item ? loader.item.implicitHeight + 3 * margin : 0

        // Block clicks from reaching the overlay
        MouseArea {
            anchors.fill: parent
            onClicked: mouse.accepted = true
            onPressed: mouse.accepted = true
        }
    }
}
