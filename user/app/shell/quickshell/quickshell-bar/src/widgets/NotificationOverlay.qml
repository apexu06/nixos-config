pragma ComponentBehavior: Bound
import qs.src.services
import qs.src.components
import qs.src

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland

LazyLoader {
    id: root
    active: Notifications.notifOverlayOpen

    property real animationDuration: 300

    PanelWindow {
        id: window
        anchors {
            top: true
            right: true
        }

        margins {
            top: 5
            right: 5
        }
        exclusiveZone: 0
        color: "transparent"
        mask: Region {
            item: listView
        }
        implicitWidth: 450
        implicitHeight: Math.min(600, listView.contentHeight + 80)

        ListView {
            id: listView
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
                fill: parent
            }
            clip: true
            spacing: 8
            reuseItems: false

            model: ScriptModel {
                values: [...Notifications.popupNotifs.map(a => a)].reverse()
            }

            removeDisplaced: Transition {
                NumberAnimation {
                    properties: "x,y"
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }
            delegate: StyledContainer {
                id: notification
                required property Notification modelData
                required property int index

                implicitWidth: listView.width
                implicitHeight: 100
                radius: 12
                hoverEnabled: true
                border.width: 1
                topMargin: 8
                bottomMargin: 8
                leftMargin: 8
                rightMargin: 8

                opacity: 0
                scale: 0.8

                Component.onCompleted: {
                    opacity = 1;
                    scale = 1;

                    notification.modelData.bodyChanged.connect(() => {
                        if (autoDismiss)
                            autoDismiss.restart();
                    });
                }

                function getIcon() {
                    if (modelData?.image !== "") {
                        return modelData.image;
                    }

                    if (!modelData?.appIcon.startsWith("image://") && !modelData?.appIcon.startsWith("file://")) {
                        return Quickshell.iconPath(modelData?.appIcon);
                    }

                    return modelData?.appIcon;
                }

                RowLayout {
                    width: parent.width
                    height: parent.height
                    spacing: 8

                    Image {
                        id: image
                        visible: notification.modelData?.image !== "" || notification.modelData?.appIcon !== ""
                        source: notification.getIcon() ?? ""
                        fillMode: Image.PreserveAspectCrop

                        Layout.fillHeight: true
                        Layout.preferredWidth: 80

                        layer.enabled: true

                        layer.effect: MultiEffect {
                            maskEnabled: true
                            maskSource: ShaderEffectSource {
                                sourceItem: Rectangle {
                                    width: image.width
                                    height: image.height
                                    radius: 8
                                }
                            }
                        }
                    }

                    StyledContainer {
                        radius: 8
                        Layout.fillWidth: true
                        Layout.preferredHeight: notification.height - 20
                        color: Theme.layer2
                        leftMargin: 8
                        topMargin: 8
                        bottomMargin: 8
                        rightMargin: 8

                        ColumnLayout {
                            Layout.preferredWidth: parent.width
                            Layout.fillHeight: true
                            spacing: 2

                            StyledText {
                                text: notification.modelData?.summary ?? ""
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignLeft
                                bold: true
                                fontSize: 14
                            }

                            StyledText {
                                text: notification.modelData?.body ?? ""
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                horizontalAlignment: Text.AlignLeft
                            }

                            StyledText {
                                text: notification.modelData?.appName ?? ""
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                color: Theme.withAlpha(Theme.fg, 0.5)
                                fontSize: 11
                                horizontalAlignment: Text.AlignLeft
                            }
                        }
                    }
                }

                Behavior on opacity {
                    enabled: true
                    NumberAnimation {
                        duration: root.animationDuration
                        easing.type: Easing.OutCubic
                    }
                }

                Behavior on scale {
                    enabled: true
                    NumberAnimation {
                        duration: root.animationDuration
                        easing.type: dismissTimer.running ? Easing.InCubic : Easing.OutBack
                    }
                }

                function dismiss() {
                    autoDismiss.stop();
                    dismissTimer.start();
                    opacity = 0;
                    scale = 0.8;
                }

                Timer {
                    id: autoDismiss
                    running: window.visible && !itemHover.hovered
                    interval: (notification.modelData?.expireTimeout > 0 ? notification.modelData?.expireTimeout : 5) * 1000
                    onTriggered: {
                        notification.dismiss();
                    }
                }

                Timer {
                    id: dismissTimer
                    interval: root.animationDuration
                    onTriggered: {
                        Notifications.notifDismissByNotif(notification.modelData);
                    }
                }

                HoverHandler {
                    id: itemHover
                }

                TapHandler {
                    onTapped: notification.dismiss()
                }
            }
        }
    }
}
