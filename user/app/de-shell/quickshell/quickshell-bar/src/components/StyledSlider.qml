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

    Layout.fillWidth: control.orientation === Qt.Horizontal
    Layout.fillHeight: control.orientation === Qt.Vertical
    rotation: orientation === Qt.Vertical ? 180 : 0

    background: Rectangle {
        id: background
        readonly property int thickness: control.implicitHeight

        x: control.leftPadding + (control.orientation === Qt.Horizontal ? 0 : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.orientation === Qt.Horizontal ? (control.availableHeight - height) / 2 : 0)

        width: control.orientation === Qt.Horizontal ? control.availableWidth : (control.hovered ? thickness + 2 : thickness)

        height: control.orientation === Qt.Horizontal ? (control.hovered ? thickness + 2 : thickness) : control.availableHeight

        color: Theme.layer2
        radius: Math.min(width, height) / 2

        Behavior on width {
            NumberAnimation {
                duration: 100
            }
        }
        Behavior on height {
            NumberAnimation {
                duration: 100
            }
        }

        Rectangle {
            // fill from bottom, growing upward
            x: 0
            y: 0  // Start from top
            width: control.orientation === Qt.Horizontal ? control.visualPosition * parent.width : parent.width
            height: control.orientation === Qt.Horizontal ? parent.height : control.visualPosition * parent.height
            color: Theme.accent
            radius: Math.min(width, height) / 2
        }
    }

    handle: Rectangle {
        implicitWidth: 16
        implicitHeight: 16
        radius: width / 2
        color: "transparent"

        x: control.leftPadding + (control.orientation === Qt.Horizontal ? control.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)

        // max at top, min at bottom
        y: control.topPadding + (control.orientation === Qt.Horizontal ? (control.availableHeight - height) / 2 : control.visualPosition * (control.availableHeight - height))
    }
}
