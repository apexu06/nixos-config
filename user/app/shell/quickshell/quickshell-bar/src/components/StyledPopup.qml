pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.src

LazyLoader {
    id: root
    required property Component content
    property int animationDuration: 200
    property bool opened: false
    property bool horizontal: false

    property bool top: true
    property bool left: false
    property bool right: true
    property bool bottom: false

    property int mLeft: 4
    property int mRight: 4
    property int mTop: 4
    property int mBottom: 4

    function toggle() {
        if (!opened) {
            active = true;
            opened = true;
        } else {
            opened = false;
        }
    }

    PanelWindow {
        id: popup
        visible: true
        color: "transparent"

        implicitWidth: popupContent.implicitWidth
        implicitHeight: popupContent.implicitHeight

        anchors {
            top: root.top
            left: root.left
            right: root.right
            bottom: root.bottom
        }

        margins {
            top: root.mTop
            left: root.mLeft
            right: root.mRight
            bottom: root.mBottom
        }

        StyledContainer {
            id: popupContent
            radius: 16
            y: root.horizontal ? 0 : -500
            x: root.horizontal ? 500 : 0
            margin: 16
            leftMargin: 16
            rightMargin: 16
            color: Theme.layer0

            states: State {
                name: "opened"
                when: root.opened
                PropertyChanges {
                    popupContent {
                        y: 0
                        x: 0
                    }
                }
            }

            transitions: [
                Transition {
                    from: "opened"
                    to: ""
                    SequentialAnimation {
                        PauseAnimation {
                            duration: root.animationDuration
                        }
                        ScriptAction {
                            script: root.active = false
                        }
                    }
                }
            ]

            Behavior on y {
                NumberAnimation {
                    duration: root.animationDuration
                    easing.type: Easing.OutQuad
                }
            }

            Behavior on x {
                NumberAnimation {
                    duration: root.animationDuration
                    easing.type: Easing.OutQuad
                }
            }

            child: Loader {
                id: loader
                active: root.active
                sourceComponent: root.content
            }
        }
    }
}
