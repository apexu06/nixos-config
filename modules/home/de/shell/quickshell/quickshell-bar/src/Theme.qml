pragma ComponentBehavior: Bound
pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    function withAlpha(baseColor, alpha) {
        return Qt.rgba(baseColor.r, baseColor.g, baseColor.b, alpha);
    }

    readonly property color fg: json.base04 ? `#${json.base04}` : "#ff0000"
    readonly property color accent: json.base0D ? `#${json.base0D}` : "#ff0000"
    readonly property color layer0: json.base00 ? `#${json.base00}` : "#ff0000"
    readonly property color layer1: json.base01 ? `#${json.base01}` : "#ff0000"
    readonly property color layer2: json.base02 ? `#${json.base02}` : "#ff0000"
    readonly property color layer3: json.base03 ? `#${json.base03}` : "#ff0000"

    // readonly property color tlayer0: withAlpha(layer0, 0.6)
    // readonly property color tlayer1: withAlpha(layer1, 0.4)
    // readonly property color tlayer2: withAlpha(layer2, 0.4)
    // readonly property color tlayer3: withAlpha(layer3, 0.4)

    readonly property color destructive: json.base08 ? `#${json.base08}` : "#ff0000"
    readonly property color warning: json.base09 ? `#${json.base09}` : "#ff0000"
    readonly property color success: json.base0B ? `#${json.base0B}` : "#ff0000"

    readonly property color border: withAlpha(fg, 0.1)
    readonly property color darkText: withAlpha(fg, 0.5)

    // Assign Properties from the read in palette.json (stylix generated file)
    readonly property color base00: json.base00 ? `#${json.base00}` : "#282c34"
    readonly property color base01: json.base01 ? `#${json.base01}` : "#3f4451"
    readonly property color base02: json.base02 ? `#${json.base02}` : "#4f5666"
    readonly property color base03: json.base03 ? `#${json.base03}` : "#545862"
    readonly property color base04: json.base04 ? `#${json.base04}` : "#9196a1"
    readonly property color base05: json.base05 ? `#${json.base05}` : "#abb2bf"
    readonly property color base06: json.base06 ? `#${json.base06}` : "#e6e6e6"
    readonly property color base07: json.base07 ? `#${json.base07}` : "#ffffff"
    readonly property color base08: json.base08 ? `#${json.base08}` : "#e05561"
    readonly property color base09: json.base09 ? `#${json.base09}` : "#d18f52"
    readonly property color base0A: json.base0A ? `#${json.base0A}` : "#e6b965"
    readonly property color base0B: json.base0B ? `#${json.base0B}` : "#8cc265"
    readonly property color base0C: json.base0C ? `#${json.base0C}` : "#42b3c2"
    readonly property color base0D: json.base0D ? `#${json.base0D}` : "#4aa5f0"
    readonly property color base0E: json.base0E ? `#${json.base0E}` : "#c162de"
    readonly property color base0F: json.base0F ? `#${json.base0F}` : "#bf4034"
    readonly property string author: json.author ? json.author : "FredHappyface (https://github.com/fredHappyface)"
    readonly property string scheme: json.scheme ? json.scheme : "One Dark"
    readonly property string slug: json.slug ? json.slug : "one-dark"

    FileView {
        path: `${Quickshell.env("HOME")}/.config/stylix/palette.json`
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()

        // Reads the values of the keys specified below from the json file
        JsonAdapter {
            id: json
            property string base00
            property string base01
            property string base02
            property string base03
            property string base04
            property string base05
            property string base06
            property string base07
            property string base08
            property string base09
            property string base0A
            property string base0B
            property string base0C
            property string base0D
            property string base0E
            property string base0F
            property string author
            property string scheme
            property string slug
        }
    }
}
