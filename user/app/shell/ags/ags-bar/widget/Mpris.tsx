import { Gtk } from "ags/gtk4";
import AstalApps from "gi://AstalApps?version=0.1";
import AstalCava from "gi://AstalCava?version=0.1";
import AstalMpris from "gi://AstalMpris?version=0.1";
import {
  Accessor,
  createBinding,
  createComputed,
  createState,
  For,
  With,
} from "ags";
import Pango from "gi://Pango?version=1.0";

type PlayerState = {
  currentPlayer: AstalMpris.Player | null;
  players: AstalMpris.Player[];
};

export default function Mpris() {
  const mpris = AstalMpris.get_default();
  const apps = new AstalApps.Apps();

  let popover: Gtk.Popover;

  const [state, setState] = createState<PlayerState>({
    currentPlayer: mpris.players[0],
    players: mpris.players,
  });

  function findValidPlayer(
    players: AstalMpris.Player[],
  ): AstalMpris.Player | null {
    return (
      players.find((p) => p.identity !== null && p.identity !== undefined) ||
      null
    );
  }

  function isPlayerValid(
    player: AstalMpris.Player | null,
    players: AstalMpris.Player[],
  ): boolean {
    if (!player || player.identity === null || player.identity === undefined) {
      return false;
    }
    return players.some((p) => p.identity === player.identity);
  }

  mpris.connect("player-added", () => {
    const currentState = state.get();
    const validPlayers = mpris.players.filter(
      (p) => p.identity !== null && p.identity !== undefined,
    );

    setState({
      players: validPlayers,
      currentPlayer:
        currentState.currentPlayer &&
        isPlayerValid(currentState.currentPlayer, validPlayers)
          ? currentState.currentPlayer
          : findValidPlayer(validPlayers),
    });
  });

  mpris.connect("player-closed", () => {
    const currentState = state.get();
    const validPlayers = mpris.players.filter(
      (p) => p.identity !== null && p.identity !== undefined,
    );

    const newCurrentPlayer = isPlayerValid(
      currentState.currentPlayer,
      validPlayers,
    )
      ? currentState.currentPlayer
      : findValidPlayer(validPlayers);

    setState({
      players: validPlayers,
      currentPlayer: newCurrentPlayer,
    });
  });

  return (
    <box class="module" orientation={Gtk.Orientation.HORIZONTAL} spacing={8}>
      <With value={state}>
        {(state) => {
          if (!state.currentPlayer || state.currentPlayer.identity === null)
            return;

          const [app] = apps.exact_query(state.currentPlayer.entry);
          return (
            <box orientation={Gtk.Orientation.HORIZONTAL} spacing={4}>
              <button onClicked={() => popover.popup()}>
                <image iconName={app.iconName} />
              </button>
              <Player state={state} />
            </box>
          );
        }}
      </With>
      <popover
        $={(p) => {
          popover = p;
          popover.set_has_arrow(false);
        }}
      >
        <With value={state}>
          {(state) => (
            <box
              orientation={Gtk.Orientation.VERTICAL}
              spacing={8}
              class={"player-selection"}
              hexpand={false}
            >
              {state.players.map((p) => {
                const [app] = apps.exact_query(p.entry);
                return (
                  <button
                    onClicked={() => {
                      setState({ ...state, currentPlayer: p });
                      popover.popdown();
                    }}
                    class="player-selection-button"
                  >
                    <box orientation={Gtk.Orientation.HORIZONTAL} spacing={8}>
                      <image visible={!!app.iconName} iconName={app.iconName} />
                      <label visible={!!app.name} label={app.name} />
                      {state.currentPlayer === p && (
                        <image
                          css="margin-left: 4px;"
                          visible={!!app.iconName}
                          iconName={"emblem-default"}
                          halign={Gtk.Align.END}
                        />
                      )}
                    </box>
                  </button>
                );
              })}
            </box>
          )}
        </With>
      </popover>
    </box>
  );
}

function Cava() {
  const cava = AstalCava.get_default();

  if (cava) {
    cava.set_bars(8);
  }

  return (
    <box orientation={Gtk.Orientation.HORIZONTAL} valign={Gtk.Align.END}>
      <drawingarea
        width_request={40}
        height_request={10}
        $={(self) => {
          self.set_draw_func((area, cr, width, height) => {
            const values = cava?.get_values() ?? [];
            const barWidth = width / values.length;

            values.forEach((v, i) => {
              const barHeight = v * height;
              cr.rectangle(
                i * barWidth,
                height - barHeight,
                barWidth - 2,
                barHeight,
              );
              cr.setSourceRGBA(1, 1, 1, 1);
              cr.fill();
            });

            cava?.connect("notify::values", () => area.queue_draw());
          });
        }}
      />
    </box>
  );
}

function Player({ state }: { state: PlayerState }) {
  if (!state.currentPlayer) return;
  const title = createBinding(state.currentPlayer, "title");
  const artist = createBinding(state.currentPlayer, "artist");

  const songInfo = createComputed((get) => get(title) + " - " + get(artist));
  return (
    <box orientation={Gtk.Orientation.HORIZONTAL} valign={Gtk.Align.CENTER}>
      <label
        maxWidthChars={20}
        ellipsize={Pango.EllipsizeMode.END}
        label={songInfo}
      />
    </box>
  );
}
