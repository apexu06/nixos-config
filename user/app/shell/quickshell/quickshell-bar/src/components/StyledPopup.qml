pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.src

PopupWindow {
    id: root
    color: "transparent"

    property int animationDuration: 400
    property alias width: root.implicitWidth
    property alias height: root.implicitHeight
    required property Component content
    property bool closeOnOutsideClick: false
    property bool opened: false

    implicitWidth: popupContent.implicitWidth
    implicitHeight: popupContent.implicitHeight + 20

    HyprlandFocusGrab {
        active: root.opened
        windows: [root]
        onCleared: root.opened = false
    }

    StyledContainer {
        id: popupContent
        radius: 16
        y: -460
        margin: 8
        leftMargin: 8
        rightMargin: 8
        backgroundColor: Theme.tlayer0
        border.width: 0

        states: State {
            name: "opened"
            when: root.opened
            PropertyChanges {
                popupContent {
                    y: 0
                }
            }
        }

        transitions: [
            Transition {
                from: ""
                to: "opened"
                SequentialAnimation {
                    ScriptAction {
                        script: root.visible = true
                    }

                    NumberAnimation {
                        target: popupContent
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: root.animationDuration
                    }
                }
            },
            Transition {
                from: "opened"
                to: ""
                SequentialAnimation {
                    PauseAnimation {
                        duration: root.animationDuration
                    }
                    ScriptAction {
                        script: root.visible = false
                    }
                }
            }
        ]

        Behavior on y {
            NumberAnimation {
                duration: root.animationDuration
                easing.type: Easing.OutBack
                easing.overshoot: 1.5
            }
        }

        child: Loader {
            id: loader
            active: root.visible
            sourceComponent: root.content
        }

        implicitWidth: loader.sourceComponent ? loader.sourceComponent.width : 0
        implicitHeight: loader.sourceComponent ? loader.sourceComponent.height : 0

        MouseArea {
            anchors.fill: parent
            onClicked: mouseX.accepted = true
            onPressed: mouseX.accepted = true
        }
    }
}
