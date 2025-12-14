import QtQuick
import qs.src

Text {
    id: root
    property real fontSize: 13
    property alias content: root.text
    property bool bold: false
    property alias customColor: root.color

    color: Theme.fg
    text: ""
    font.pointSize: root.fontSize
    font.bold: root.bold
    renderType: Text.QtRendering
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    Behavior on color {
        ColorAnimation {
            duration: 150
        }
    }
}
