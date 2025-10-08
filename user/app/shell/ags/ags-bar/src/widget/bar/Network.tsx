import { Gtk } from "ags/gtk4";
import { exec, execAsync, subprocess } from "ags/process";
import { timeout } from "ags/time";
import AstalNetwork from "gi://AstalNetwork?version=0.1";
import GLib from "gi://GLib?version=2.0";
import NM from "gi://NM?version=1.0";
import { Accessor, createBinding, createState, For, With } from "gnim";

function deleteConnection(ssid: string) {
  execAsync(["bash", "-c", `nmcli connection delete ${ssid}`]);
}

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
                  <box
                    class="base-container"
                    visible={createBinding(wifi, "enabled")}
                  >
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
                      <Gtk.Separator hexpand />
                      <scrolledwindow
                        maxContentHeight={200}
                        css="min-height: 200px;"
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
                                    cssClasses={menuOpen((o) =>
                                      o
                                        ? ["active", "network-button"]
                                        : ["network-button"],
                                    )}
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
                                  <NetworkConnectivity
                                    isActiveAp={isActiveAp}
                                    menuOpen={menuOpen}
                                    wifi={wifi}
                                    ap={ap}
                                  />
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

function NetworkConnectivity({
  isActiveAp,
  menuOpen,
  wifi,
  ap,
}: {
  isActiveAp: Accessor<boolean>;
  menuOpen: Accessor<boolean>;
  wifi: AstalNetwork.Wifi;
  ap: AstalNetwork.AccessPoint;
}) {
  const [password, setPassword] = createState("");
  const [showPasswordInput, setShowPasswordInput] = createState(false);

  async function disconnect() {
    return new Promise((resolve, reject) => {
      wifi.deactivate_connection((_, res) => {
        try {
          resolve(wifi.deactivate_connection_finish(res));
        } catch (error) {
          reject(error);
        }
      });
    });
  }

  async function connect(password: string | null) {
    return new Promise((resolve, reject) => {
      ap.activate(password, (_, res) => {
        try {
          resolve(ap.activate_finish(res));
        } catch (error) {
          console.log("error in connect: ", error);
          reject(error);
        }
      });
    });
  }

  function handleInfoClick() {
    const uuid = exec([
      "bash",
      "-c",
      "nmcli --get-values connection.uuid c show " + ap.ssid,
    ]);
    subprocess(["nm-connection-editor", "-e", uuid]);
  }

  return (
    <revealer revealChild={menuOpen} hexpand>
      <box class="network-dropdown" hexpand spacing={8}>
        <overlay hexpand>
          <revealer
            revealChild={showPasswordInput((s) => !s)}
            transitionType={Gtk.RevealerTransitionType.SWING_RIGHT}
            width_request={0}
          >
            <box hexpand homogeneous spacing={8}>
              <button
                cssClasses={isActiveAp((a) =>
                  a ? ["disconnect", "connect-button"] : ["connect-button"],
                )}
                hexpand
                onClicked={async () => {
                  const active = isActiveAp.get();
                  if (active) {
                    await disconnect();
                    return;
                  }

                  if (
                    ap.requiresPassword &&
                    ap.get_connections().length === 0
                  ) {
                    setShowPasswordInput(true);
                    return;
                  }
                  try {
                    await connect(null);
                  } catch (error) {
                    console.log(error);
                  }
                }}
              >
                <label
                  label={isActiveAp((a) => (a ? "Disconnect" : "Connect"))}
                />
              </button>
              <button class="info-button" hexpand onClicked={handleInfoClick}>
                <label label="Info" />
              </button>
            </box>
          </revealer>
          <revealer
            $type="overlay"
            revealChild={showPasswordInput}
            hexpand
            transitionType={Gtk.RevealerTransitionType.SWING_LEFT}
            $={(self) => {
              showPasswordInput.subscribe(() => {
                self.set_can_target(showPasswordInput.get());
              });
              self.set_can_target(false);
            }}
          >
            <entry
              primary_icon_name={"window-close-symbolic"}
              secondary_icon_name={"emblem-ok-symbolic"}
              onIconPress={(self, icon) => {
                if (icon === Gtk.EntryIconPosition.PRIMARY) {
                  setShowPasswordInput(false);
                  return;
                }

                connect(password.get()).catch((e) => console.error(e));

                const stateHandler = wifi.connect("notify::internet", () => {
                  setShowPasswordInput(false);
                  self.text = "";
                  wifi.disconnect(stateHandler);
                });

                const errorHandler = wifi.connect(
                  "state-changed",
                  (_, _old, _new, reason) => {
                    if (reason === NM.DeviceStateReason.NO_SECRETS) {
                      self.add_css_class("error");
                      self.set_placeholder_text("Wrong password! Try again...");
                      self.text = "";
                      deleteConnection(ap.ssid);

                      GLib.timeout_add(GLib.PRIORITY_DEFAULT, 2000, () => {
                        self.remove_css_class("error");
                        self.set_placeholder_text("Enter password...");
                        return GLib.SOURCE_REMOVE;
                      });

                      wifi.disconnect(errorHandler);
                    }
                  },
                );
              }}
              canFocus={true}
              focusable={true}
              text={password}
              onNotifyText={({ text }) => setPassword(text)}
              placeholderText={"Enter password..."}
              visibility={false}
              hexpand
            />
          </revealer>
        </overlay>
      </box>
    </revealer>
  );
}
