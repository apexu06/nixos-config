import { Gdk, Gtk } from "ags/gtk4";
import { subprocess } from "ags/process";
import Wp from "gi://AstalWp?version=0.1";
import { createBinding, createState, With } from "gnim";

const VOLUME_SCROLL_STEP = 0.01;

export default function Volume() {
  const wp = Wp.get_default();

  type VolumeState = {
    allDevices: Wp.Device[];
    currentOutput: Wp.Endpoint | undefined;
    currentInput: Wp.Endpoint | undefined;
    outputVolume: number;
    inputVolume: number;
    outputIsMuted: boolean;
    inputIsMuted: boolean;
  };

  const [state, setState] = createState<VolumeState>({
    allDevices: [],
    currentOutput: undefined,
    currentInput: undefined,
    outputVolume: 0,
    inputVolume: 0,
    outputIsMuted: false,
    inputIsMuted: false,
  });

  let popover: Gtk.Popover | undefined = undefined;

  wp.connect("ready", () => {
    const output = wp.audio.defaultSpeaker;
    const input = wp.audio.defaultMicrophone;

    if (output) {
      setState({
        allDevices: wp.audio.devices,
        currentOutput: output,
        currentInput: input,
        outputVolume: Math.round(output.volume * 100),
        inputVolume: Math.round(input.volume * 100),
        outputIsMuted: output.mute,
        inputIsMuted: input.mute,
      });

      output.connect("notify::volume", () => {
        setState({
          ...state.get(),
          outputVolume: Math.round(output.volume * 100),
        });
      });

      output.connect("notify::mute", () => {
        setState({
          ...state.get(),
          outputIsMuted: output.mute,
        });
      });

      input.connect("notify::volume", () => {
        setState({
          ...state.get(),
          inputVolume: Math.round(input.volume * 100),
        });
      });

      input.connect("notify::mute", () => {
        setState({
          ...state.get(),
          inputIsMuted: input.mute,
        });
      });

      wp.connect("device-added", () => {
        setState({
          ...state.get(),
          allDevices: wp.audio.devices,
        });
      });

      wp.connect("device-removed", () => {
        setState({
          ...state.get(),
          allDevices: wp.audio.devices,
        });
      });
    }
  });

  function getVolumeIcon(volume: number, muted: boolean) {
    if (muted || volume === 0) return "audio-volume-muted";
    if (volume < 30) return "audio-volume-low";
    if (volume < 70) return "audio-volume-medium";
    return "audio-volume-high";
  }

  function adjustVolume(direction: "up" | "down") {
    const output = state.get().currentOutput;
    if (!output) return;

    const currentVolume = output.volume;
    const newVolume =
      direction === "up"
        ? Math.min(1.0, currentVolume + VOLUME_SCROLL_STEP)
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
    <box hexpand={false}>
      <With value={state}>
        {(s) => (
          <button
            class="module"
            css={"min-width: 72px;"}
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
            <box halign={Gtk.Align.CENTER}>
              <image
                iconName={getVolumeIcon(s.outputVolume, s.outputIsMuted)}
                iconSize={Gtk.IconSize.NORMAL}
                css="margin-right: 8px;"
              />
              <label label={s.outputVolume.toString() + "%"} />
            </box>
          </button>
        )}
      </With>

      <popover
        $={(p) => {
          popover = p;
        }}
        widthRequest={450}
      >
        <box
          orientation={Gtk.Orientation.VERTICAL}
          spacing={8}
          class="volume-popover"
        >
          <centerbox orientation={Gtk.Orientation.HORIZONTAL}>
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
            <With value={state}>
              {(s) => (
                <box orientation={Gtk.Orientation.VERTICAL} spacing={8}>
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
                        const outputs = s.allDevices.filter(
                          (s) => s.outputRoutes.length !== 0,
                        );

                        const store = new Gtk.StringList({
                          strings: outputs.map((d) => d.description),
                        });
                        self.set_model(store);

                        if (s.currentOutput)
                          self.set_selected(
                            outputs.findIndex(
                              (d) => d.id === s.currentOutput?.device_id,
                            ),
                          );

                        self.connect("notify::selected", () => {
                          const idx = self.get_selected();
                          const output = outputs[idx];

                          const speaker = wp.audio.speakers.find(
                            (s) => s.device_id === output.id,
                          );

                          if (speaker) {
                            speaker.set_is_default(true);
                            setState({
                              ...state.get(),
                              currentOutput: speaker,
                            });
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
                        const inputs = s.allDevices.filter(
                          (s) => s.inputRoutes.length !== 0,
                        );

                        const store = new Gtk.StringList({
                          strings: inputs.map((d) => d.description),
                        });
                        self.set_model(store);

                        if (s.currentOutput)
                          self.set_selected(
                            inputs.findIndex(
                              (d) => d.id === s.currentInput?.device_id,
                            ),
                          );

                        self.connect("notify::selected", () => {
                          const idx = self.get_selected();
                          const input = inputs[idx];

                          const microphone = wp.audio.microphones.find(
                            (s) => s.device_id === input.id,
                          );

                          if (microphone) {
                            microphone.set_is_default(true);
                            setState({
                              ...state.get(),
                              currentInput: microphone,
                            });
                          }
                        });
                      }}
                    />
                  </box>
                </box>
              )}
            </With>
          </box>
          <Gtk.Separator />

          <box orientation={Gtk.Orientation.HORIZONTAL}>
            <image iconName="audio-headphones" iconSize={Gtk.IconSize.NORMAL} />
            <slider
              min={0}
              max={1}
              hexpand={true}
              value={createBinding(wp.defaultSpeaker, "volume")}
              onChangeValue={({ value }) => wp.defaultSpeaker.set_volume(value)}
            />
          </box>

          <box orientation={Gtk.Orientation.HORIZONTAL}>
            <image
              iconName="audio-input-microphone"
              iconSize={Gtk.IconSize.NORMAL}
            />
            <slider
              min={0}
              max={1.5}
              hexpand={true}
              value={createBinding(wp.defaultMicrophone, "volume")}
              onChangeValue={({ value }) =>
                wp.defaultMicrophone.set_volume(value)
              }
            />
          </box>
        </box>
      </popover>
    </box>
  );
}
