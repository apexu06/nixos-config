pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import "clock"
import QtQuick.Effects
import "./widgets"

Rectangle {
    anchors.fill: parent
    color: "transparent"

    Rectangle {
        anchors.fill: parent

        color: Theme.base00
        opacity: 0.2
    }

    StyledContainer {
        anchors.centerIn: parent

        // StyledText {
        //     id: text
        //     text: "Hello"
        // }
    }
}
