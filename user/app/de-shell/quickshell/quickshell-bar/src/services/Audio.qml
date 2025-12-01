pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property var nodes: Pipewire.nodes.values.reduce((acc, node) => {
        if (!node.isStream) {
            if (node.isSink)
                acc.sinks.push(node);
            else if (node.audio)
                acc.sources.push(node);
        }
        return acc;
    }, {
        sources: [],
        sinks: []
    })

    readonly property list<PwNode> sinks: nodes.sinks
    readonly property list<PwNode> sources: nodes.sources

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    PwObjectTracker {
        objects: [...root.sinks, ...root.sources]
    }

    function getVolumeIconName(): string {
        const muted = sink?.audio.muted;
        const volume = sink?.audio.volume;
        if (muted || volume === 0) {
            return "volume_off";
        } else if (volume < 0.33) {
            return "volume_mute";
        } else if (volume < 0.66) {
            return "volume_down";
        } else {
            return "volume_up";
        }
    }

    function toggleSinkMute() {
        sink.audio.muted = !sink.audio.muted;
    }

    function toggleSourceMute() {
        source.audio.muted = !source.audio.muted;
    }

    function setDefaultSink(sink: PwNode) {
        if (!source.isSink)
            Pipewire.preferredDefaultAudioSink = sink;
    }

    function setDefaultSource(source: PwNode) {
        if (source.isSink)
            return;

        Pipewire.preferredDefaultAudioSource = source;
    }
}
