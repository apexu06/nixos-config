pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.Mpris
import Quickshell
import qs.src.components
import qs.src.services
import qs.src

StyledContainer {
    id: root
    visible: Mpris.players.values.length > 0
    property int currentIdx: 0
    property MprisPlayer player: Mpris.players.values[currentIdx]
    property var entry: DesktopEntries.heuristicLookup(player.desktopEntry)
    hoverEnabled: true

    Connections {
        target: root.player
        function onPlaybackStateChanged() {
            Cava.shouldRun = root.player.playbackState === MprisPlaybackState.Playing;
        }
    }

    FrameAnimation {
        running: root.player.playbackState === MprisPlaybackState.Playing
        onTriggered: root.player.positionChanged()
    }

    TapHandler {
        onTapped: mprisPopup.toggle()
    }

    TapHandler {
        acceptedButtons: Qt.RightButton
        onTapped: {
            if (root.currentIdx < Mpris.players.values.length - 1) {
                root.currentIdx++;
                return;
            }
            root.currentIdx = 0;
        }
    }

    child: RowLayout {

        IconImage {
            source: Quickshell.iconPath(root.entry.icon, "headphones")
            implicitSize: 20
        }

        StyledText {
            Layout.maximumWidth: 200
            text: root.player?.trackTitle ?? ""
            elide: Text.ElideRight
        }

        StyledText {
            text: "•"
        }

        StyledText {
            Layout.fillWidth: true
            text: root.player?.trackArtist ?? ""
            color: Theme.darkText
        }

        LinearSpectrum {
            visible: root.player.isPlaying
            Layout.fillWidth: true
            implicitWidth: 30
            implicitHeight: 20
            values: Cava.values
        }
    }

    function formatTime(seconds) {
        const mins = Math.floor(seconds / 60);
        const secs = Math.floor(seconds % 60);
        return `${String(mins).padStart(2, '0')}:${String(secs).padStart(2, '0')}`;
    }

    StyledPopup {
        id: mprisPopup
        anchorItem: root
        margin: 0
        backgroundColor: "transparent"

        content: Item {
            implicitWidth: 600
            implicitHeight: 140
            clip: true
            layer.enabled: true
            layer.smooth: true

            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: ShaderEffectSource {
                    sourceItem: Rectangle {
                        width: cover.width
                        height: cover.height
                        radius: 20
                        color: "red"
                    }
                }
            }

            Image {
                id: cover
                anchors.fill: parent
                source: root.player.trackArtUrl
                fillMode: Image.PreserveAspectCrop
                z: -10
            }

            Rectangle {
                anchors.fill: parent
                color: Theme.layer0
                opacity: 0.8
            }

            WrapperItem {
                anchors.fill: parent
                margin: 16

                RowLayout {
                    spacing: 16

                    IconImage {
                        source: root.player.trackArtUrl
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 100
                        mipmap: true
                    }

                    ColumnLayout {
                        spacing: 0

                        StyledText {
                            text: root.player.trackTitle
                            font.pointSize: 18
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignLeft
                            elide: Text.ElideRight
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignTop
                            Layout.bottomMargin: 8
                            StyledText {
                                text: root.player.trackArtist
                                verticalAlignment: Text.AlignTop
                            }

                            StyledText {
                                text: "•"
                                color: Theme.darkText
                            }

                            StyledText {
                                text: root.player.trackAlbum
                                verticalAlignment: Text.AlignTop
                                horizontalAlignment: Text.AlignLeft
                                Layout.fillWidth: true
                                color: Theme.darkText
                                elide: Text.ElideRight
                            }
                        }

                        RowLayout {
                            visible: root.player.canControl
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignCenter

                            StyledIcon {
                                visible: root.player.shuffleSupported
                                iconName: root.player.shuffle ? "shuffle_on" : "shuffle"
                                onClicked: root.player.shuffle = !root.player.shuffle
                            }

                            StyledIcon {
                                visible: root.player.canGoPrevious
                                iconName: "skip_previous"
                                onClicked: root.player.previous()
                            }

                            StyledIcon {
                                visible: root.player.canPause && root.player.canPlay
                                iconName: root.player.isPlaying ? "pause" : "play_arrow"
                                onClicked: {
                                    if (root.player.isPlaying) {
                                        root.player.pause();
                                    } else {
                                        root.player.play();
                                    }
                                }
                            }

                            StyledIcon {
                                visible: root.player.canGoNext
                                iconName: "skip_next"
                                onClicked: root.player.next()
                            }

                            StyledIcon {
                                visible: root.player.loopSupported
                                iconName: {
                                    switch (root.player.loopState) {
                                    case MprisLoopState.None:
                                        return "repeat";
                                    case MprisLoopState.Track:
                                        return "repeat_one_on";
                                    case MprisLoopState.Playlist:
                                        return "repeat_on";
                                    }
                                }
                                onClicked: {
                                    const state = root.player.loopState;
                                    if (state === MprisLoopState.None) {
                                        root.player.loopState = MprisLoopState.Playlist;
                                        return;
                                    }

                                    if (state === MprisLoopState.Playlist) {
                                        root.player.loopState = MprisLoopState.Track;
                                        return;
                                    }

                                    root.player.loopState = MprisLoopState.None;
                                }
                            }
                        }

                        RowLayout {
                            visible: root.player.canSeek && root.player.positionSupported
                            StyledText {
                                text: root.formatTime(root.player.position)
                                font.pointSize: 11
                            }

                            StyledSlider {
                                implicitHeight: 8
                                from: 0
                                to: root.player.length
                                value: root.player.position
                                onMoved: {
                                    root.player.position = value;
                                }
                            }

                            StyledText {
                                text: root.formatTime(root.player.length)
                                font.pointSize: 11
                            }
                        }
                    }
                    ColumnLayout {
                        visible: root.player.volumeSupported
                        StyledSlider {
                            Layout.alignment: Qt.AlignHCenter
                            orientation: Qt.Vertical
                            implicitHeight: 8
                            value: root.player.volume
                            onValueChanged: {
                                root.player.volume = value;
                            }
                            from: 1
                            to: 0
                        }

                        StyledIcon {
                            iconName: Audio.getVolumeIconName(root.player.volume, root.player.volume == 0)
                            implicitWidth: size
                            implicitHeight: size
                            hoverEnabled: false
                        }
                    }
                }
            }
        }
    }
}
