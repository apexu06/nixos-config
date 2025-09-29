pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Controls
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

            Rectangle {
                readonly property ColorGroup colors: Window.active ? palette.active : palette.inactive

                color: Appearance

                Text {
                    text: "hello"
                }
            }

            ClockWidget {}
        }
    }
}
