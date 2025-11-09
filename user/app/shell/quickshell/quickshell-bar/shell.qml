//@ pragma IconTheme Papirus
//@ pragma UseQApplication

pragma ComponentBehavior: Bound
import QtQuick
import qs.src
import qs.src.components
import Quickshell
import QtQuick

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
            implicitHeight: 50

            Bar {
                screen: toplevel.modelData
            }

            RoundCorner {
                color: "#ff0000"
                implicitSize: 18
                corner: RoundCorner.CornerEnum.BottomRight
            }
        }
    }
}
