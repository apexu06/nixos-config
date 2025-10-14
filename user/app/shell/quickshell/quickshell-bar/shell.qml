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
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            color: "transparent"
            implicitHeight: 48

            Bar {}
        }
    }
}
