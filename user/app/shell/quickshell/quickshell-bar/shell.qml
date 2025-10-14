pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import "src"
import Quickshell
import QtQuick

Scope {
    Variants {
        model: Quickshell.screens
        PanelWindow {
            id: toplevel
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            margins {
                left: 4
                right: 4
                top: 4
            }

            color: "transparent"
            implicitHeight: 48

            Bar {}
        }
    }
}
