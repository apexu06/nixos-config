import QtQuick
import Quickshell.Widgets
import ".."

Rectangle {
    anchors.centerIn: parent

    color: "#ff0000"
    radius: 100000

    StyledText {
        text: "hello"
    }
}

// WrapperRectangle {
//     id: root
//
//     property alias backgroundColor: root.color
//     property alias customRadius: root.radius
//     property alias customOpacity: root.opacity
//
//     anchors.centerIn: parent
//     color: "#ff0000"
//     radius: 100000
//     margin: 4
//     rightMargin: 12
//     leftMargin: 12
//
//     Rectangle {
//         anchors.fill: parent
//         color: Theme.layer0
//         opacity: 0.4
//     }
//
//     StyledText {
//         id: text
//         text: "test"
//     }
//
//     child: text
// }
