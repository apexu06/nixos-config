import qs.src
import QtQuick
import QtQuick.Controls

Switch {
    id: control

    indicator: Rectangle {
        implicitWidth: 48
        implicitHeight: 24
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: width / 2

        color: control.checked ? Theme.accent : Theme.layer3

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }

        Rectangle {
            x: control.checked ? parent.width - width : 0
            width: 24
            height: 24
            radius: width / 2
            color: control.checked ? Theme.fg : Theme.accent

            Behavior on color {
                ColorAnimation {
                    duration: 150
                }
            }

            Behavior on x {
                SmoothedAnimation {
                    velocity: 100
                }
            }
        }
    }
}
