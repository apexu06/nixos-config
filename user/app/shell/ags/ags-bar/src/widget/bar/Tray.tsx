import AstalTray from "gi://AstalTray?version=0.1";
import { createBinding, For } from "gnim";

export default function Tray() {
  const tray = AstalTray.get_default();

  const items = createBinding(tray, "items");

  return (
    <box class="module" spacing={8}>
      <For each={items}>
        {(item) => (
          <box>
            <menubutton
              $={(self) => {
                self.insert_action_group("dbusmenu", item.actionGroup);
              }}
              tooltipMarkup={item.tooltipMarkup}
              onActivate={() => item.about_to_show()}
              menuModel={item.menuModel}
            >
              <image gicon={createBinding(item, "gicon")} />
            </menubutton>
          </box>
        )}
      </For>
    </box>
  );
}
