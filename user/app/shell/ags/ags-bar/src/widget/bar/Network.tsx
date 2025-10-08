import { Gtk } from "ags/gtk4";
import AstalNetwork from "gi://AstalNetwork?version=0.1";
import GLib from "gi://GLib?version=2.0";
import { createBinding, createState, For, With } from "gnim";

export default function Network() {
  const network = AstalNetwork.get_default();
  const wifi = createBinding(network, "wifi");
  const ethernet = createBinding(network, "wired");

  let popover: Gtk.Popover;

  return (
    <box visible={Boolean(wifi)}>
      <With value={wifi}>
        {(wifi) => {
          const accessPoints = createBinding(
            wifi,
            "accessPoints",
          )((aps) => {
            const connected = wifi.activeAccessPoint;
            const bySSID = new Map<string, AstalNetwork.AccessPoint>();

            for (const a of aps) {
              if (!a.ssid) continue;

              const existing = bySSID.get(a.ssid);

              if (connected && a.bssid === connected.bssid) {
                bySSID.set(a.ssid, a);
                continue;
              }

              if (!existing || a.strength > existing.strength) {
                bySSID.set(a.ssid, a);
              }
            }

            return Array.from(bySSID.values()).sort(
              (a, b) => b.strength - a.strength,
            );
          });

          // accessPoints.subscribe(() => {
          //   accessPoints.get().forEach((a) => {
          //     console.log(
          //       `${a.ssid} | ${a.flags} | ${a.mode} | ${a.bandwidth} | ${(a.frequency / 1000).toFixed(2)} | ${a === wifi.activeAccessPoint}`,
          //     );
          //   });
          // });
          //
          return (
            <box hexpand={false}>
              <button
                onClicked={() => {
                  if (!wifi.scanning) wifi.scan();
                  popover.popup();
                }}
              >
                <image iconName={createBinding(wifi, "iconName")} />
              </button>

              <popover
                widthRequest={400}
                $={(self) => {
                  popover = self;
                  self.set_has_arrow(false);
                  self.connect("map", () => {
                    GLib.idle_add(GLib.PRIORITY_DEFAULT, () => {
                      self.present();
                      return GLib.SOURCE_REMOVE;
                    });
                  });
                }}
              >
                <box orientation={Gtk.Orientation.VERTICAL} spacing={8} hexpand>
                  <centerbox class="base-container">
                    <label
                      label={"Wifi"}
                      $type="start"
                      css={"font-size: 20px; font-weight: bold;"}
                    />
                    <switch
                      active={wifi.enabled}
                      onNotifyActive={({ active }) => wifi.set_enabled(active)}
                      $type="end"
                    />
                  </centerbox>
                  <box class="base-container">
                    <box
                      orientation={Gtk.Orientation.VERTICAL}
                      spacing={8}
                      vexpand
                    >
                      <label
                        halign={Gtk.Align.START}
                        label="Available networks"
                        css={"font-size: 18px; font-weight: bold;"}
                      />
                      <Gtk.Separator />
                      <scrolledwindow
                        maxContentHeight={200}
                        css="min-height: 150px;"
                        propagate_natural_height
                      >
                        <box orientation={Gtk.Orientation.VERTICAL} spacing={4}>
                          <For each={accessPoints}>
                            {(ap: AstalNetwork.AccessPoint) => {
                              const [menuOpen, setMenuOpen] =
                                createState(false);

                              const isActiveAp = createBinding(
                                wifi,
                                "activeAccessPoint",
                              )((active) => active === ap);

                              function handleClick() {
                                setMenuOpen(!menuOpen.get());
                              }

                              return (
                                <box
                                  orientation={Gtk.Orientation.VERTICAL}
                                  css="margin-right: 12px;"
                                >
                                  <button
                                    hexpand
                                    class={`network-button ${menuOpen((o) => (o ? "active" : ""))}`}
                                    onClicked={handleClick}
                                  >
                                    <box spacing={4}>
                                      <image
                                        iconName={createBinding(ap, "iconName")}
                                      />
                                      <label
                                        label={createBinding(ap, "ssid")}
                                      />
                                      <image
                                        iconName="object-select-symbolic"
                                        visible={isActiveAp}
                                      />
                                    </box>
                                  </button>
                                  <revealer revealChild={menuOpen} hexpand>
                                    <box class="network-dropdown" hexpand>
                                      <button
                                        class="network-connect-button"
                                        hexpand
                                      >
                                        <label
                                          label={isActiveAp((a) =>
                                            a ? "Disconnect" : "Connect",
                                          )}
                                        />
                                      </button>
                                      <button
                                        class="network-info-button"
                                        hexpand
                                      >
                                        <label label="Info" />
                                      </button>
                                    </box>
                                  </revealer>
                                </box>
                              );
                            }}
                          </For>
                        </box>
                      </scrolledwindow>
                    </box>
                  </box>
                </box>
              </popover>
            </box>
          );
        }}
      </With>
    </box>
  );
}
