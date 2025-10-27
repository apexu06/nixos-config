pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import qs.src.components
import qs.src

StyledContainer {
    backgroundColor: Theme.tlayer0
    RowLayout {
        spacing: -1
        Layout.fillWidth: true
        Layout.fillHeight: true
        Item {
            implicitWidth: textMetrics.width

            TextMetrics {
                id: textMetrics
                text: "00:00:00"
            }

            StyledText {
                anchors.fill: parent
                text: Time.time
            }
        }

        ToolSeparator {
            implicitHeight: parent.height - 8

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
