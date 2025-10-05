import app from "ags/gtk4/app";
import { Astal, Gtk, Gdk } from "ags/gtk4";
import Workspaces from "./Workspaces";
import Volume from "./Volume";
import Clock from "./Clock";
import Mpris from "./Mpris";
import Battery from "./Battery";
import Tray from "./Tray";
import { onCleanup } from "gnim";
import Network from "./Network";

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

  let win: Astal.Window;
  onCleanup(() => {
    win.destroy();
  });

  return (
    <window
      $={(self) => (win = self)}
      visible
      name="bar"
      class="Bar"
      gdkmonitor={gdkmonitor}
      anchor={TOP | LEFT | RIGHT}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      application={app}
      height_request={46}
    >
      <centerbox class="main">
        <Workspaces $type="start" />

        <box spacing={8} $type="center">
          <Mpris />
          <Clock />
        </box>
        <box $type="end" spacing={8}>
          <box class="module" spacing={4}>
            <Network />
            <Volume />
            <Battery />
          </box>
          <Tray />
        </box>
      </centerbox>
    </window>
  );
}
