import { Gtk } from "ags/gtk4";
import AstalBattery from "gi://AstalBattery?version=0.1";
import AstalPowerProfiles from "gi://AstalPowerProfiles?version=0.1";
import { createBinding, createComputed, With } from "gnim";

export default function Battery() {
  const battery = AstalBattery.get_default();

  const percentage = createBinding(battery, "percentage");
  const charging = createBinding(battery, "charging");

  const batteryText = createComputed((get) => {
    function formatTimeRemaining(time: number) {
      return `${Math.round(time / 3600)}h ${Math.round((time % 3600) / 60)}min`;
    }

    let c = get(charging);
    if (c) {
      return (
        "Time until full: " +
        get(createBinding(battery, "timeToFull")((t) => formatTimeRemaining(t)))
      );
    }

    return (
      "Time until empty: " +
      get(createBinding(battery, "timeToEmpty")((t) => formatTimeRemaining(t)))
    );
  });

  if (!battery.isPresent) return <box></box>;

  return (
    <menubutton>
      <image iconName={createBinding(battery, "iconName")} />
      <popover $={(self) => self.set_has_arrow(false)}>
        <box orientation={Gtk.Orientation.VERTICAL} spacing={8}>
          <centerbox
            orientation={Gtk.Orientation.HORIZONTAL}
            class="base-container"
          >
            <label
              label={"Battery"}
              $type="start"
              css={"font-size: 20px; font-weight: bold;"}
            />
            <label $type="end" widthChars={20} label={batteryText} />
          </centerbox>

          <PowerProfiles />

          <overlay>
            <levelbar
              minValue={0}
              maxValue={1}
              value={percentage}
              height_request={20}
              $={(self) => {
                self.add_offset_value("low", 0.2);
                self.add_offset_value("medium", 0.4);
                self.add_offset_value("good", 0.6);
                self.add_offset_value("full", 0.8);
              }}
            />
            <label
              label={percentage((p) => Math.round(p * 100).toString() + "%")}
              halign={Gtk.Align.CENTER}
              valign={Gtk.Align.CENTER}
              $type="overlay"
            />
          </overlay>
        </box>
      </popover>
    </menubutton>
  );
}

function PowerProfiles() {
  const powerprofiles = AstalPowerProfiles.get_default();
  const active = createBinding(powerprofiles, "activeProfile");

  return (
    <box>
      <With value={active}>
        {(active) => (
          <box spacing={8} height_request={50}>
            <button
              vexpand
              hexpand
              onClicked={() => powerprofiles.set_active_profile("performance")}
              class={`powerprofile performance ${active === "performance" ? "active" : ""}`}
            >
              <image
                iconName="system-run-symbolic"
                iconSize={Gtk.IconSize.LARGE}
              />
            </button>
            <button
              vexpand
              hexpand
              onClicked={() => powerprofiles.set_active_profile("balanced")}
              class={`powerprofile balanced ${active === "balanced" ? "active" : ""}`}
            >
              <image iconName="cpu-symbolic" iconSize={Gtk.IconSize.LARGE} />
            </button>
            <button
              vexpand
              hexpand
              onClicked={() => powerprofiles.set_active_profile("power-saver")}
              class={`powerprofile powersaver ${active === "power-saver" ? "active" : ""}`}
            >
              <image
                iconName="battery-symbolic"
                iconSize={Gtk.IconSize.LARGE}
              />
            </button>
          </box>
        )}
      </With>
    </box>
  );
}
