import { Astal, Gdk, Gtk } from "ags/gtk4";
import app from "ags/gtk4/app";
import AstalWp from "gi://AstalWp?version=0.1";
import GLib from "gi://GLib?version=2.0";
import { createBinding, createState } from "gnim";

export default function VolumeIndicator(gdkmonitor: Gdk.Monitor) {
  const wp = AstalWp.get_default();
  const [windowVisible, setWindowVisible] = createState(false);
  const [revealChild, setRevealChild] = createState(false);
  let hideTimeout: GLib.Source | null = null;

  function onVolumeChanged() {
    if (hideTimeout) clearTimeout(hideTimeout);

    if (!windowVisible.get()) {
      setWindowVisible(true);
      setTimeout(() => setRevealChild(true), 100);
    } else {
      setRevealChild(true);
    }

    hideTimeout = setTimeout(() => {
      setRevealChild(false);
      setTimeout(() => {
        setWindowVisible(false);
      }, 300);
      hideTimeout = null;
    }, 2000);
  }

  wp.defaultSpeaker.connect("notify::volume", onVolumeChanged);

  return (
    <window
      visible={windowVisible}
      name="volume-indicator"
      class="VolumeIndicator"
      gdkmonitor={gdkmonitor}
      anchor={Astal.WindowAnchor.BOTTOM}
      application={app}
      exclusivity={Astal.Exclusivity.IGNORE}
      layer={Astal.Layer.OVERLAY}
    >
      <revealer
        revealChild={revealChild}
        transitionType={Gtk.RevealerTransitionType.SWING_UP}
        transitionDuration={300}
      >
        <box class="container" spacing={8} width_request={200}>
          <image iconName={createBinding(wp.defaultSpeaker, "volume_icon")} />
          <levelbar
            minValue={0}
            maxValue={1}
            value={createBinding(
              wp.defaultSpeaker,
              "volume",
            )((v) => Math.min(1, v))}
            hexpand
          />
        </box>
      </revealer>
    </window>
  );
}
