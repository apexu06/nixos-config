pragma ComponentBehavior: Bound

import qs.src.components
import qs.src
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick
import Quickshell
import qs.src.services

Item {
    id: root
    implicitWidth: 16
    implicitHeight: 16

    property bool popupOpen: false

    StyledIcon {
        iconName: Audio.getVolumeIconName()
        size: 16
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            volumePopup.visible = !volumePopup.visible;
        }
    }

    StyledPopup {
        id: volumePopup
        visible: true
        anchor {
            rect {
                y: 40
                x: 0
            }
            item: root
            edges: Edges.Bottom
            gravity: Edges.Bottom
        }

        content: ColumnLayout {
            spacing: 8

            StyledContainer {
                Layout.fillWidth: true
                Layout.preferredWidth: 400
                Layout.preferredHeight: 50
                customRadius: 12

                color: Theme.layer1

                RowLayout {
                    StyledText {
                        content: "Audio"
                        bold: true
                    }
                    Item {
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        implicitWidth: 36
                        implicitHeight: 36
                        color: mouseArea.containsMouse ? Theme.accent : Theme.layer2
                        radius: width / 2

                        Behavior on color {
                            ColorAnimation {
                                duration: 200
                                easing.type: Easing.InOutCubic
                            }
                        }

                        IconImage {
                            implicitWidth: 16
                            implicitHeight: 16
                            source: "image://icon/preferences-desktop-sound"
                            anchors.centerIn: parent
                        }
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                process.exec(["pavucontrol"]);
                            }
                            scale: mouseArea.containsMouse ? 1.4 : 1.0
                        }
                    }
                }
            }

            ColumnLayout {
                id: dropdowns

                property var sinkDescriptions: Audio.sinks.map(s => s.description)
                property var sourceDescriptions: Audio.sources.map(s => s.description)

                StyledComboBox {
                    modelData: dropdowns.sinkDescriptions
                    defaultIndex: Audio.sinks.findIndex(s => s.id === Audio.sink?.id)
                    onActivated: function (index) {
                        Audio.setDefaultSink(Audio.sinks[index]);
                    }
                    iconName: "audio-headphones-symbolic"
                    Layout.fillWidth: true
                }

                StyledComboBox {
                    modelData: dropdowns.sourceDescriptions
                    defaultIndex: Audio.sources.findIndex(s => s.id === Audio.source?.id)
                    onActivated: function (index) {
                        Audio.setDefaultSink(Audio.sinks[index]);
                    }
                    iconName: "audio-input-microphone"
                    Layout.fillWidth: true
                }
            }
        }
    }
}
