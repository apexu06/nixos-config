pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.src

LazyLoader {
    id: root
    required property Component content
    required property var anchorItem
    property int animationDuration: 500
    property bool opened: false

    property list<real> enterCurve: [0.38, 1.21, 0.22, 1, 1, 1]
    property list<real> exitCurve: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]

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
            left: true
            top: true
            bottom: true
            right: true
        }

        WlrLayershell.exclusiveZone: -1

        mask: Region {
            item: Rectangle {
                x: 0
                y: 0
                width: popup.width
                height: popup.height
            }
        }

        MouseArea {
            anchors.fill: parent
            z: -1
            enabled: root.opened
            acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

            onClicked: mouse => {
                // Calculate popup content position and bounds
                const contentX = popupContent.x;
                const contentY = popupContent.y;
                const clickX = mouse.x;
                const clickY = mouse.y;

                const outsideContent = clickX < contentX || clickX > contentX + popupContent.width || clickY < contentY || clickY > contentY + popupContent.height;

                if (outsideContent) {
                    root.toggle();
                }
            }
        }

        StyledContainer {
            id: popupContent
            radius: 16
            scale: 0.90
            opacity: 0
            margin: 16
            leftMargin: 16
            rightMargin: 16
            color: Theme.layer0

            x: {
                if (!root.anchorItem)
                    return 100;

                // Get the anchor item's position in screen coordinates
                const itemPos = root.anchorItem.mapToItem(null, 0, 0);
                return itemPos.x - width / 2;
            }

            y: {
                if (!root.anchorItem)
                    return 100;

                // Get the anchor item's position in screen coordinates
                const itemPos = root.anchorItem.mapToItem(null, 0, 0);
                return itemPos.y + 85; // 30px offset like your original anchor.rect.y
            }

            states: State {
                name: "opened"
                when: root.opened
                PropertyChanges {
                    popupContent {
                        scale: 1
                        opacity: 1
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

            Behavior on opacity {
                enabled: root.opened
                NumberAnimation {
                    duration: root.animationDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: root.opened ? root.enterCurve : root.exitCurve
                }
            }

            Behavior on scale {
                NumberAnimation {
                    duration: root.animationDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: root.opened ? root.enterCurve : root.exitCurve
                }
            }

            child: Loader {
                id: loader
                active: root.active
                sourceComponent: root.content
                opacity: root.opened ? 1 : 0

                Behavior on opacity {
                    NumberAnimation {
                        duration: root.animationDuration
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: root.opened ? root.enterCurve : root.exitCurve
                    }
                }
            }
        }
    }
}
