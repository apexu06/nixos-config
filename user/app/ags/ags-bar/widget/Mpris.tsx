import { Gtk } from "ags/gtk4";
import AstalApps from "gi://AstalApps?version=0.1";
import AstalMpris from "gi://AstalMpris?version=0.1";
import { createBinding, createState, For, With } from "gnim";

export default function Mpris() {
  const mpris = AstalMpris.get_default();
  const players = createBinding(mpris, "players");
  const apps = new AstalApps.Apps();

  let popover: Gtk.Popover;

  const [currentPlayer, setCurrentPlayer] = createState<
    AstalMpris.Player | undefined
  >(players.get()[0]);

  return (
    <box orientation={Gtk.Orientation.HORIZONTAL}>
      <box>
        <With value={currentPlayer}>
          {(player) => {
            if (!player) return;

            const [app] = apps.exact_query(player.entry);

            return (
              <button class="module" onClicked={() => popover.popup()}>
                <image iconName={app.iconName} />
              </button>
            );
          }}
        </With>
        <popover $={(p) => (popover = p)}>
          <box
            orientation={Gtk.Orientation.VERTICAL}
            hexpand={false}
            spacing={8}
            class="player-selection"
          >
            <For each={players}>
              {(player) => {
                const [app] = apps.exact_query(player.entry);

                return (
                  <button onClicked={() => setCurrentPlayer(player)}>
                    <box orientation={Gtk.Orientation.HORIZONTAL} spacing={8}>
                      <image visible={!!app.iconName} iconName={app.iconName} />
                      <label visible={!!app.name} label={app.name} />
                    </box>
                  </button>
                );
              }}
            </For>
          </box>
        </popover>
      </box>
    </box>
  );
}
