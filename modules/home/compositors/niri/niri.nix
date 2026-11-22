{ pkgs, lib, hostname, ... }:
let
  hostInput = {
    nixpad = ./nixpad-input.kdl;
    nixtop = ./nixtop-input.kdl;
  }.${hostname} or (throw "No Niri input and output configuration for ${hostname}");

  rotationBinding = lib.optionalString (hostname == "nixpad") ''
    Mod+Alt+R repeat=false hotkey-overlay-title="Toggle screen rotation lock" {
      spawn "toggle-niri-rotation"
    }
  '';

  commonConfig = lib.replaceStrings
    [ "// HOST_ROTATION_BINDING" ]
    [ rotationBinding ]
    (builtins.readFile ./config.kdl);

  niriConfig = pkgs.writeText "niri-${hostname}-source.kdl" ''
    ${builtins.readFile hostInput}
    ${commonConfig}
    include "${./smoke.kdl}"
  '';
in
{
  home.packages = lib.optionals (hostname == "nixpad") [
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
      cp ${niriConfig} "$out"
      niri validate --config "$out"
    '';
}
