pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.src.components
import Quickshell.Widgets
import qs.src

Item {
    id: root
    required property var modelData
    required property int defaultIndex
    property alias margins: box.margin
    property Component icon
    property string iconName: ""
    signal activated(int index)

    property int index: -1
    property bool open: false
    property real targetContentHeight: contentColumn.implicitHeight

    implicitHeight: box.implicitHeight

    StyledContainer {
        id: box
        anchors.fill: parent
        backgroundColor: mouseArea.containsMouse ? Theme.tlayer2 : Theme.tlayer1
        margin: 8
        radius: 12
        clip: true
        border.color: root.open ? Theme.border : "transparent"

        Column {
            spacing: 3
            width: parent.width

            WrapperMouseArea {
                onClicked: root.open = !root.open
                width: parent.width

                RowLayout {
                    id: header
                    width: parent.width

                    Loader {
                        active: root.icon !== null
                        sourceComponent: root.icon
                    }

                    Item {
                        Layout.fillWidth: true
                    }
                    StyledText {
                        id: label
                        text: root.modelData.length > 0 ? root.modelData[root.index === -1 ? root.defaultIndex : root.index] ?? "" : ""
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    StyledIcon {
                        iconName: "keyboard_arrow_down"
                        rotation: root.open ? 180 : 0
                        onClicked: root.open = !root.open
                        Behavior on rotation {
                            NumberAnimation {
                                duration: 150
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                }
            }

            Item {
                id: spacer
                width: parent.width
                height: root.open ? 8 : 0
            }

            Loader {
                active: root.open
                height: contentWrapper.height
                width: parent.width
                Item {
                    id: contentWrapper
                    width: parent.width
                    height: root.open ? root.targetContentHeight : 0
                    clip: true

                    WrapperRectangle {
                        id: content
                        width: parent.width
                        color: "transparent"
                        y: root.open ? 0 : -root.targetContentHeight
                        opacity: root.open ? 1 : 0

                        Behavior on y {
                            NumberAnimation {
                                duration: 400
                                easing.type: Easing.OutBack
                                easing.overshoot: 1.5
                            }
                        }

                        Behavior on opacity {
                            NumberAnimation {
                                duration: 400
                                easing.type: Easing.OutQuad
                            }
                        }

                        Column {
                            id: contentColumn
                            spacing: 4
                            width: parent.width

                            Repeater {
                                model: root.modelData
                                delegate: Item {
                                    id: delegate
                                    required property var modelData
                                    required property int index
                                    width: parent.width
                                    height: container.implicitHeight

                                    property bool isCurrent: root.index === -1 ? root.defaultIndex === index : root.index === index

                                    StyledContainer {
                                        id: container
                                        color: itemMouseArea.containsMouse ? Theme.layer3 : delegate.isCurrent ? Theme.accent : Theme.layer2
                                        width: parent.width
                                        margin: 6

                                        StyledText {
                                            text: delegate.modelData
                                            elide: Text.ElideRight
                                            color: itemMouseArea.containsMouse ? Theme.fg : delegate.isCurrent ? Theme.layer0 : Theme.fg
                                        }
                                    }
                                    MouseArea {
                                        id: itemMouseArea
                                        hoverEnabled: true
                                        anchors.fill: parent
                                        onClicked: {
                                            root.index = delegate.index;
                                            root.activated(delegate.index);
                                            root.open = false;
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
    MouseArea {
        id: mouseArea
        hoverEnabled: true
        anchors.fill: box
        onClicked: root.open = !root.open
        enabled: !root.open
    }
}
