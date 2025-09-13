import app from "ags/gtk4/app";
import { Astal, Gtk, Gdk } from "ags/gtk4";
import Workspaces from "./Workspaces";
import Volume from "./Volume";
import Clock from "./Clock";

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
    >
      <centerbox orientation={Gtk.Orientation.HORIZONTAL} class="main">
        <Workspaces $type="start" />
        <box orientation={Gtk.Orientation.HORIZONTAL} $type="end" spacing={12}>
          <Volume />
          <Clock />
        </box>
      </centerbox>
    </window>
  );
}
