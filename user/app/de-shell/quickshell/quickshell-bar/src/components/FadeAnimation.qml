import QtQuick

SequentialAnimation {
    id: root
    property QtObject target
    property string fadeProperty: "scale"
    property int fadeDuration: 100
    property real min: 0.2
    property real max: 1
    property alias outValue: outAnimation.to
    property alias inValue: inAnimation.to
    property alias outEasingType: outAnimation.easing.type
    property alias inEasingType: inAnimation.easing.type
    property string easingType: "Quad"
    NumberAnimation { // in the default case, fade scale to 0
        id: outAnimation
        target: root.target
        property: root.fadeProperty
        duration: root.fadeDuration
        to: root.min
        easing.type: Easing["In" + root.easingType]
    }
    PropertyAction {} // actually change the property targeted by the Behavior between the 2 other animations
    NumberAnimation { // in the default case, fade scale back to 1
        id: inAnimation
        target: root.target
        property: root.fadeProperty
        duration: root.fadeDuration
        to: root.max
        easing.type: Easing["Out" + root.easingType]
    }
}
