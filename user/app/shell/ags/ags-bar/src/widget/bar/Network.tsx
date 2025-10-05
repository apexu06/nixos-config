import { Gtk } from "ags/gtk4";
import AstalNetwork from "gi://AstalNetwork?version=0.1";
import { createBinding, For, With } from "gnim";

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
            const bySSID = new Map();

            for (const a of aps) {
              if (!a.ssid) continue;

              const existing = bySSID.get(a.ssid);

              // Prefer the connected AP if this is it
              if (connected && a.bssid === connected.bssid) {
                bySSID.set(a.ssid, a);
                continue;
              }

              // Otherwise keep the strongest one
              if (!existing || a.strength > existing.strength) {
                bySSID.set(a.ssid, a);
              }
            }

            return Array.from(bySSID.values());
          });

          accessPoints.subscribe(() => {
            accessPoints.get().forEach((a) => {
              console.log(
                `${a.ssid} | ${a.flags} | ${a.mode} | ${a.bandwidth} | ${(a.frequency / 1000).toFixed(2)} | ${a === wifi.activeAccessPoint}`,
              );
            });
          });

          return (
            <box>
              <button
                onClicked={() => {
                  if (!wifi.scanning) wifi.scan();
                  popover.popup();
                }}
              >
                <image iconName={createBinding(wifi, "iconName")} />
              </button>

              <popover
                width_request={400}
                height_request={100}
                $={(self) => {
                  popover = self;
                  self.set_has_arrow(false);
                }}
              >
                <box orientation={Gtk.Orientation.VERTICAL} spacing={8}>
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
                  <scrolledwindow
                    class="base-container"
                    maxContentHeight={700}
                    height_request={600}
                  >
                    <box orientation={Gtk.Orientation.VERTICAL} spacing={8}>
                      <label
                        halign={Gtk.Align.START}
                        label={createBinding(
                          wifi,
                          "scanning",
                        )((s) => (s ? "Scanning..." : "Available Networks"))}
                        css={"font-size: 18px; font-weight: bold;"}
                      />
                      <Gtk.Separator />
                      <box orientation={Gtk.Orientation.VERTICAL} spacing={4}>
                        <For each={accessPoints}>
                          {(ap: AstalNetwork.AccessPoint) => (
                            <button>
                              <box spacing={4}>
                                <image
                                  iconName={createBinding(ap, "iconName")}
                                />
                                <label label={createBinding(ap, "ssid")} />
                                <image
                                  iconName="object-select-symbolic"
                                  visible={createBinding(
                                    wifi,
                                    "activeAccessPoint",
                                  )((active) => active === ap)}
                                />
                              </box>
                            </button>
                          )}
                        </For>
                      </box>
                    </box>
                  </scrolledwindow>
                </box>
              </popover>
            </box>
          );
        }}
      </With>
    </box>
  );
}
