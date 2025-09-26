pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import "clock"
import ".."

Scope {
    Variants {
        model: Quickshell.screens
        PanelWindow {

            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 40
            color: "transparent"

            ClockWidget {}
        }
    }
}
