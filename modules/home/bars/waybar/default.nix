{ lib, pkgs, hostname, ... }:
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "toggle-waybar";
      runtimeInputs = [ pkgs.coreutils pkgs.procps pkgs.libnotify ];
      text = ''
        # Nix may wrap the executable, changing its process name.
        if ! pkill -u "$(id -u)" -USR1 -x 'waybar|[.]waybar-wrapped'; then
          notify-send -a "Waybar" "Status bar is not running" \
            "Log out and back in to start it."
          exit 1
        fi
      '';
    })
  ];

  programs.waybar = {
    enable = true;
    # Niri starts Waybar, so other graphical sessions do not start it too.
    systemd.enable = false;
    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 34;
      margin-top = 8;
      margin-left = 10;
      margin-right = 10;
      exclusive = false;
      start_hidden = true;
      on-sigusr1 = "toggle";

      modules-left = [ "niri/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" ]
        ++ lib.optionals (hostname == "nixpad") [ "battery" ]
        ++ [ "tray" ];

      "niri/workspaces" = {
        format = "{value}";
        all-outputs = false;
      };

      clock = {
        format = "{:%a  %d %b    %H:%M}";
        tooltip-format = "{:%A, %d %B %Y}";
      };

      pulseaudio = {
        format = "VOL  {volume}%";
        format-muted = "MUTED";
        on-click = "pavucontrol";
        tooltip = true;
      };

      network = {
        format-wifi = "WIFI  {signalStrength}%";
        format-ethernet = "LAN";
        format-disconnected = "OFFLINE";
        tooltip-format-wifi = "{essid} ({signalStrength}%)";
        tooltip-format-ethernet = "{ifname}: {ipaddr}";
      };

      battery = {
        format = "BAT  {capacity}%";
        format-charging = "CHG  {capacity}%";
        format-plugged = "AC  {capacity}%";
        tooltip = true;
        states = {
          warning = 20;
          critical = 10;
        };
      };

      tray = {
        icon-size = 16;
        spacing = 8;
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "Mononoki Nerd Font", monospace;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(26, 27, 38, 0.96);
        color: #c0caf5;
        border: 1px solid #414868;
        border-radius: 10px;
      }

      #workspaces {
        padding: 3px 5px;
      }

      #workspaces button {
        color: #787c99;
        background: transparent;
        border-radius: 7px;
        padding: 0 10px;
      }

      #workspaces button:hover {
        color: #c0caf5;
        background: #292e42;
      }

      #workspaces button.active,
      #workspaces button.focused {
        color: #1a1b26;
        background: #7aa2f7;
      }

      #clock {
        color: #c0caf5;
        font-weight: bold;
        padding: 0 12px;
      }

      #pulseaudio, #network, #battery, #tray {
        padding: 0 10px;
      }

      #pulseaudio.muted, #network.disconnected {
        color: #f7768e;
      }

      #battery.warning {
        color: #e0af68;
      }

      #battery.critical {
        color: #f7768e;
      }

      tooltip {
        background-color: #1a1b26;
        color: #c0caf5;
        border: 1px solid #414868;
        border-radius: 8px;
      }
    '';
  };
}
