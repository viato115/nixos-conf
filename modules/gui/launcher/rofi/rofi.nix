{ config, pkgs, lib, ... }:

let
  mkLiteral = lib.hm.gvariant.mkLiteral or (x: x);  # For compat
in
{
  programs.rofi = {
    enable = true;
    cycle = false;
    package = with pkgs; rofi-wayland;
    extraConfig = {
    modi = "favorites:${config.home.homeDirectory}/.config/rofi/scripts/favorites.sh,drun,filebrowser";
      font = "Mononoki Nerd Font 12 ";
      show-icons = true;
      disable-history = true;
      hover-select = true;
      bw = 0;
      display-drun = "";
      terminal = "footclient";
      drun-display-format = "{name}";
      sidebar-mode = false;
    };
    theme = "${config.home.homeDirectory}/.config/rofi/themes/custom.rasi";
  };

  home.file.".config/rofi/themes/custom.rasi".text = ''
    * {
      bg: #1a1b26;
      fg: #c0caf5;
      button: #7aa2f7;

      background-color: @bg;
      text-color: @fg;
    }
    window {
      transparency: "real";
      width: 40%;
      border: 0px;
      border-radius: 6px;
    }
    prompt { enabled: false; }
    entry {
      placeholder: "Search";
      placeholder-color: @fg;
      expand: true;
      padding: 1.5%;
      border-radius: 8px;
    }
    inputbar {
      children: [ prompt, entry ];
      background-image: url("~/.config/nixos/shared/pics/rofi_bg.png");
      expand: false;
      border-radius: 0px 0 8px 8px;
      padding: 100px 30px 30px 300px;
    }
    listview {
      columns: 1;
      lines: 4;
      cycle: false;
      dynamic: true;
      layout: vertical;
      padding: 30px 200px 30px 30px;
    }
    mainbox { children: [ inputbar, listview ]; }
    element {
      orientation: vertical;
      padding: 1.5% 0% 1.5% 0%;
      border-radius: 8px;
    }
    element-text {
      expand: true;
      vertical-align: 0.5;
      margin: 0.5% 3% 0% 3%;
      background-color: inherit;
      text-color: inherit;
    }
    element-icon {
      background-color: transparent;
      border: 0px;
      padding: 0px;
   }
    element selected {
      background-color: @button;
      border-radius: 8px;
    }
  '';

  home.file.".config/rofi/scripts/favorites.sh" = {
    executable = true;
    text = ''
      #!/bin/sh

      # List of entries
      echo "Steam (Wayland)"
      echo "Firefox"
      echo "System Monitor (btop)"
      echo "Mission Center"

      # If this is an action request (user selected entry)
      if [ "$ROFI_RETV" = "1" ]; then
        case "$1" in
          "Steam (Wayland)") exec steam-wayland ;;
          "Firefox") exec firefox ;;
          "System Monitor (btop)") exec footclient btop ;;
          "Mission Center") exec footclient mission-center ;;
        esac
      fi
    '';
  };

  systemd.user.services.hideSteamGames = {
    Unit = {
      Description = "Hide Steam games from Rofi and app menus";
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "hide-steam-desktop-entries" ''
        set -e

        echo "[hideSteamGames] Patching .desktop entries..."

        # Where Steam usually places game shortcuts
        SEARCH_PATHS=(
          "$HOME/.local/share/applications"
          "$HOME/.steam"
          "$HOME/.steam/root"
          "$HOME/.var/app/com.valvesoftware.Steam"
        )

        for path in "''${SEARCH_PATHS[@]}"; do
          find "$path" -type f -name '*.desktop' 2>/dev/null | grep steam | while read -r file; do
            # Only patch if not already hidden
            if ! grep -q '^NoDisplay=true' "$file"; then
              echo 'NoDisplay=true' >> "$file"
            fi
          done
        done
      '';
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
