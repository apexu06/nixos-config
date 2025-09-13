import { Gtk } from "ags/gtk4";
import { createPoll } from "ags/time";

export default function Clock() {
  const time = createPoll("", 1000, 'date "+%H:%M:%S"');

  return (
    <menubutton class="module" css="min-width: 72px;">
      <label label={time} />
      <popover>
        <Gtk.Calendar />
      </popover>
    </menubutton>
  );
}
