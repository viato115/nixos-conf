{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "toggle-niri-rotation";

      runtimeInputs = [
        pkgs.iio-niri
        pkgs.jq
        pkgs.libnotify
      ];

      text = ''
        response="$(iio-niri msg toggle-lock-rotation 2>/dev/null)" || response=""

        previous_lock="$(
          printf '%s' "$response" |
            jq -r '
              if .status == "ok" and (.response | type) == "boolean"
              then .response
              else "error"
              end
            ' 2>/dev/null || true
        )"

        case "$previous_lock" in
          true)
            notify-send -a "Screen rotation" \
              "Auto-rotation enabled" \
              "The screen will follow the device orientation."
            ;;
          false)
            notify-send -a "Screen rotation" \
              "Auto-rotation locked" \
              "The screen will stay in its current orientation."
            ;;
          *)
            notify-send -a "Screen rotation" -u critical \
              "Could not toggle rotation" \
              "Check whether the iio-niri service is running."
            exit 1
            ;;
        esac
      '';
    })
  ];


  xdg.configFile."niri/config.kdl".source =
    pkgs.runCommand "niri-config.kdl" { nativeBuildInputs = [ pkgs.niri ]; } ''
      cat ${./config.kdl} > "$out"
      printf '\ninclude "%s"\n' "${./smoke.kdl}" >> "$out"
      niri validate --config "$out"
    '';
}
