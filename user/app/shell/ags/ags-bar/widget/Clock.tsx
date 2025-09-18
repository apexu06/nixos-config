import { Gtk } from "ags/gtk4";
import { createPoll } from "ags/time";

export default function Clock() {
  const time = createPoll("", 1000, 'date "+%H:%M:%S"');

  return (
    <menubutton class="module" css="min-width: 72px;">
      <label label={time} />
      <popover $={(self) => self.set_has_arrow(false)}>
        <Gtk.Calendar />
      </popover>
    </menubutton>
  );
}
