import app from "ags/gtk4/app";
import { Astal, Gtk, Gdk } from "ags/gtk4";
import Workspaces from "./Workspaces";
import Volume from "./Volume";
import Clock from "./Clock";
import Mpris from "./Mpris";
import Battery from "./Battery";
import Tray from "./Tray";

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

  return (
    <window
      visible
      name="bar"
      class="Bar"
      gdkmonitor={gdkmonitor}
      anchor={TOP | LEFT | RIGHT}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      application={app}
      height_request={46}
    >
      <centerbox orientation={Gtk.Orientation.HORIZONTAL} class="main">
        <Workspaces $type="start" />

        <Mpris $type="center" />
        <box orientation={Gtk.Orientation.HORIZONTAL} $type="end" spacing={8}>
          <box
            orientation={Gtk.Orientation.HORIZONTAL}
            class="module"
            spacing={4}
          >
            <Volume />
            <Battery />
          </box>
          <Tray />
          <Clock />
        </box>
      </centerbox>
    </window>
  );
}
