pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // Properties
    property bool isRecording: false
    property bool isReplayMode: false
    property string outputDir: "/home/apexu/Videos/Replays"
    property int replayBufferSeconds: 60
    property int fps: 60
    property string audioSource: "default_output"
    property string container: "mp4"

    // Signals
    signal recordingStarted
    signal recordingStopped
    signal replaySaved(string path)
    signal error(string message)

    // Process for managing gpu-screen-recorder
    property Process recorderProcess: Process {
        id: recorderProcess
        running: false

        onRunningChanged: {
            root.isRecording = running;
            root.isReplayMode = running;
            if (running) {
                root.recordingStarted();
            } else {
                root.recordingStopped();
            }
        }

        onExited: function (exitCode) {
            if (exitCode !== 0) {
                root.error("gpu-screen-recorder exited with code: " + exitCode);
                console.log("exit ", exitCode)
            }
        }
    }

    function sendNotification(summary, body, urgency) {
        urgency = urgency || "normal";
        Quickshell.execDetached(["notify-send", "-a", "GPU Screen Recorder", "-u", urgency, "-i", "video-x-generic", summary, body]);
    }

    function startReplayMode() {
        if (recorderProcess.running) {
            console.log("gpu-screen-recorder is already running");
            return false;
        }

        recorderProcess.command = ["fish", "-c", `gpu-screen-recorder -w screen -restart-replay-on-save yes -f ${root.fps.toString()} -a ${root.audioSource} -c ${root.container} -r ${root.replayBufferSeconds.toString()} -o ${root.outputDir}`];

        recorderProcess.running = true;
        console.log("Started gpu-screen-recorder in replay mode");
        root.sendNotification("Starting Recording", "Started instant replay.");
        return true;
    }

    function saveReplay() {
        if (!recorderProcess.running) {
            root.error("Cannot save replay: recorder is not running");
            return false;
        }

        Quickshell.execDetached(["fish", "-c", "pkill -SIGRTMIN+1 -f gpu-screen-recorder"]);
        root.sendNotification("Saving Replay", "Saved last " + root.replayBufferSeconds + " seconds to " + root.outputDir + ".");
        console.log("Saving replay buffer...");
        return true;
    }

    function stopReplayMode() {
        if (!recorderProcess.running) {
            console.log("gpu-screen-recorder is not running");
            return false;
        }

        recorderProcess.running = false;
        console.log("Stopped gpu-screen-recorder");
        root.sendNotification("Stopping Recording", "Stopped instant replay.");
        return true;
    }

    // Toggle replay mode
    function toggleReplayMode() {
        if (recorderProcess.running) {
            return stopReplayMode();
        } else {
            return startReplayMode();
        }
    }

    property Process checkProcess: Process {
        id: checkProcess
        command: ["which", "gpu-screen-recorder"]
        running: true

        onExited: function (exitCode) {
            if (exitCode !== 0) {
                root.error("gpu-screen-recorder is not installed or not in PATH");
            }
        }
    }
}
