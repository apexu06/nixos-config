pragma ComponentBehavior: Bound
import qs.src.services
import qs.src
import qs.src.components

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland

PanelWindow {
    id: root
    anchors {
        top: true
        right: true
        bottom: true
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
    implicitWidth: 320
    visible: Notifications.notifOverlayOpen
    implicitHeight: Math.min(600, listView.contentHeight + 20)

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
        model: ScriptModel {
            values: [...Notifications.popupNotifs.map(a => a)].reverse()
        }
        delegate: StyledContainer {
            id: box
            required property Notification modelData
            required property int index

            implicitWidth: listView.width
            implicitHeight: 80
            radius: 12

            // Track animation states
            property bool initialAnimationDone: false
            property bool isDismissing: false

            // Animation properties
            opacity: 0
            scale: 0.8

            // Trigger animation when component is created
            Component.onCompleted: {
                opacity = 1;
                scale = 1;
                initialAnimTimer.start();
            }

            Timer {
                id: initialAnimTimer
                interval: 300  // Match animation duration
                onTriggered: box.initialAnimationDone = true
            }

            // Function to animate out and then dismiss
            function dismiss() {
                isDismissing = true;
                opacity = 0;
                scale = 0.8;
                dismissTimer.start();
            }

            Timer {
                id: dismissTimer
                interval: 300  // Match animation duration
                onTriggered: {
                    Notifications.notifDismissByNotif(box.modelData);
                }
            }

            // Animate opacity (during initial and dismiss)
            Behavior on opacity {
                enabled: !box.initialAnimationDone || box.isDismissing
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutCubic
                }
            }

            // Animate scale (during initial and dismiss)
            Behavior on scale {
                enabled: !box.initialAnimationDone || box.isDismissing
                NumberAnimation {
                    duration: 300
                    easing.type: box.isDismissing ? Easing.InCubic : Easing.OutBack
                }
            }

            // Animate slide (during initial and dismiss)

            Timer {
                running: root.visible
                interval: (box.modelData.expireTimeout > 0 ? box.modelData.expireTimeout : 5) * 1000
                onTriggered: {
                    box.dismiss();  // Use dismiss function instead
                }
            }

            TapHandler {
                onTapped: box.dismiss()  // Use dismiss function instead
            }

            StyledText {
                text: box.modelData.summary
            }
        }
    }
}
