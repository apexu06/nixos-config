import { Gtk } from "ags/gtk4";
import { createPoll } from "ags/time";

export default function Clock() {
  const date = createPoll("", 5 * 60 * 1000, 'date "+%d/%m"');
  const time = createPoll("", 1000, 'date "+%H:%M:%S"');

  return (
    <menubutton class="module">
      <box
        valign={Gtk.Align.CENTER}
        orientation={Gtk.Orientation.HORIZONTAL}
        spacing={4}
      >
        <label valign={Gtk.Align.CENTER} label={time} css="min-width: 70px;" />

        <Gtk.Separator />
        <label valign={Gtk.Align.BASELINE} class="font-small" label={date} />
      </box>
      <popover $={(self) => self.set_has_arrow(false)}>
        <Gtk.Calendar />
      </popover>
    </menubutton>
  );
}
