pragma ComponentBehavior: Bound

import qs.src.components
import qs.src
import QtQuick.Layouts
import QtQuick
import Quickshell
import Quickshell.Widgets
import qs.src.services

Item {
    id: root
    implicitWidth: 22

    property bool popupOpen: false

    StyledIcon {
        iconName: Audio.getVolumeIconName()
        size: 22
        anchors.centerIn: parent
        onClicked: volumePopup.opened = !volumePopup.opened
    }

    StyledPopup {
        id: volumePopup
        anchor {
            rect {
                y: 25
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

                        StyledIcon {
                            iconName: "graphic_eq"
                            size: 24
                            anchors.centerIn: parent
                        }
                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: {
                                Quickshell.execDetached("pavucontrol");
                            }
                            scale: mouseArea.containsMouse ? 1.4 : 1.0
                        }
                    }
                }
            }

            ColumnLayout {
                id: dropdowns
                spacing: 4

                property var sinkDescriptions: Audio.sinks.map(s => s.description)
                property var sourceDescriptions: Audio.sources.map(s => s.description)

                StyledComboBox {
                    modelData: dropdowns.sinkDescriptions
                    defaultIndex: Audio.sinks.findIndex(s => s.id === Audio.sink?.id)
                    onActivated: function (index) {
                        Audio.setDefaultSink(Audio.sinks[index]);
                    }
                    iconName: "headphones"
                    Layout.fillWidth: true
                }

                StyledComboBox {
                    modelData: dropdowns.sourceDescriptions
                    defaultIndex: Audio.sources.findIndex(s => s.id === Audio.source?.id)
                    onActivated: function (index) {
                        Audio.setDefaultSource(Audio.sources[index]);
                    }
                    iconName: "mic"
                    Layout.fillWidth: true
                }
            }

            ColumnLayout {
                id: sliders
                spacing: 4

                StyledContainer {
                    Layout.fillWidth: true
                    margin: 8
                    radius: 12

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        StyledIcon {
                            iconName: Audio.sink.audio.muted ? "headset_off" : "headphones"
                            size: 20
                            onClicked: Audio.toggleSinkMute()
                        }

                        StyledSlider {
                            id: sinkControl
                            value: Audio.sink.audio.volume
                            to: 1.5
                            onMoved: {
                                Audio.sink.audio.volume = sinkControl.value;
                            }
                        }

                        Item {
                            implicitWidth: metric.width
                            Layout.alignment: Qt.AlignVCenter
                            TextMetrics {
                                id: metric
                                text: "100%"
                            }

                            StyledText {
                                anchors.centerIn: parent
                                text: Math.round(sinkControl.value * 100, 0) + "%"
                            }
                        }
                    }
                }

                StyledContainer {
                    Layout.fillWidth: true
                    margin: 8
                    radius: 12

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        WrapperMouseArea {
                            onClicked: Audio.toggleSourceMute()
                            StyledIcon {
                                iconName: Audio.source.audio.muted ? "mic_off" : "mic"
                                onClicked: Audio.toggleSourceMute()
                                size: 20
                            }
                        }

                        StyledSlider {
                            id: sourceControl
                            value: Audio.source.audio.volume
                            to: 1.5
                            onMoved: {
                                Audio.source.audio.volume = sourceControl.value;
                            }
                        }

                        Item {
                            implicitWidth: metric.width
                            Layout.alignment: Qt.AlignVCenter

                            StyledText {
                                anchors.centerIn: parent
                                text: Math.round(sourceControl.value * 100, 0) + "%"
                            }
                        }
                    }
                }
            }
        }
    }
}
