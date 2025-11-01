pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell
import qs.src.components
import qs.src.services
import qs.src

Item {
    id: root
    implicitWidth: 22

    property int currentOpen: -1

    StyledIcon {
        iconName: Network.materialSymbol
        size: 22
        anchors.centerIn: parent
        onClicked: popupLoader.item.opened = !popupLoader.item.opened
        active: popupLoader.item?.opened ?? false
    }

    LazyLoader {
        id: popupLoader
        loading: true

        StyledPopup {
            id: networkPopup

            anchor {
                rect {
                    y: 30
                    x: -150
                }
                item: root
            }

            onOpenedChanged: {
                if (opened) {
                    Network.rescanWifi();
                    rescanTimer.start();
                } else {
                    rescanTimer.stop();
                }
            }

            Timer {
                id: rescanTimer
                interval: 5000
                repeat: true
                onTriggered: {
                    if (networkPopup.opened) {
                        Network.rescanWifi();
                    }
                }
            }

            content: ColumnLayout {
                spacing: 8
                StyledContainer {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 400
                    Layout.preferredHeight: 50
                    customRadius: 12

                    RowLayout {
                        StyledText {
                            content: "Wifi"
                            color: Network.wifiScanning ? Theme.accent : Theme.fg
                            bold: true
                        }
                        Item {
                            Layout.fillWidth: true
                        }

                        StyledSwitch {
                            checked: Network.wifiEnabled
                            onClicked: Network.toggleWifi()
                        }
                    }
                }

                StyledContainer {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    leftMargin: 8
                    rightMargin: 8
                    bottomMargin: 8
                    topMargin: 8
                    radius: 12
                    visible: Network.wifiEnabled

                    Flickable {
                        anchors.fill: parent
                        anchors.margins: 8
                        clip: true
                        contentHeight: content.height
                        implicitHeight: 250

                        ColumnLayout {
                            id: content
                            width: parent.width
                            spacing: 4

                            Repeater {
                                model: Network.wifiNetworks.map(n => n.ssid)
                                delegate: StyledContainer {
                                    id: container
                                    required property string modelData
                                    required property int index
                                    property bool expanded: root.currentOpen === index
                                    property bool isCurrent: modelData === Network.active?.ssid
                                    property bool passwordPending: Network.wifiConnectTarget?.askingPassword ?? false
                                    property var currentNetwork: Network.wifiNetworks[index]

                                    margin: 4
                                    topMargin: 6
                                    bottomMargin: 6
                                    customRadius: 12
                                    color: hover.hovered ? Theme.layer2 : Theme.layer1
                                    clip: true
                                    Layout.fillWidth: true

                                    TapHandler {
                                        enabled: !container.expanded
                                        onTapped: root.currentOpen = container.index
                                    }

                                    HoverHandler {
                                        id: hover
                                        enabled: !container.expanded
                                    }

                                    function toggle() {
                                        Network.wifiConnectTarget = null;
                                        root.currentOpen = container.expanded ? -1 : container.index;
                                    }

                                    function connectToTargetNetwork(password: string) {
                                        Network.changePassword(Network.wifiConnectTarget, password);
                                    }

                                    Column {
                                        id: contentColumn
                                        width: parent.width
                                        spacing: 8

                                        RowLayout {
                                            width: parent.width

                                            TapHandler {
                                                enabled: true
                                                onTapped: container.toggle()
                                            }

                                            StyledIcon {
                                                iconName: Network.getStrengthIcon(container.currentNetwork?.strength)
                                                hoverEnabled: false
                                                size: 18
                                            }

                                            StyledText {
                                                text: container.modelData
                                            }

                                            Loader {
                                                active: container.isCurrent
                                                sourceComponent: StyledIcon {
                                                    iconName: "check"
                                                    hoverEnabled: false
                                                    size: 18
                                                }
                                            }

                                            Item {
                                                Layout.fillWidth: true
                                            }

                                            StyledIcon {
                                                iconName: "keyboard_arrow_down"
                                                rotation: container.expanded ? 180 : 0
                                                onClicked: container.toggle()
                                                Behavior on rotation {
                                                    NumberAnimation {
                                                        duration: 150
                                                        easing.type: Easing.OutQuad
                                                    }
                                                }
                                            }
                                        }

                                        Loader {
                                            active: container.expanded
                                            width: parent.width
                                            height: row.height

                                            Row {
                                                id: row
                                                Layout.fillWidth: true
                                                width: parent.width
                                                spacing: 8

                                                Row {
                                                    visible: container.expanded && container.passwordPending
                                                    width: parent.width
                                                    spacing: 8

                                                    onVisibleChanged: {
                                                        if (visible) {
                                                            rescanTimer.stop();
                                                        } else {
                                                            rescanTimer.start();
                                                        }
                                                    }

                                                    StyledInput {
                                                        id: input
                                                        y: container.passwordPending ? 0 : contentColumn.height
                                                        width: parent.width - confirmButton.width - parent.spacing
                                                        isPassword: true

                                                        onAccepted: {
                                                            container.connectToTargetNetwork(input.text);
                                                        }

                                                        Behavior on y {
                                                            NumberAnimation {
                                                                duration: 400
                                                                easing.overshoot: 1.5
                                                                easing.type: Easing.OutBack
                                                            }
                                                        }
                                                    }

                                                    StyledContainer {
                                                        id: confirmButton
                                                        height: parent.height
                                                        implicitWidth: height

                                                        y: container.passwordPending ? 0 : contentColumn.height
                                                        Behavior on y {
                                                            NumberAnimation {
                                                                duration: 500
                                                                easing.overshoot: 1.5
                                                                easing.type: Easing.OutBack
                                                            }
                                                        }
                                                        StyledIcon {
                                                            iconName: "check"
                                                            onClicked: container.connectToTargetNetwork(input.text)
                                                        }
                                                    }
                                                }

                                                WrapperRectangle {
                                                    id: connect
                                                    property color buttonColor: Network.wifiConnecting ? Theme.layer3 : container.isCurrent ? Theme.warning : Theme.accent
                                                    visible: container.expanded
                                                    y: container.expanded ? 0 : -(contentColumn.height)
                                                    x: container.passwordPending ? contentColumn.width + 50 : 0
                                                    opacity: container.expanded ? 1 : 0

                                                    Behavior on y {
                                                        NumberAnimation {
                                                            duration: 400
                                                            easing.overshoot: 1.5
                                                            easing.type: Easing.OutBack
                                                        }
                                                    }

                                                    Behavior on x {
                                                        NumberAnimation {
                                                            duration: 500
                                                            easing.overshoot: 1.5
                                                            easing.type: Easing.OutBack
                                                        }
                                                    }

                                                    Behavior on opacity {
                                                        NumberAnimation {
                                                            duration: 400
                                                            easing.type: Easing.OutQuad
                                                        }
                                                    }

                                                    margin: 4
                                                    leftMargin: 8
                                                    rightMargin: 8
                                                    radius: width / 2
                                                    width: removeButton.visible ? parent.width / 2 - parent.spacing / 2 : parent.width
                                                    Layout.fillWidth: true
                                                    color: Network.wifiConnecting || connectHover.hovered ? buttonColor : "transparent"
                                                    border {
                                                        width: 2
                                                        color: buttonColor
                                                    }

                                                    Behavior on color {
                                                        ColorAnimation {
                                                            duration: 100
                                                        }
                                                    }

                                                    Behavior on width {
                                                        // enabled: removeButton.visible
                                                        NumberAnimation {
                                                            duration: 200
                                                            easing.type: Easing.OutQuad
                                                        }
                                                    }

                                                    HoverHandler {
                                                        id: connectHover
                                                        target: parent
                                                    }

                                                    TapHandler {
                                                        onTapped: {
                                                            if (Network.wifiConnecting)
                                                                return;
                                                            if (container.isCurrent) {
                                                                Network.disconnectWifiNetwork();
                                                            } else {
                                                                Network.connectToWifiNetwork(container.currentNetwork);
                                                            }
                                                        }
                                                    }

                                                    StyledText {
                                                        text: container.isCurrent ? "Disconnect" : Network.wifiConnecting ? "Connecting..." : "Connect"
                                                        color: connectHover.hovered ? Theme.layer0 : connect.buttonColor
                                                        horizontalAlignment: Text.AlignHCenter
                                                    }
                                                }

                                                WrapperRectangle {
                                                    id: removeButton
                                                    property color buttonColor: Theme.destructive
                                                    visible: container.expanded && (container.currentNetwork?.known ?? false) && !Network.wifiConnecting
                                                    y: container.expanded ? 0 : -(contentColumn.height)
                                                    x: container.passwordPending ? contentColumn.width + 50 : 0
                                                    opacity: container.expanded ? 1 : 0

                                                    Behavior on y {
                                                        NumberAnimation {
                                                            duration: 400
                                                            easing.overshoot: 1.5
                                                            easing.type: Easing.OutBack
                                                        }
                                                    }

                                                    Behavior on x {
                                                        NumberAnimation {
                                                            duration: 500
                                                            easing.overshoot: 1.5
                                                            easing.type: Easing.OutBack
                                                        }
                                                    }

                                                    Behavior on opacity {
                                                        NumberAnimation {
                                                            duration: 400
                                                            easing.type: Easing.OutQuad
                                                        }
                                                    }

                                                    margin: 4
                                                    leftMargin: 8
                                                    rightMargin: 8
                                                    radius: width / 2
                                                    width: parent.width / 2 - parent.spacing / 2
                                                    Layout.fillWidth: true
                                                    color: removeHover.hovered ? buttonColor : "transparent"
                                                    border {
                                                        width: 2
                                                        color: buttonColor
                                                    }

                                                    Behavior on color {
                                                        ColorAnimation {
                                                            duration: 100
                                                        }
                                                    }

                                                    HoverHandler {
                                                        id: removeHover
                                                        target: parent
                                                    }

                                                    TapHandler {
                                                        onTapped: {
                                                            if (container.currentNetwork?.known) {
                                                                Network.removeConnection(container.currentNetwork);
                                                            }
                                                        }
                                                    }

                                                    StyledText {
                                                        text: "Remove"
                                                        color: removeHover.hovered ? Theme.layer0 : removeButton.buttonColor
                                                        horizontalAlignment: Text.AlignHCenter
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
