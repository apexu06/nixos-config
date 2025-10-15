pragma ComponentBehavior: Bound

import qs.src.components
import qs.src
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Effects
import QtQuick
import Quickshell
import Quickshell.Io
import qs.src.services

Item {
    id: icon
    implicitWidth: 16
    implicitHeight: 16

    property bool popupOpen: false
    property int volumeLevel: 70  // 0-100
    property bool muted: false

    function getVolumeIconName() {
        if (muted || volumeLevel === 0) {
            return "audio-volume-muted";
        } else if (volumeLevel < 33) {
            return "audio-volume-low";
        } else if (volumeLevel < 66) {
            return "audio-volume-medium";
        } else {
            return "audio-volume-high";
        }
    }

    IconImage {
        id: volumeIcon
        anchors.centerIn: parent
        width: 16
        height: 16
        source: "image://icon/" + icon.getVolumeIconName() + "-symbolic"
    }
    MultiEffect {
        source: volumeIcon
        anchors.fill: volumeIcon
        colorization: 1
        colorizationColor: Theme.fg
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            volumePopup.visible = !volumePopup.visible;
        }
    }

    StyledPopup {
        id: volumePopup
        anchor {
            rect {
                y: 40
                x: 0
            }
            item: icon
            edges: Edges.Bottom
            gravity: Edges.Bottom
        }

        content: ColumnLayout {

            StyledContainer {
                Layout.fillWidth: true
                Layout.preferredWidth: 400
                Layout.preferredHeight: 40
                customRadius: 12

                RowLayout {
                    StyledText {
                        content: "Audio"
                    }
                    Item {
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        implicitWidth: 24
                        implicitHeight: 24
                        color: Theme.layer3
                        radius: width / 2

                        Layout.topMargin: mouseArea.containsMouse ? -5 : 0

                        Behavior on Layout.topMargin {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutQuad
                            }
                        }

                        IconImage {
                            id: amogus
                            implicitWidth: 16
                            implicitHeight: 16
                            source: "image://icon/preferences-desktop-sound"
                            y: mouseArea.containsMouse ? -2 : 0
                            anchors.centerIn: parent

                            Behavior on y {
                                NumberAnimation {
                                    duration: 150
                                    easing.type: Easing.OutQuad
                                }
                            }
                        }
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                pavucontrol.exec(["pavucontrol"]);
                            }
                        }

                        Process {
                            id: pavucontrol
                        }
                    }
                }
            }
            StyledContainer {
                Layout.fillWidth: true
                Layout.preferredHeight: 80

                customRadius: 12
            }
        }
    }
}
