pragma ComponentBehavior: Bound

import QtQuick
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
    property MprisPlayer player: Mpris.players.values[0]
    property var entry: DesktopEntries.heuristicLookup(player.desktopEntry)
    hoverEnabled: true

    TapHandler {
        onTapped: mprisPopup.toggle()
    }

    RowLayout {
        width: parent.width

        IconImage {
            source: Quickshell.iconPath(root.entry?.icon ?? "headphones")
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
    }

    StyledPopup {
        id: mprisPopup
        anchorItem: root

        content: ColumnLayout {
            StyledContainer {
                Layout.preferredWidth: 500
                Layout.preferredHeight: 100
            }
        }
    }
}
