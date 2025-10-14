import "../components/"
import ".."
import QtQuick.Layouts
import Quickshell.Widgets
import QtQuick.Effects
import QtQuick
import Quickshell

Item {
    id: icon
    implicitWidth: 16
    implicitHeight: 16

    property bool popupOpen: false

    property int volumeLevel: 70  // 0-100
    property bool muted: false

    function getVolumeIconName() {
        if (muted || volumeLevel === 0) {
            return "audio-volume-muted";
        } else if (volumeLevel < 33) {
            return "audio-volume-low";
        } else if (volumeLevel < 66) {
            return "audio-volume-medium";
        } else {
            return "audio-volume-high";
        }
    }

    IconImage {
        id: volumeIcon
        anchors.centerIn: parent
        width: 16
        height: 16
        source: "image://icon/" + icon.getVolumeIconName() + "-symbolic"
    }
    MultiEffect {
        source: volumeIcon
        anchors.fill: volumeIcon
        colorization: 1
        colorizationColor: Theme.fg
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            volumePopup.visible = !volumePopup.visible;
        }
    }

    StyledPopup {
        id: volumePopup
        anchor {
            rect {
                y: 40
                x: -170
            }
            item: icon
            edges: Edges.Bottom
            gravity: Edges.Bottom
        }

        content: Item {
            Column {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                Text {
                    text: "Volume Control"
                    color: "#ffffff"
                    font.pixelSize: 16
                    font.bold: true
                }
            }
        }
    }
}
