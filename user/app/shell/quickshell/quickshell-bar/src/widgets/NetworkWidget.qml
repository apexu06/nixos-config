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

            StyledComboBox {
                visible: Network.wifiEnabled
                modelData: Array.from(Network.wifiNetworks).map(n => n.ssid)
                defaultIndex: Array.from(Network.wifiNetworks).findIndex(n => n.ssid === Network.active?.ssid)
                icon: StyledIcon {
                    iconName: Network.wifiScanning ? "progress_activity" : Network.wifiStatus === "disconnected" ? "wifi_off" : "wifi"
                    size: 22
                    rotation: !Network.wifiScanning && 0
                    onClicked: !Network.wifiScanning && Network.rescanWifi()

                    PropertyAnimation on rotation {
                        loops: Animation.Infinite
                        duration: 1200
                        from: 0
                        to: 360
                        running: Network.wifiScanning
                    }
                }

                onActivated: idx => {
                    const activeIndex = Array.from(Network.wifiNetworks).findIndex(n => n.ssid === Network.active?.ssid);
                    if (idx === activeIndex) {
                        Network.disconnectWifiNetwork();
                        index = -1;
                    } else {
                        Network.connectToWifiNetwork(Network.wifiNetworks[idx]);
                    }
                }

                Layout.fillWidth: true
            }
        }
    }
}
