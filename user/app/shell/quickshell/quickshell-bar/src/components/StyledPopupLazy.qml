pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.src

LazyLoader {
    id: loader

    property int animationDuration: 400
    required property Component content
    required property var anchorItem
    required property int anchorX
    required property int anchorY
    property bool closeOnOutsideClick: false
    property bool opened: fals

    PopupWindow {
        id: root
        visible: true
        color: "transparent"

        implicitWidth: popupContent.implicitWidth
        implicitHeight: popupContent.implicitHeight + 20

        HyprlandFocusGrab {
            active: loader.active
            windows: [root]
            onCleared: loader.active = false
        }

        anchor.rect.x: loader.anchorX
        anchor.rect.y: loader.anchorY
        anchor.item: loader.anchorItem

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
                when: loader.active
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
                    ScriptAction {
                        script: loader.active = true
                    }
                },
                Transition {
                    from: "opened"
                    to: ""
                    SequentialAnimation {
                        PauseAnimation {
                            duration: loader.animationDuration
                        }
                        // ScriptAction {
                        //     script: loader.active = false
                        // }
                    }
                }
            ]

            Behavior on y {
                NumberAnimation {
                    duration: loader.animationDuration
                    easing.type: Easing.OutBack
                    easing.overshoot: 1.5
                }
            }

            child: Loader {
                id: contentLoader
                active: loader.active
                sourceComponent: loader.content
            }

            implicitWidth: contentLoader.sourceComponent ? contentLoader.sourceComponent.width : 0
            implicitHeight: contentLoader.sourceComponent ? contentLoader.sourceComponent.height : 0
        }
    }
}
