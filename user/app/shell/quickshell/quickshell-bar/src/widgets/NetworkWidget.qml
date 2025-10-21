pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets
import qs.src.components
import qs.src.services
import qs.src

Item {
    id: root
    implicitWidth: 22

    StyledIcon {
        iconName: Network.materialSymbol
        size: 22
        anchors.centerIn: parent
        onClicked: networkPopup.opened = !networkPopup.opened
    }

    StyledPopup {
        id: networkPopup
        opened: true

        anchor {
            rect {
                y: 25
                x: -150
            }
            item: root
        }
        onOpenedChanged: {
            if (opened)
                Network.rescanWifi();
        }

        content: ColumnLayout {
            spacing: 8
            StyledContainer {
                Layout.fillWidth: true
                Layout.preferredWidth: 400
                Layout.preferredHeight: 45
                customRadius: 12

                RowLayout {
                    StyledText {
                        content: "Wifi"
                        bold: true
                    }
                    Item {
                        Layout.fillWidth: true
                    }

                    StyledSwitch {
                        checked: Network.wifiEnabled
                        onClicked: {
                            Network.toggleWifi();
                            if (Network.wifiEnabled) {
                                Network.rescanWifi();
                            }
                        }
                    }
                }
            }

            StyledContainer {
                Layout.fillWidth: true
                Layout.fillHeight: true
                leftMargin: 8
                rightMargin: 8
                bottomMargin: 8
                topMargin: 8
                radius: 12

                ColumnLayout {
                    width: parent.width
                    spacing: 4

                    Repeater {
                        model: Network.wifiNetworks.map(n => n.ssid)
                        delegate: StyledContainer {
                            id: container
                            required property string modelData
                            required property int index
                            property bool expanded: false
                            property bool isCurrent: modelData === Network.active?.ssid

                            margin: 4
                            topMargin: 6
                            bottomMargin: 6
                            customRadius: 12
                            color: hover.hovered ? Theme.layer2 : Theme.tlayer1
                            clip: true
                            Layout.fillWidth: true

                            TapHandler {
                                enabled: !container.expanded
                                onTapped: container.expanded = true
                            }

                            HoverHandler {
                                id: hover
                                enabled: !container.expanded
                            }

                            Behavior on height {
                                NumberAnimation {
                                    duration: 200
                                }
                            }

                            Column {
                                id: contentColumn
                                width: parent.width
                                spacing: 8

                                RowLayout {
                                    width: parent.width

                                    StyledIcon {
                                        iconName: Network.getStrengthIcon(Network.wifiNetworks[container.index]?.strength)
                                        size: 18
                                    }

                                    StyledText {
                                        text: container.modelData
                                    }

                                    Item {
                                        Layout.fillWidth: true
                                    }

                                    StyledIcon {
                                        iconName: "keyboard_arrow_down"
                                        rotation: container.expanded ? 180 : 0
                                        onClicked: container.expanded = !container.expanded
                                        Behavior on rotation {
                                            NumberAnimation {
                                                duration: 150
                                                easing.type: Easing.OutQuad
                                            }
                                        }
                                    }
                                }

                                Row {
                                    id: row
                                    visible: container.expanded
                                    Layout.fillWidth: true
                                    width: parent.width

                                    WrapperRectangle {
                                        property color buttonColor: container.isCurrent ? Theme.destructive : Theme.accent

                                        y: container.expanded ? 0 : contentColumn.height
                                        Behavior on y {
                                            NumberAnimation {
                                                duration: 400
                                                easing.overshoot: 1.5
                                                easing.type: Easing.OutBack
                                            }
                                        }

                                        margin: 4
                                        leftMargin: 8
                                        rightMargin: 8
                                        radius: width / 2
                                        width: parent.width
                                        Layout.fillWidth: true
                                        color: itemHover.hovered ? buttonColor : "transparent"
                                        border {
                                            width: 2
                                            color: buttonColor
                                        }

                                        Behavior on color {
                                            ColorAnimation {
                                                duration: 100
                                            }
                                        }

                                        HoverHandler {
                                            id: itemHover
                                            target: parent
                                        }

                                        StyledText {
                                            text: container.isCurrent ? "Disconnect" : "Connect"
                                            color: itemHover.hovered ? Theme.layer0 : parent.buttonColor
                                            horizontalAlignment: Text.AlignHCenter
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // StyledComboBox {
            //     visible: Network.wifiEnabled
            //     modelData: Array.from(Network.wifiNetworks).map(n => n.ssid)
            //     defaultIndex: Array.from(Network.wifiNetworks).findIndex(n => n.ssid === Network.active?.ssid)
            //     icon: StyledIcon {
            //         iconName: Network.wifiScanning ? "progress_activity" : Network.wifiStatus === "disconnected" ? "wifi_off" : "wifi"
            //         size: 22
            //         rotation: !Network.wifiScanning && 0
            //         onClicked: !Network.wifiScanning && Network.rescanWifi()
            //
            //         PropertyAnimation on rotation {
            //             loops: Animation.Infinite
            //             duration: 1200
            //             from: 0
            //             to: 360
            //             running: Network.wifiScanning
            //         }
            //     }
            //
            //     onActivated: idx => {
            //         const activeIndex = Array.from(Network.wifiNetworks).findIndex(n => n.ssid === Network.active?.ssid);
            //         if (idx === activeIndex) {
            //             Network.disconnectWifiNetwork();
            //             index = -1;
            //         } else {
            //             Network.connectToWifiNetwork(Network.wifiNetworks[idx]);
            //         }
            //     }
            //
            //     Layout.fillWidth: true
            // }
        }
    }
}
