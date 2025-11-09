//@ pragma IconTheme Papirus
//@ pragma UseQApplication

pragma ComponentBehavior: Bound
import QtQuick
import qs.src
import qs.src.components
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.src.components

Scope {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: toplevel
            required property ShellScreen modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            color: "transparent"
            implicitHeight: 74
            exclusiveZone: 50
            WlrLayershell.layer: WlrLayer.Bottom

            Bar {
                screen: toplevel.modelData
            }

            RowLayout {
                anchors.fill: parent

                Rectangle {
                    Layout.fillHeight: true

                    RoundCorner {
                        color: Theme.layer0
                        implicitSize: 24
                        corner: RoundCorner.CornerEnum.TopLeft
                        anchors.bottom: parent.bottom
                    }
                }

                Item {
                    Layout.fillWidth: true
                }

                Rectangle {
                    Layout.fillHeight: true

                    RoundCorner {
                        color: Theme.layer0
                        implicitSize: 24
                        corner: RoundCorner.CornerEnum.TopRight
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                    }
                }
            }
        }
    }
}
