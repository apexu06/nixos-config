pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.src.components
import qs.src

StyledContainer {
    RowLayout {
        spacing: 1
        Item {
            implicitWidth: textMetrics.width
            Layout.alignment: Qt.AlignVCenter

            TextMetrics {
                id: textMetrics
                text: "00:00:00"
            }

            StyledText {
                anchors.centerIn: parent
                text: Time.time
            }
        }

        ToolSeparator {
            implicitHeight: parent.height - 6

            contentItem: Rectangle {
                implicitWidth: 1
                color: Theme.layer3
            }
        }

        StyledText {
            Layout.alignment: Qt.AlignVCenter
            text: Time.date
            color: Theme.withAlpha(Theme.fg, 0.5)
        }
    }
}
