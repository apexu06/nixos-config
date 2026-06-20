pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import qs.src
import qs.src.components

PanelWindow {
    id: root

    // --- Public API ---
    /** Component to display in the center of the screen. */
    required property Component content

    /** Whether the overlay closes when clicking outside. */
    property bool closeOnOutsideClick: true

    /** Whether the overlay is currently visible. */
    property bool opened: false

    /** Animation duration in ms. */
    property int animationDuration: 180

    // --- Window setup ---
    color: "transparent"
    visible: opened
    anchors {
        top: true
        left: true
        right: true
    }
    // exclusionMode: ExclusionMode.Ignore

    // --- Behavior ---
    Behavior on visible {
        NumberAnimation {
            duration: root.animationDuration
        }
    }

    // --- Close on click outside ---
    MouseArea {
        anchors.fill: parent
        enabled: root.closeOnOutsideClick
        onClicked: root.opened = false
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.tlayer0
    }

    // --- Centered content ---
    Loader {
        id: contentLoader
        anchors.fill: parent
        active: root.opened
        sourceComponent: root.content
    }
}
