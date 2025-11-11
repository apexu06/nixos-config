pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs.src
import qs.src.components
import qs.src.services

StyledContainer {
    id: root
    visible: Niri.focusedWindow !== null
    property var entry: DesktopEntries.heuristicLookup(Niri.focusedWindow?.appId ?? "")
    property var name: Niri.focusedWindow?.appId ?? ""

    implicitWidth: 150

    RowLayout {
        width: parent.width

        IconImage {
            id: icon
            source: Quickshell.iconPath(root.entry.icon)
            implicitSize: 22

            Behavior on source {
                FadeAnimation {
                    target: icon
                }
            }
        }

        StyledText {
            id: text
            text: root.name
            elide: Text.ElideRight
            Layout.fillWidth: true
        }
    }
}
