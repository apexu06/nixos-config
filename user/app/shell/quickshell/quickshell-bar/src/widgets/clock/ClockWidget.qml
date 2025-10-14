pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../../components"
import "../.."

StyledContainer {
    Layout.alignment: Qt.AlignCenter

    RowLayout {
        spacing: 1
        Item {
            implicitWidth: textMetrics.width - 4
            implicitHeight: parent.implicitHeight - 2

            TextMetrics {
                id: textMetrics
                text: "00:00:00"
            }

            StyledText {
                Layout.alignment: Qt.AlignVCenter
                text: Time.time
            }
        }

        ToolSeparator {
            implicitHeight: parent.height

            contentItem: Rectangle {
                implicitWidth: 1
                implicitHeight: parent.implicitHeight
                color: Theme.layer3
            }
        }

        StyledText {
            text: Time.date
            color: Theme.withAlpha(Theme.fg, 0.5)
        }
    }
}
