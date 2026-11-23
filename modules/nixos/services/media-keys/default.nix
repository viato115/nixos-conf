{ config, lib, pkgs, username, ... }:
let
  user = lib.escapeShellArg username;
  home = lib.escapeShellArg config.users.users.${username}.home;

  audioAction = pkgs.writeShellScript "media-audio-action" ''
    set -eu
    export LC_ALL=C

    # Serialize rapid keypresses so notifications follow the resulting state.
    exec 9>"$XDG_RUNTIME_DIR/media-keys-audio.lock"
    "${pkgs.util-linux}/bin/flock" -x 9

    wpctl="${pkgs.wireplumber}/bin/wpctl"
    notify="${pkgs.libnotify}/bin/notify-send"
    target="@DEFAULT_AUDIO_SINK@"

    case "$1" in
      volume-up) "$wpctl" set-volume "$target" 6%+ -l 1.0 ;;
      volume-down) "$wpctl" set-volume "$target" 6%- ;;
      volume-mute) "$wpctl" set-mute "$target" toggle ;;
      microphone-mute)
        target="@DEFAULT_AUDIO_SOURCE@"
        "$wpctl" set-mute "$target" toggle
        ;;
      *) exit 2 ;;
    esac

    status="$("$wpctl" get-volume "$target")"
    if [ "$1" = microphone-mute ]; then
      case "$status" in
        *"[MUTED]"*) title="Microphone muted"; icon="microphone-sensitivity-muted" ;;
        *) title="Microphone on"; icon="microphone-sensitivity-high" ;;
      esac
      "$notify" -a "Media keys" -u low -t 1500 -i "$icon" \
        -h string:x-dunst-stack-tag:media-microphone "$title" || true
    else
      percent="$(printf '%s\n' "$status" | "${pkgs.gawk}/bin/awk" '
        /^Volume:/ { printf "%d", $2 * 100 + 0.5; found = 1 }
        END { if (!found) exit 1 }
      ')"
      bar="$percent"
      if [ "$bar" -gt 100 ]; then bar=100; fi
      case "$status" in
        *"[MUTED]"*) title="Volume muted"; icon="audio-volume-muted"; bar=0 ;;
        *)
          title="Volume: $percent%"
          if [ "$percent" -eq 0 ]; then icon="audio-volume-muted"
          elif [ "$percent" -lt 34 ]; then icon="audio-volume-low"
          elif [ "$percent" -lt 67 ]; then icon="audio-volume-medium"
          else icon="audio-volume-high"
          fi
          ;;
      esac
      "$notify" -a "Media keys" -u low -t 1500 -i "$icon" \
        -h string:x-dunst-stack-tag:media-volume -h "int:value:$bar" "$title" || true
    fi
  '';

  mediaKeyAction = pkgs.writeShellScript "media-key-action" ''
    set -eu

    # actkbd runs as root; PipeWire and MPRIS belong to Nico's user session.
    in_user_session() {
      uid="$("${pkgs.coreutils}/bin/id" -u ${user})"
      runtime_dir="/run/user/$uid"
      exec "${pkgs.util-linux}/bin/runuser" -u ${user} -- \
        "${pkgs.coreutils}/bin/env" -i \
        HOME=${home} USER=${user} LOGNAME=${user} \
        XDG_RUNTIME_DIR="$runtime_dir" \
        DBUS_SESSION_BUS_ADDRESS="unix:path=$runtime_dir/bus" \
        "$@"
    }

    case "$1" in
      brightness-up) exec "${pkgs.brightnessctl}/bin/brightnessctl" --class=backlight set +5% ;;
      brightness-down) exec "${pkgs.brightnessctl}/bin/brightnessctl" --class=backlight set 5%- ;;
      volume-up|volume-down|volume-mute|microphone-mute) in_user_session "${audioAction}" "$1" ;;
      play-pause) in_user_session "${pkgs.playerctl}/bin/playerctl" play-pause ;;
      previous) in_user_session "${pkgs.playerctl}/bin/playerctl" previous ;;
      next) in_user_session "${pkgs.playerctl}/bin/playerctl" next ;;
      stop) in_user_session "${pkgs.playerctl}/bin/playerctl" stop ;;
      *) exit 2 ;;
    esac
  '';

  binding = code: action: repeat: {
    keys = [ code ];
    events = if repeat then [ "key" "rep" ] else [ "key" ];
    command = "${mediaKeyAction} ${action}";
  };
in
{
  services.actkbd = {
    enable = true;
    bindings = [
      (binding 224 "brightness-down" true)
      (binding 225 "brightness-up" true)
      (binding 114 "volume-down" true)
      (binding 115 "volume-up" true)
      (binding 113 "volume-mute" false)
      (binding 248 "microphone-mute" false)
      (binding 164 "play-pause" false)
      (binding 165 "previous" false)
      (binding 163 "next" false)
      (binding 166 "stop" false)
    ];
  };
}
