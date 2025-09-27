import QtQuick
import "../../"

Rectangle {

    anchors.centerIn: parent
    anchors.right: parent.left

    Text {
        color: Theme.text
        text: Time.time
    }
}
