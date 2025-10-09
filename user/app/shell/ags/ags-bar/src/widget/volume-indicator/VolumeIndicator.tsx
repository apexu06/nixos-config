import { Astal, Gdk, Gtk } from "ags/gtk4";
import app from "ags/gtk4/app";
import { timeout, Timer } from "ags/time";
import AstalWp from "gi://AstalWp?version=0.1";
import { createBinding, createState, onCleanup } from "ags";

export default function VolumeIndicator(gdkmonitor: Gdk.Monitor) {
  const wp = AstalWp.get_default();
  const [windowVisible, setWindowVisible] = createState(false);
  const [revealChild, setRevealChild] = createState(false);
  let hideTimeout: Timer;

  function onVolumeChanged() {
    if (hideTimeout) hideTimeout.cancel();

    if (!windowVisible.get()) {
      setWindowVisible(true);
      setRevealChild(true);
    }

    hideTimeout = timeout(2000, () => {
      setRevealChild(false);
    });
  }

  let win: Astal.Window;
  onCleanup(() => {
    win.destroy();
  });

  wp.defaultSpeaker.connect("notify::volume", onVolumeChanged);

  return (
    <window
      $={(self) => (win = self)}
      visible={windowVisible}
      name="volume-indicator"
      class="VolumeIndicator"
      gdkmonitor={gdkmonitor}
      anchor={Astal.WindowAnchor.BOTTOM}
      application={app}
      layer={Astal.Layer.OVERLAY}
      height_request={150}
    >
      <revealer
        revealChild={revealChild}
        transitionType={Gtk.RevealerTransitionType.SWING_RIGHT}
        transitionDuration={300}
        onNotifyChildRevealed={(r) =>
          !r.childRevealed && setWindowVisible(false)
        }
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
