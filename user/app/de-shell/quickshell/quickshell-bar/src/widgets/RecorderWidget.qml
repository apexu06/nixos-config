pragma ComponentBehavior: Bound
import qs.src.services
import qs.src.components
import qs.src
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.Notifications

Item {
    id: root
    implicitWidth: 22
    implicitHeight: 22

    StyledIcon {
        height: parent.height
        width: parent.width
        iconName: "capture"
        active: Recorder.isRecording
        hoverColor: Theme.warning
        onClicked: recorderPopup.toggle()
    }

    IpcHandler {
        target: "recorder"

        function ipcToggleReplay(): void {
            Recorder.toggleReplayMode();
        }

        function ipcSaveReplay(): void {
            Recorder.saveReplay();
        }
    }

    StyledPopup {
        id: recorderPopup
        anchorItem: root
        content: ColumnLayout {
            spacing: 8
            RowLayout {
                spacing: 8
                StyledContainer {
                    margin: 8
                    backgroundColor: hoverHandler.hovered ? Theme.layer2 : Recorder.isRecording ? Theme.destructive : Theme.accent

                    HoverHandler {
                        id: hoverHandler
                        cursorShape: Qt.PointingHandCursor
                    }

                    TapHandler {
                        onTapped: {
                            Recorder.toggleReplayMode();
                        }
                    }

                    StyledText {
                        text: Recorder.isRecording ? "Stop Recording" : "Start Recording"
                        color: hoverHandler.hovered ? Theme.fg : Theme.layer0
                    }
                }

                StyledContainer {
                    margin: 8
                    backgroundColor: hoverHandler2.hovered ? Theme.layer2 : Theme.success

                    HoverHandler {
                        id: hoverHandler2
                        cursorShape: Qt.PointingHandCursor
                    }

                    TapHandler {
                        onTapped: {
                            Recorder.saveReplay();
                        }
                    }

                    StyledText {
                        text: "Save last 60 seconds"
                        color: hoverHandler2.hovered ? Theme.fg : Theme.layer0
                    }
                }
            }
            StyledContainer {
                Layout.fillWidth: true
                margin: 8
                backgroundColor: hoverHandler3.hovered ? Theme.layer2 : Theme.accent

                HoverHandler {
                    id: hoverHandler3
                    cursorShape: Qt.PointingHandCursor
                }

                TapHandler {
                    onTapped: {
                        Quickshell.execDetached("gpu-screen-recorder-gtk");
                    }
                }

                StyledText {
                    text: "Open Screen Recorder UI"
                    color: hoverHandler3.hovered ? Theme.fg : Theme.layer0
                }
            }
        }
    }
}
