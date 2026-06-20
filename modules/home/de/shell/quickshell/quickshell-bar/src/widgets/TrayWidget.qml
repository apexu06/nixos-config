pragma ComponentBehavior: Bound

import Quickshell.Services.SystemTray
import Quickshell.Widgets
import Quickshell
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs.src
import qs.src.components

StyledContainer {
    id: root
    Layout.fillHeight: true

    RowLayout {
        Repeater {
            model: SystemTray.items
            delegate: IconImage {
                id: delegate
                required property SystemTrayItem modelData
                required property int index

                source: modelData?.icon ?? "placeholder"
                implicitSize: 22

                scale: hover.hovered ? 1.2 : 1
                Behavior on scale {
                    NumberAnimation {
                        duration: 200
                        easing.type: Easing.OutBack
                        easing.overshoot: 1.2
                    }
                }

                HoverHandler {
                    id: hover
                }

                layer {
                    enabled: true
                    effect: MultiEffect {
                        colorization: 1
                        colorizationColor: Theme.fg
                    }
                }

                MouseArea {
                    anchors.fill: parent

                    enabled: true
                    acceptedButtons: Qt.LeftButton | Qt.RightButton

                    onClicked: event => {
                        if (event.button === Qt.LeftButton)
                            delegate.modelData.activate();
                        else
                            anchor.open();
                    }
                }

                QsMenuAnchor {
                    id: anchor
                    anchor.item: root
                    menu: delegate.modelData?.menu
                    anchor.margins.top: 32
                }
            }
        }
    }
}
