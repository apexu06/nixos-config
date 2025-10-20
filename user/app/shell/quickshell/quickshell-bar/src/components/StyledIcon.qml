pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import qs.src
import Quickshell.Widgets

Item {
    id: root
    required property string iconName
    property real size: 22
    signal clicked

    implicitWidth: size
    implicitHeight: size

    Text {
        id: icon
        anchors.centerIn: parent
        font {
            family: "Material Symbols Rounded"
            pixelSize: root.size
        }
        renderType: Text.QtRendering
        color: mouseArea.containsMouse ? Theme.accent : Theme.fg
        scale: mouseArea.containsMouse ? 1.2 : 1.0
        text: root.iconName

        Behavior on scale {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutBack
                easing.overshoot: 1.2
            }
        }

        Behavior on text {
            SequentialAnimation {
                NumberAnimation {
                    target: icon
                    property: "opacity"
                    to: 0
                    duration: 150
                    easing.type: Easing.InCubic
                }
                PropertyAction {}
                NumberAnimation {
                    target: icon
                    property: "opacity"
                    to: 1
                    duration: 150
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
    }
}
