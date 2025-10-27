pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.src

Slider {
    id: control
    hoverEnabled: true

    from: 0
    value: 0.5
    to: 1
    Layout.fillWidth: true

    background: Rectangle {
        id: background
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        width: control.availableWidth
        height: control.hovered ? control.height + 2 : control.height
        color: Theme.tlayer3
        radius: width / 2

        Behavior on height {
            NumberAnimation {
                duration: 100
            }
        }

        Rectangle {
            width: control.visualPosition * (parent.width)
            height: parent.height
            color: Theme.accent
            radius: 8
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 16
        implicitHeight: 16
        radius: width / 2
        color: "transparent"
    }
}
