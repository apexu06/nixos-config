import { Gtk } from "ags/gtk4";
import { subprocess } from "ags/process";
import Wp from "gi://AstalWp?version=0.1";
import { createBinding } from "ags";

const VOLUME_SCROLL_STEP = 0.01;

export default function Volume() {
  const wp = Wp.get_default();

  let popover: Gtk.Popover | undefined = undefined;

  function adjustVolume(direction: "up" | "down") {
    const output = wp.defaultSpeaker;
    if (!output) return;

    const currentVolume = output.volume;
    const newVolume =
      direction === "up"
        ? Math.min(1.5, currentVolume + VOLUME_SCROLL_STEP)
        : Math.max(0.0, currentVolume - VOLUME_SCROLL_STEP);

    output.volume = newVolume;
  }

  function handleSettingsButtonClicked() {
    if (popover) popover.popdown();
    subprocess(
      "pavucontrol",
      (out) => console.log(out), // optional
      (err) => console.error(err), // optional
    );
  }

  return (
    <box hexpand={false} halign={Gtk.Align.CENTER}>
      <button
        $={(self) => {
          const controller = new Gtk.EventControllerScroll();
          controller.set_flags(Gtk.EventControllerScrollFlags.VERTICAL);

          controller.connect("scroll", (_c, _dx, dy) => {
            if (dy < 0) {
              adjustVolume("up");
            } else {
              adjustVolume("down");
            }

            return true;
          });
          self.add_controller(controller);

          self.connect("clicked", () => {
            if (popover) {
              popover.set_pointing_to(self.get_allocation());
              popover.popup();
            }
          });
        }}
      >
        <image
          iconName={createBinding(wp.defaultSpeaker, "volumeIcon")}
          iconSize={Gtk.IconSize.NORMAL}
        />
      </button>

      <popover
        $={(p) => {
          popover = p;
          p.set_has_arrow(false);
        }}
        widthRequest={450}
      >
        <box
          orientation={Gtk.Orientation.VERTICAL}
          spacing={8}
          class="volume-popover"
        >
          <centerbox
            orientation={Gtk.Orientation.HORIZONTAL}
            class="base-container"
          >
            <label
              label={"Audio"}
              $type="start"
              css={"font-size: 20px; font-weight: bold;"}
            />
            <button
              class="volume-settings-button"
              $type="end"
              onClicked={handleSettingsButtonClicked}
            >
              <image
                iconName={"preferences-desktop-sound"}
                iconSize={Gtk.IconSize.NORMAL}
              />
            </button>
          </centerbox>

          <box>
            <box
              orientation={Gtk.Orientation.VERTICAL}
              spacing={8}
              class="base-container"
            >
              <box orientation={Gtk.Orientation.HORIZONTAL} spacing={8}>
                <image
                  iconName="audio-headphones"
                  iconSize={Gtk.IconSize.NORMAL}
                />
                <Gtk.DropDown
                  hexpand={true}
                  class="dropdown"
                  overflow={Gtk.Overflow.HIDDEN}
                  $={(self) => {
                    const speakers = createBinding(wp.audio, "speakers");

                    function updateDevices() {
                      const s = speakers.get();
                      const store = new Gtk.StringList({
                        strings: s.map((d) => d.description),
                      });
                      self.set_model(store);

                      self.set_selected(s.findIndex((s) => s.isDefault));
                    }

                    speakers.subscribe(updateDevices);

                    self.connect("notify::selected-item", () => {
                      const idx = self.get_selected();
                      const output = speakers.get()[idx];

                      if (output) {
                        output.set_is_default(true);
                      }
                    });
                  }}
                />
              </box>

              <box orientation={Gtk.Orientation.HORIZONTAL} spacing={8}>
                <image
                  iconName="audio-input-microphone"
                  iconSize={Gtk.IconSize.NORMAL}
                />
                <Gtk.DropDown
                  hexpand={true}
                  class="dropdown"
                  $={(self) => {
                    const microphones = createBinding(wp.audio, "microphones");

                    function updateDevices() {
                      const m = microphones.get();
                      const store = new Gtk.StringList({
                        strings: m.map((d) => d.description),
                      });
                      self.set_model(store);

                      const idx = m.findIndex((m) => m.isDefault);
                      if (idx > 0)
                        self.set_selected(m.findIndex((m) => m.isDefault));
                    }
                    microphones.subscribe(updateDevices);

                    self.connect("notify::selected-item", () => {
                      const idx = self.get_selected();
                      const input = microphones.get().find((m) => m.id === idx);

                      if (input) {
                        input.set_is_default(true);
                      }
                    });
                  }}
                />
              </box>
            </box>
          </box>

          <box
            orientation={Gtk.Orientation.VERTICAL}
            spacing={8}
            class="base-container"
          >
            <box orientation={Gtk.Orientation.HORIZONTAL}>
              <button
                onClicked={() =>
                  wp.defaultSpeaker.set_mute(!wp.defaultSpeaker.get_mute())
                }
              >
                <image
                  iconName={createBinding(
                    wp.defaultSpeaker,
                    "mute",
                  )((m) => (m ? "audio-volume-muted" : "audio-headphones"))}
                  icon_size={Gtk.IconSize.NORMAL}
                />
              </button>
              <Gtk.Scale
                $={(self) => {
                  self.set_range(0, 1.5);

                  const volume = createBinding(wp.defaultSpeaker, "volume");
                  volume.subscribe(() => self.set_value(volume.get()));
                }}
                class="scale-test"
                hexpand
                onChangeValue={(self) => {
                  wp.defaultSpeaker.set_volume(self.get_value());
                }}
              />
              {/*
              <slider
                min={0}
                max={1.5}
                hexpand
                value={createBinding(wp.defaultSpeaker, "volume")}
                onChangeValue={({ value }) =>
                  wp.defaultSpeaker.set_volume(value)
                }
              />
*/}

              <button onClicked={() => wp.defaultSpeaker.set_volume(1)}>
                <label
                  label={createBinding(
                    wp.defaultSpeaker,
                    "volume",
                  )((v) => Math.round(v * 100).toString() + "%")}
                  widthChars={5}
                />
              </button>
            </box>

            <box orientation={Gtk.Orientation.HORIZONTAL}>
              <button
                onClicked={() =>
                  wp.defaultMicrophone.set_mute(
                    !wp.defaultMicrophone.get_mute(),
                  )
                }
              >
                <image
                  iconName={createBinding(
                    wp.defaultMicrophone,
                    "mute",
                  )((m) =>
                    m ? "audio-volume-muted" : "audio-input-microphone",
                  )}
                  icon_size={Gtk.IconSize.NORMAL}
                />
              </button>
              <slider
                min={0}
                max={1.5}
                hexpand={true}
                value={createBinding(wp.defaultMicrophone, "volume")}
                onChangeValue={({ value }) =>
                  wp.defaultMicrophone.set_volume(value)
                }
              />

              <button onClicked={() => wp.defaultMicrophone.set_volume(1)}>
                <label
                  label={createBinding(
                    wp.defaultMicrophone,
                    "volume",
                  )((v) => Math.round(v * 100).toString() + "%")}
                  widthChars={5}
                />
              </button>
            </box>
          </box>
        </box>
      </popover>
    </box>
  );
}
