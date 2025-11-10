pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import qs.src
import qs.src.components
import qs.src.services
import Quickshell.Services.UPower
import Quickshell.Widgets

Item {
    id: root
    implicitWidth: 22
    visible: Battery.available

    StyledIcon {
        iconName: Battery.getBatteryIcon()
        fill: 1
        size: 22
        anchors.centerIn: parent
        onClicked: batteryIcon.toggle()
        active: batteryIcon.opened ?? false
    }

    StyledPopup {
        id: batteryIcon

        horizontal: true
        anchorItem: root

        content: ColumnLayout {
            spacing: 8

            StyledContainer {
                Layout.fillWidth: true
                Layout.preferredWidth: 400
                Layout.preferredHeight: 50
                customRadius: 12

                RowLayout {
                    StyledText {
                        content: "Battery"
                        bold: true
                    }
                    Item {
                        Layout.fillWidth: true
                    }

                    StyledText {
                        text: {
                            function formatTime(seconds) {
                                var h = Math.floor(seconds / 3600);
                                var m = Math.floor((seconds % 3600) / 60);
                                if (h > 0)
                                    return `${h}h, ${m}m`;
                                else
                                    return `${m}m`;
                            }
                            if (Battery.isCharging)
                                return formatTime(Battery.timeToFull) + " until full";
                            else
                                return formatTime(Battery.timeToEmpty) + " remaining";
                        }
                    }
                }
            }

            RowLayout {
                uniformCellSizes: true
                Layout.preferredHeight: 60

                Repeater {
                    model: [
                        {
                            profile: PowerProfile.Performance,
                            icon: "speed",
                            color: Theme.destructive
                        },
                        {
                            profile: PowerProfile.Balanced,
                            icon: "balance",
                            color: Theme.accent
                        },
                        {
                            profile: PowerProfile.PowerSaver,
                            icon: "eco",
                            color: Theme.success
                        }
                    ]
                    delegate: WrapperMouseArea {
                        id: mouseArea
                        required property var modelData
                        required property int index

                        property bool activated: PowerProfiles.profile === modelData.profile || mouseArea.containsMouse

                        hoverEnabled: true
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        onClicked: PowerProfiles.profile = modelData.profile
                        StyledContainer {
                            Layout.fillWidth: true
                            radius: 12
                            border.color: parent.activated ? parent.modelData.color : Theme.border
                            border.width: 2

                            child: Text {
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font {
                                    family: "Material Symbols Rounded"
                                    pixelSize: 28
                                    hintingPreference: Font.PreferFullHinting
                                }
                                renderType: Text.QtRendering
                                text: mouseArea.modelData.icon
                                color: mouseArea.activated ? mouseArea.modelData.color : Theme.fg
                                scale: mouseArea.containsMouse ? 1.2 : 1.0

                                Behavior on scale {
                                    NumberAnimation {
                                        duration: 200
                                        easing.type: Easing.OutBack
                                        easing.overshoot: 1.5
                                    }
                                }

                                Behavior on color {
                                    ColorAnimation {
                                        duration: 150
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                implicitHeight: 20

                StyledSlider {
                    anchors.fill: parent
                    hoverEnabled: false
                    value: Battery.percentage

                    MouseArea {
                        anchors.fill: parent
                        enabled: true
                        onClicked: function (mouse) {
                            mouse.accepted = true;
                        }
                        onPressed: function (mouse) {
                            mouse.accepted = true;
                        }
                        onReleased: function (mouse) {
                            mouse.accepted = true;
                        }
                    }
                }

                StyledText {
                    text: Math.round(Battery.percentage * 100, 0) + "%"
                    anchors.fill: parent
                }
            }
        }
    }
}
