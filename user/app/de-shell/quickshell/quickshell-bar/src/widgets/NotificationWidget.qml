pragma ComponentBehavior: Bound
import qs.src.services
import qs.src.components
import qs.src
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

Item {
    id: root
    implicitWidth: 22

    RowLayout {
        width: parent.implicitWidth

        StyledIcon {
            Layout.fillWidth: true
            iconName: "notifications"
            size: 22
            onClicked: notifPopup.toggle()
            active: notifPopup.opened
        }

        StyledText {
            visible: Notifications.allNotifs.length >= 1
            clip: true
            text: Notifications.allNotifs.length
            horizontalAlignment: Text.AlignRight
            Layout.leftMargin: 0
            Layout.topMargin: -10
        }
    }

    Timer {
        id: timestampRefreshTimer
        interval: 30000
        repeat: true
        running: notifPopup.opened
    }

    StyledPopup {
        id: notifPopup
        anchorItem: root

        onOpenedChanged: {
            if (opened) {
                timestampRefreshTimer.start();
            } else {
                timestampRefreshTimer.stop();
            }
        }

        content: ColumnLayout {
            spacing: 8

            StyledContainer {
                Layout.fillWidth: true
                topMargin: 8
                bottomMargin: 8
                radius: 12

                RowLayout {
                    StyledText {
                        text: "Notifications"
                        font.pointSize: 18
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    StyledIcon {
                        iconName: "delete"
                        onClicked: Notifications.closeAll()
                    }
                }
            }

            ListView {
                id: listView
                Layout.preferredHeight: 400
                Layout.preferredWidth: 350
                clip: true
                spacing: 8
                reuseItems: false

                model: ScriptModel {
                    values: [...Notifications.allNotifs.filter(a => !a.transient)].reverse()
                }

                removeDisplaced: Transition {
                    NumberAnimation {
                        properties: "x,y"
                        duration: 300
                        easing.type: Easing.OutCubic
                    }
                }

                remove: Transition {
                    NumberAnimation {
                        property: "opacity"
                        to: 0
                        duration: 200
                    }
                }

                delegate: StyledContainer {
                    id: notification
                    required property Notification modelData
                    required property int index
                    implicitWidth: listView.width
                    radius: 12
                    hoverEnabled: false
                    border.width: 1
                    topMargin: 4
                    bottomMargin: 8
                    leftMargin: 8
                    rightMargin: 8

                    property string timeText: getTime()
                    property bool expanded: false

                    Component.onCompleted: {
                        timeText = getTime();
                    }

                    Connections {
                        target: timestampRefreshTimer
                        function onTriggered() {
                            notification.timeText = notification.getTime();
                        }
                    }

                    TapHandler {
                        onTapped: {
                            if (notification.modelData.actions.values.length > 0) {
                                notification.modelData.actions[0].invoke();
                            }
                        }
                    }

                    function getTime(): string {
                        const now = new Date();
                        const diff = (now - modelData.time) / (1000 * 60);

                        if (diff < 1) {
                            return "now";
                        } else if (diff < 60) {
                            return Math.floor(diff) + " min ago";
                        } else if (diff < 1440) {
                            const hours = Math.floor(diff / 60);
                            return hours + (hours === 1 ? " hour ago" : " hours ago");
                        } else {
                            const days = Math.floor(diff / 1440);
                            return days + (days === 1 ? " day ago" : " days ago");
                        }
                    }

                    function getIcon() {
                        if (modelData?.image !== "") {
                            return modelData?.image;
                        }
                        if (!modelData?.appIcon.startsWith("image://") && !modelData?.appIcon.startsWith("file://")) {
                            return Quickshell.iconPath(modelData?.appIcon);
                        }
                        return modelData?.appIcon;
                    }

                    ColumnLayout {
                        id: content
                        spacing: 4

                        RowLayout {
                            Layout.alignment: Qt.AlignTop
                            IconImage {
                                source: notification.getIcon() ?? ""
                                implicitSize: 22
                            }
                            StyledText {
                                text: notification.modelData?.appName ?? ""
                                elide: Text.ElideRight
                                color: Theme.darkText
                            }
                            StyledText {
                                text: "•"
                                color: Theme.darkText
                            }
                            StyledText {
                                text: notification.timeText
                                color: Theme.darkText
                            }

                            Item {
                                Layout.fillWidth: true
                            }

                            StyledIcon {
                                iconName: "keyboard_arrow_down"
                                visible: bodyText.truncated || notification.expanded
                                size: 22
                                rotation: notification.expanded ? 180 : 0
                                onClicked: notification.expanded = !notification.expanded
                                Behavior on rotation {
                                    NumberAnimation {
                                        duration: 150
                                        easing.type: Easing.OutQuad
                                    }
                                }
                            }

                            StyledIcon {
                                iconName: "close"
                                size: 22
                                onClicked: Notifications.notifCloseByNotif(notification.modelData)
                                Behavior on rotation {
                                    NumberAnimation {
                                        duration: 150
                                        easing.type: Easing.OutQuad
                                    }
                                }
                            }
                        }

                        StyledText {
                            text: notification.modelData?.summary ?? ""
                            bold: true
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignLeft
                            maximumLineCount: 2
                            Layout.fillWidth: true
                        }

                        StyledText {
                            id: bodyText
                            text: notification.modelData?.body ?? ""
                            fontSize: 11
                            elide: Text.ElideRight
                            wrapMode: Text.Wrap
                            horizontalAlignment: Text.AlignLeft
                            maximumLineCount: notification.expanded ? 9999 : 2
                            Layout.fillWidth: true
                        }
                    }
                }
            }
        }
    }
}
