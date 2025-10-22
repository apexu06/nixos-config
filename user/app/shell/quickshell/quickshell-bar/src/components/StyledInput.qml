import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.src
import qs.src.components

StyledContainer {
    id: root
    property bool isPassword: false
    property alias text: control.text
    signal accepted

    margin: 4

    RowLayout {
        TextField {
            id: control
            color: Theme.fg
            echoMode: root.isPassword ? TextInput.Password : TextInput.Normal
            background: Rectangle {
                width: parent.width
                color: "transparent"
            }

            onAccepted: root.accepted()

            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        StyledIcon {
            iconName: control.echoMode === TextInput.Password ? "visibility_off" : "visibility"
            onClicked: control.echoMode === TextInput.Password ? control.echoMode = TextInput.Normal : control.echoMode = TextInput.Password
            hoverEnabled: false
        }
    }
}
