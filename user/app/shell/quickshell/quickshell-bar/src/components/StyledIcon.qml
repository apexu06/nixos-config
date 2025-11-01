pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs.src
import qs.src.services
import Quickshell.Widgets

Item {
    id: root
    required property string iconName
    property real fill: 0
    property int grad: 0
    property real size: 22
    property bool hoverEnabled: true
    property bool active: false
    signal clicked

    implicitWidth: size + 10
    implicitHeight: size + 10

    Text {
        id: icon
        anchors.centerIn: parent
        font {
            family: "Material Symbols Rounded"
            pixelSize: root.size
            hintingPreference: Font.PreferFullHinting

            variableAxes: {
                // "FILL": root.fill,
                "opsz": icon.fontInfo.pixelSize,
                "GRAD": root.grad,
                "wght": icon.fontInfo.weight
            }
        }
        renderType: Text.QtRendering
        color: mouseArea.containsMouse || root.active ? Theme.accent : Theme.fg
        scale: mouseArea.containsMouse || root.active ? 1.2 : 1.0
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
        hoverEnabled: root.hoverEnabled
        onClicked: root.clicked()
    }
}
