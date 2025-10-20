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
        const muted = sink.audio.muted;
        const volume = sink.audio.volume;
        if (muted || volume === 0) {
            return "audio-volume-muted-symbolic";
        } else if (volume < 0.33) {
            return "audio-volume-low-symbolic";
        } else if (volume < 0.66) {
            return "audio-volume-medium-symbolic";
        } else {
            return "audio-volume-high-symbolic";
        }
    }

    function setDefaultSink(id: int) {
        const sink = sinks.find(s => s.id === id);
        if (!sink)
            return;
        Pipewire.preferredDefaultAudioSink = sink;
    }

    function setDefaultSource(id: int) {
        const source = sources.find(s => s.id === id);
        if (!source)
            return;

        Pipewire.preferredDefaultAudioSource = source;
    }
}
