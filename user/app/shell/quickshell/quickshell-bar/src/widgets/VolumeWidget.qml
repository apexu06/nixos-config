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
        onClicked: volumePopup.toggle()
        active: volumePopup.opened ?? false
    }

    StyledPopup {
        id: volumePopup

        horizontal: true

        content: ColumnLayout {
            spacing: 16

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

            StyledContainer {
                Layout.fillWidth: true
                radius: 12
                topMargin: dropdowns.spacing + sinks.margins
                bottomMargin: dropdowns.spacing + sinks.margins

                ColumnLayout {
                    id: dropdowns
                    spacing: 8

                    property var sinkDescriptions: Audio.sinks.map(s => s.description)
                    property var sourceDescriptions: Audio.sources.map(s => s.description)

                    StyledComboBox {
                        id: sinks
                        modelData: dropdowns.sinkDescriptions
                        defaultIndex: Audio.sinks.findIndex(s => s.id === Audio.sink?.id)
                        onActivated: function (index) {
                            Audio.setDefaultSink(Audio.sinks[index]);
                        }

                        icon: StyledIcon {
                            iconName: "headphones"
                            hoverEnabled: false
                            size: 22
                        }
                        Layout.fillWidth: true
                    }

                    StyledComboBox {
                        modelData: dropdowns.sourceDescriptions
                        defaultIndex: Audio.sources.findIndex(s => s.id === Audio.source?.id)
                        onActivated: function (index) {
                            Audio.setDefaultSource(Audio.sources[index]);
                        }
                        icon: StyledIcon {
                            iconName: "mic"
                            hoverEnabled: false
                            size: 22
                        }
                        Layout.fillWidth: true
                    }
                }
            }

            StyledContainer {
                Layout.fillWidth: true
                radius: 12
                margin: 4
                topMargin: sliders.spacing + container.margin
                bottomMargin: sliders.spacing + container.margin

                ColumnLayout {
                    id: sliders
                    spacing: 8

                    StyledContainer {
                        id: container
                        Layout.fillWidth: true
                        margin: 8
                        radius: 12

                        HoverHandler {
                            id: headphoneHover
                            enabled: true
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            StyledIcon {
                                iconName: Audio.sink.audio.muted ? "volume_off" : "volume_up"
                                size: 22
                                onClicked: Audio.toggleSinkMute()
                            }

                            StyledSlider {
                                id: sinkControl
                                implicitHeight: 10
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
                        // border.color: micHover.hovered ? Theme.border : "transparent"

                        HoverHandler {
                            id: micHover
                            enabled: true
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            WrapperMouseArea {
                                onClicked: Audio.toggleSourceMute()
                                StyledIcon {
                                    iconName: Audio.source.audio.muted ? "mic_off" : "mic"
                                    onClicked: Audio.toggleSourceMute()
                                    size: 22
                                }
                            }

                            StyledSlider {
                                id: sourceControl
                                implicitHeight: 10
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
}
