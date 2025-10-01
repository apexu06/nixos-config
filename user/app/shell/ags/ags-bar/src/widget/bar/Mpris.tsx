import { Gdk, Gtk } from "ags/gtk4";
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
import AstalPowerProfiles from "gi://AstalPowerProfiles?version=0.1";

export default function Mpris() {
  const mpris = AstalMpris.get_default();
  const apps = new AstalApps.Apps();

  let popover: Gtk.Popover;

  const [currentPlayer, setCurrentPlayer] =
    createState<AstalMpris.Player | null>({} as AstalMpris.Player);

  const players = createBinding(mpris, "players");

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
    const c = currentPlayer.get();
    const validPlayers = mpris.players.filter(
      (p) => p.identity !== null && p.identity !== undefined,
    );

    setCurrentPlayer(
      c && isPlayerValid(c, validPlayers) ? c : findValidPlayer(validPlayers),
    );
  });

  mpris.connect("player-closed", () => {
    const c = currentPlayer.get();
    const validPlayers = mpris.players.filter(
      (p) => p.identity !== null && p.identity !== undefined,
    );

    const newCurrentPlayer = isPlayerValid(c, validPlayers)
      ? c
      : findValidPlayer(validPlayers);

    setCurrentPlayer(newCurrentPlayer);
  });

  return (
    <box
      class="module"
      orientation={Gtk.Orientation.HORIZONTAL}
      spacing={8}
      visible={currentPlayer((c) => c?.identity !== undefined)}
    >
      <With value={currentPlayer}>
        {(currentPlayer) => {
          if (currentPlayer?.identity === undefined) return;

          const [app] = apps.exact_query(currentPlayer.entry);
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
              <Player player={currentPlayer} />
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
        <box
          orientation={Gtk.Orientation.VERTICAL}
          spacing={8}
          class={"player-selection"}
          hexpand={false}
        >
          <For each={players}>
            {(player) => {
              const [app] = apps.exact_query(player.entry);
              return (
                <button
                  onClicked={() => {
                    setCurrentPlayer(player);
                    popover.popdown();
                  }}
                  class="player-selection-button"
                >
                  <box orientation={Gtk.Orientation.HORIZONTAL} spacing={8}>
                    <image visible={!!app.iconName} iconName={app.iconName} />
                    <label visible={!!app.name} label={app.name} />

                    <With value={currentPlayer}>
                      {(currentPlayer) => {
                        if (currentPlayer === player) {
                          return (
                            <image
                              css="margin-left: 4px;"
                              visible={!!app.iconName}
                              iconName={"emblem-default"}
                              halign={Gtk.Align.END}
                            />
                          );
                        }
                      }}
                    </With>
                  </box>
                </button>
              );
            }}
          </For>
        </box>
      </popover>
    </box>
  );
}

function Player({ player }: { player: AstalMpris.Player }) {
  const powerprofiles = AstalPowerProfiles.get_default();
  const activeProfile = createBinding(powerprofiles, "activeProfile");

  const title = createBinding(player, "title");
  const artist = createBinding(player, "artist");
  const progress = createBinding(player, "position");
  const length = createBinding(player, "length");
  const cover = createBinding(player, "coverArt");
  const songInfo = createComputed((get) => {
    if (get(artist) === null) {
      return "nothing playing";
    }
    return get(title) + " - " + get(artist);
  });
  const shuffleStatus = createBinding(player, "shuffleStatus");
  const loopStatus = createBinding(player, "loopStatus");

  return (
    <menubutton>
      <box orientation={Gtk.Orientation.HORIZONTAL} hexpand={false} spacing={8}>
        <label
          maxWidthChars={20}
          ellipsize={Pango.EllipsizeMode.END}
          label={songInfo}
        />

        <With value={activeProfile}>
          {(p) => {
            if (p !== "power-saver") {
              return <Cava />;
            }
          }}
        </With>
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
              valign={Gtk.Align.CENTER}
            >
              <image valign={Gtk.Align.CENTER} file={cover} pixelSize={72} />

              <box
                orientation={Gtk.Orientation.VERTICAL}
                spacing={4}
                width_request={200}
                valign={Gtk.Align.CENTER}
              >
                <centerbox>
                  <box
                    $type="start"
                    spacing={2}
                    orientation={Gtk.Orientation.VERTICAL}
                  >
                    <label
                      label={title}
                      halign={Gtk.Align.START}
                      max_width_chars={22}
                      ellipsize={Pango.EllipsizeMode.END}
                      css={"font-weight: bold; font-size: 18px;"}
                    />
                    <label
                      visible={artist((a) => a !== null)}
                      label={title}
                      halign={Gtk.Align.START}
                      max_width_chars={17}
                      ellipsize={Pango.EllipsizeMode.END}
                      css={"font-size: 16px;"}
                    />
                  </box>

                  <box
                    $type="end"
                    css="margin-right: 24px;"
                    hexpand={false}
                    spacing={8}
                  >
                    <button
                      visible={loopStatus(
                        (l) => l !== AstalMpris.Loop.UNSUPPORTED,
                      )}
                      onClicked={() => player.loop()}
                    >
                      <image
                        iconName="media-playlist-repeat-symbolic"
                        class={loopStatus((l) =>
                          l === AstalMpris.Loop.PLAYLIST
                            ? "playlist-loop"
                            : l === AstalMpris.Loop.TRACK
                              ? "track-loop"
                              : "",
                        )}
                      />
                    </button>
                    <button
                      onClicked={() => player.play_pause()}
                      visible={createBinding(player, "canControl")}
                      hexpand={false}
                    >
                      <box>
                        <image
                          iconName="media-playback-pause-symbolic"
                          visible={createBinding(
                            player,
                            "playbackStatus",
                          )((s) => s === AstalMpris.PlaybackStatus.PLAYING)}
                        />
                        <image
                          iconName="media-playback-start-symbolic"
                          visible={createBinding(
                            player,
                            "playbackStatus",
                          )((s) => s !== AstalMpris.PlaybackStatus.PLAYING)}
                        />
                      </box>
                    </button>

                    <button
                      visible={shuffleStatus(
                        (s) => s !== AstalMpris.Shuffle.UNSUPPORTED,
                      )}
                      onClicked={() => player.shuffle()}
                    >
                      <image
                        iconName="media-playlist-shuffle-symbolic"
                        class={shuffleStatus((s) =>
                          s === AstalMpris.Shuffle.ON ? "shuffle-enabled" : "",
                        )}
                      />
                    </button>
                  </box>
                </centerbox>

                <box spacing={2}>
                  <button
                    onClicked={() => player.previous()}
                    visible={createBinding(player, "canGoPrevious")}
                  >
                    <image iconName="media-seek-backward-symbolic" />
                  </button>
                  <slider
                    value={progress}
                    min={0}
                    max={length}
                    onChangeValue={({ value }) => player.set_position(value)}
                    css="padding-top: 0px; padding-bottom: 0px;"
                    hexpand
                    visible={createBinding(player, "canSeek")}
                  />

                  <button
                    onClicked={() => player.next()}
                    visible={createBinding(player, "canGoNext")}
                  >
                    <image iconName="media-seek-forward-symbolic" />
                  </button>
                </box>
              </box>

              {/*
                <slider
                  css={"padding: 0px;"}
                  min={0}
                  max={1}
                  visible={createBinding(player, "canGoNext")}
                  value={createBinding(player, "volume")}
                  hexpand
                  onChangeValue={({ value }) => {
                    player.set_volume(value);
                  }}
                />
*/}
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

          cr.$dispose();
        });

        cava?.connect("notify::values", () => self.queue_draw());
      }}
    />
  );
}
