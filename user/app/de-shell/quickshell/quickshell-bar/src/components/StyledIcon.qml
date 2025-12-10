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
    property color color: Theme.fg
    property color hoverColor: Theme.accent
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
        color: mouseArea.containsMouse || root.active ? root.hoverColor : root.color
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
            FadeAnimation {
                target: icon
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
