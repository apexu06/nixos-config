import QtQuick
import QtQuick.Effects
import qs.src

Item {
    id: root
    required property string iconName
    required property real size

    implicitWidth: size
    implicitHeight: size

    Image {
        id: icon
        anchors.centerIn: parent
        source: "image://icon/" + root.iconName
        sourceSize.width: root.size / 2
        sourceSize.height: root.size / 2
        scale: mouseArea.containsMouse ? 1.25 : 1.0

        Behavior on scale {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutBack
                easing.overshoot: 1.2
            }
        }

        Behavior on source {
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

    MultiEffect {
        anchors.fill: icon
        source: icon
        colorization: 1.0
        colorizationColor: mouseArea.containsMouse ? Theme.accent : Theme.fg
        scale: icon.scale

        Behavior on colorizationColor {
            ColorAnimation {
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }
}
