{
  pkgs,
  inputs,
  lib,
  ...
}: let
  gsr-command = ''
    gpu-screen-recorder \
      -w "DP-3" \
      -f 60 \
      -c mp4 \
      -r 60 \
      -a "default_output|default_input" \
      -o "$HOME/Videos/Replays" &
  '';
in {
  home.packages = with pkgs; [
    gpu-screen-recorder
  ];

  home.file.".local/bin/gsr-replay-start" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      pkill -f "gpu-screen-recorder" 2>/dev/null

      ${gsr-command}

      noctalia-shell ipc call toast send '{"title": "Replay Started", "body": "Replay buffer started (60s @ 60fps)", "icon": "media-record"}'
    '';
  };

  home.file.".local/bin/gsr-replay-save" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      if ! pgrep -f "gpu-screen-recorder" > /dev/null; then
        noctalia-shell ipc call toast send '{"title": "Replay Error", "body": "Replay buffer not running", "type": "error"}'
        exit 1
      fi

      kill -SIGUSR1 $(pgrep -f "gpu-screen-recorder")
      noctalia-shell ipc call toast send '{"title": "Replay Saved", "body": "Clip saved to ~/Videos/Replays", "icon": "document-save"}'
    '';
  };

  home.file.".local/bin/gsr-replay-stop" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      if ! pgrep -f "gpu-screen-recorder" > /dev/null; then
        noctalia-shell ipc call toast send '{"title": "Replay Error", "body": "Nothing to stop", "type": "error"}'
        exit 1
      fi

      kill -SIGINT $(pgrep -f "gpu-screen-recorder")
      noctalia-shell ipc call toast send '{"title": "Replay Stopped", "body": "Buffer has been cleared", "icon": "process-stop"}'
    '';
  };

  home.file.".local/bin/gsr-replay-toggle" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      if pgrep -f "gpu-screen-recorder" > /dev/null; then
        kill -SIGINT $(pgrep -f "gpu-screen-recorder")
        noctalia-shell ipc call toast send '{"title": "Replay Stopped", "body": "Buffer has been cleared", "icon": "process-stop"}'
      else

        ${gsr-command}
        noctalia-shell ipc call toast send '{"title": "Replay Started", "body": "Replay buffer started (60s @ 60fps)", "icon": "media-record"}'
      fi
    '';
  };

  programs.niri.settings = {
    binds = {
      "Mod+Ctrl+S".action =
        lib.mkForce {spawn = "gsr-replay-save";};

      "Mod+Ctrl+R".action =
        lib.mkForce {spawn = "gsr-replay-toggle";};
    };
  };
}
