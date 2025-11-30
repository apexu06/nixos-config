pragma ComponentBehavior: Bound
import QtQuick
import qs.src

Item {
    id: root
    property color fillColor: Theme.fg
    property color strokeColor: Theme.fg
    property int strokeWidth: 0
    property var values: []

    // Minimum signal properties
    property bool showMinimumSignal: false
    property real minimumSignalValue: 0.05

    property int valuesCount: (values && Array.isArray(values)) ? values.length : 0
    property real barWidth: valuesCount > 0 ? width / valuesCount : 0
    property real base: height / 2
    property bool highQuality: true

    Repeater {
        model: root.valuesCount

        Item {
            required property int index

            property real rawAmp: (root.values && root.values[index] !== undefined) ? root.values[index] : 0
            property real amp: (root.showMinimumSignal && rawAmp === 0) ? root.minimumSignalValue : rawAmp
            property real barHeight: amp * root.base

            x: index * root.barWidth
            width: root.barWidth
            height: root.height

            // Top bar (extends upward from baseline)
            Rectangle {
                color: root.fillColor
                border.color: root.strokeColor
                border.width: root.strokeWidth
                antialiasing: root.highQuality
                smooth: root.highQuality

                width: root.barWidth - 2
                height: parent.barHeight
                x: 0
                y: root.base - height
            }

            // Bottom bar (extends downward from baseline)
            Rectangle {
                color: root.fillColor
                border.color: root.strokeColor
                border.width: root.strokeWidth
                antialiasing: root.highQuality
                smooth: root.highQuality

                width: root.barWidth - 2
                height: parent.barHeight
                x: 0
                y: root.base
            }
        }
    }
}
