import { Gdk, Gtk } from "ags/gtk4";
import AstalApps from "gi://AstalApps?version=0.1";
import AstalCava from "gi://AstalCava?version=0.1";
import AstalMpris from "gi://AstalMpris?version=0.1";
import {
  Accessor,
  createBinding,
  createComputed,
  createState,
  With,
} from "ags";
import Pango from "gi://Pango?version=1.0";
import AstalPowerProfiles from "gi://AstalPowerProfiles?version=0.1";

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
    <box
      class="module"
      orientation={Gtk.Orientation.HORIZONTAL}
      spacing={8}
      visible={state((s) => s.players.length !== 0)}
    >
      <With value={state}>
        {(state) => {
          if (!state.currentPlayer || state.currentPlayer.identity === null)
            return;

          const [app] = apps.exact_query(state.currentPlayer.entry);
          return (
            <box
              orientation={Gtk.Orientation.HORIZONTAL}
              spacing={8}
              valign={Gtk.Align.CENTER}
            >
              <button onClicked={() => popover.popup()}>
                <image iconName={app.iconName} />
              </button>
              <Gtk.Separator orientation={Gtk.Orientation.VERTICAL} />
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

function Player({ state }: { state: PlayerState }) {
  if (!state.currentPlayer || state.currentPlayer === null) return <box></box>;

  const powerprofiles = AstalPowerProfiles.get_default();
  const activeProfile = createBinding(powerprofiles, "activeProfile");

  const title = createBinding(state.currentPlayer, "title");
  const artist = createBinding(state.currentPlayer, "artist");
  const progress = createBinding(state.currentPlayer, "position");
  const length = createBinding(state.currentPlayer, "length");
  const cover = createBinding(state.currentPlayer, "coverArt");
  const songInfo = createComputed((get) => {
    if (get(artist) === null) {
      return "nothing playing";
    }
    return get(title) + " - " + get(artist);
  });
  const progressPercent = createComputed((get) => get(progress) / get(length));

  return (
    <menubutton>
      <box orientation={Gtk.Orientation.HORIZONTAL} hexpand={false} spacing={8}>
        <box
          orientation={Gtk.Orientation.VERTICAL}
          valign={Gtk.Align.CENTER}
          spacing={3}
        >
          <label
            maxWidthChars={20}
            ellipsize={Pango.EllipsizeMode.END}
            label={songInfo}
          />

          <drawingarea
            height_request={2}
            css={"border-radius: 8px;"}
            hexpand
            class="song-progress"
            visible={progressPercent((p) => p !== 1)}
            $={(self) => {
              self.set_draw_func((area, cr, width, height) => {
                const style = area.get_style_context();
                const color = style.get_color();

                cr.rectangle(0, 0, width * progressPercent.get(), height);

                cr.setSourceRGBA(
                  color.red,
                  color.green,
                  color.blue,
                  color.alpha,
                );
                cr.fill();

                state.currentPlayer?.connect("notify::position", () =>
                  area.queue_draw(),
                );
              });
            }}
          />
        </box>

        {/*
        <With value={activeProfile}>
          {(p) => {
            if (p !== "power-saver") {
              return <Cava />;
            }
          }}
        </With>
*/}
      </box>

      <popover
        $={(self) => {
          self.set_has_arrow(false);
        }}
        width_request={480}
        height_request={110}
        class="player-popover"
      >
        <overlay>
          <box
            hexpand
            vexpand
            halign={Gtk.Align.FILL}
            valign={Gtk.Align.FILL}
            $={(self) => {
              self.add_css_class("cover-background");
              const provider = new Gtk.CssProvider();
              const display = Gdk.Display.get_default();

              Gtk.StyleContext.add_provider_for_display(
                display!,
                provider,
                Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION,
              );

              const update = (path: string) => {
                if (!path) return;
                const url = "file://" + path;
                provider.load_from_data(
                  `
              .cover-background {
                background-image: url("${url}");
                background-size: cover;
                background-position: center;
                background-repeat: no-repeat;
                filter: blur(3px) opacity(0.4);
              }
              `,
                  -1,
                );
              };
              cover.subscribe(() => update(cover.get()));
              update(cover.get());
            }}
          />
          <box class="player-container" $type="overlay">
            <label
              label={"choose something to play"}
              visible={artist((p) => p === null)}
            />
            <box
              orientation={Gtk.Orientation.HORIZONTAL}
              spacing={12}
              visible={artist((p) => p !== null)}
            >
              <image file={cover} pixelSize={72} />

              <box
                orientation={Gtk.Orientation.VERTICAL}
                spacing={4}
                hexpand
                width_request={200}
                valign={Gtk.Align.CENTER}
              >
                <label
                  label={title}
                  halign={Gtk.Align.START}
                  max_width_chars={19}
                  ellipsize={Pango.EllipsizeMode.END}
                  css={"font-weight: bold; font-size: 18px;"}
                />
                <label
                  visible={artist((a) => a !== null)}
                  label={artist}
                  halign={Gtk.Align.START}
                  max_width_chars={17}
                  ellipsize={Pango.EllipsizeMode.END}
                  css={"font-size: 16px;"}
                />
              </box>

              <Gtk.Separator orientation={Gtk.Orientation.VERTICAL} />

              <box
                orientation={Gtk.Orientation.VERTICAL}
                valign={Gtk.Align.BASELINE_CENTER}
                spacing={16}
                width_request={100}
              >
                <box halign={Gtk.Align.CENTER} spacing={16}>
                  <button
                    onClicked={() => state.currentPlayer?.previous()}
                    visible={createBinding(
                      state.currentPlayer,
                      "canGoPrevious",
                    )}
                    $type="start"
                  >
                    <image iconName="media-seek-backward-symbolic" />
                  </button>
                  <button
                    onClicked={() => state.currentPlayer?.play_pause()}
                    visible={createBinding(state.currentPlayer, "canControl")}
                    $type="center"
                  >
                    <box>
                      <image
                        iconName="media-playback-pause-symbolic"
                        visible={createBinding(
                          state.currentPlayer,
                          "playbackStatus",
                        )((s) => s === AstalMpris.PlaybackStatus.PLAYING)}
                      />
                      <image
                        iconName="media-playback-start-symbolic"
                        visible={createBinding(
                          state.currentPlayer,
                          "playbackStatus",
                        )((s) => s !== AstalMpris.PlaybackStatus.PLAYING)}
                      />
                    </box>
                  </button>

                  <button
                    onClicked={() => state.currentPlayer?.next()}
                    visible={createBinding(state.currentPlayer, "canGoNext")}
                    $type="end"
                  >
                    <image iconName="media-seek-forward-symbolic" />
                  </button>
                </box>
                <slider
                  css={"padding: 0px;"}
                  min={0}
                  max={1}
                  visible={createBinding(state.currentPlayer, "canGoNext")}
                  value={createBinding(state.currentPlayer, "volume")}
                  hexpand
                  onChangeValue={({ value }) => {
                    state.currentPlayer?.set_volume(value);
                  }}
                />
              </box>
            </box>
          </box>
        </overlay>
      </popover>
    </menubutton>
  );
}

function Cava() {
  const cava = AstalCava.get_default();

  if (cava) {
    cava.set_bars(6);
  }

  return (
    <drawingarea
      width_request={30}
      class="cava"
      $={(self) => {
        self.set_draw_func((area, cr, width, height) => {
          const style = area.get_style_context();
          const color = style.get_color();
          const values = cava?.get_values() ?? [];
          const barWidth = width / values.length;
          const baseline = height / 2;

          values.forEach((v, i) => {
            const barHeight = v * (height / 2);
            const x = i * barWidth;

            cr.rectangle(x, baseline - barHeight, barWidth - 2, barHeight);
            cr.rectangle(x, baseline, barWidth - 2, barHeight);

            cr.setSourceRGBA(color.red, color.green, color.blue, color.alpha);
            cr.fill();
          });

          cava?.connect("notify::values", () => area.queue_draw());
        });
      }}
    />
  );
}
