{ pkgs, config, ... }:
{

  home.packages = with pkgs; [
  ];

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 30;
        modules-center = [
          "hyprland/workspaces"
            "network"
            "pulseaudio"
            "battery"
            "custom/date"
            "clock"
        ];
        "hyprland/workspaces" = let
hyprctl = config.wayland.windowManager.hyprland.package + "/bin/hyprctl";
        in {
          on-click = "activate";
          on-scroll-up = "${hyprctl} dispatch workspace m+1";
          on-scroll-down = "${hyprctl} dispatch workspace m-1";
          format = "{icon}";
  #        active-only = true;
          all-outputs = true;
          format-icons = {
           "1" = "一";
           "2" = "二";
           "3" = "三";
           "4" = "四";
           "5" = "五";
           "6" = "六";
           "7" = "七";
           "8" = "八";
           "9" = "九";
           "10" = "〇";
          };
        };
        "custom/date" = {
          format = "󰸗 {}";
          interval = 3600;
          exec = "$HOME/bin/waybar-date.sh";
        };
        "clock" = {
          format = "󰅐 {:%H:%M} ";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        battery = {
          states = {
            warning = 20;
            critical = 10;
          };
        	format = "{icon} {capacity}%";
        	format-charging = "󰂄 {capacity}%";
        	format-plugged = "󰂄{capacity}%";
        	format-alt = "{icon} {time}";
        	format-full = "󱈑 {capacity}%";
        	format-icons = ["󱊡" "󱊢" "󱊣"];
        };
        network = {
          format-wifi = "  {essid}";
          format-ethernet = "󰤮 Disconnected";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "󰤮 Disconnected";
          tooltip-format-wifi = "Signal Strenght: {signalStrength}% | Down Speed: {bandwidthDownBits}, Up Speed: {bandwidthUpBits}";
        };
        pulseaudio = {
          on-click = "pactl set-sink-mute 45 toogle";
          format = "{icon} {volume}%";
          format-muted = "󰖁 Muted";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
        };
      };
    };
      style = ''
* {
    border: none;
    border-radius: 0;
    font-family: mononoki Nerd Font;
    font-size: 14px;
    min-height: 0;
}

window#waybar {
    background: transparent;
    color: white;
}

tooltip {
	background: #0f0f0f;
	border-radius: 15px;
	border-width: 2px;
	border-style: solid;
	border-color: #262626;
	}

#workspaces button {
    padding: 5px 10px;
    color: #f0f0f0;
}

#workspaces button.focused {
    color: #0f0f0f;
    background-color: #c49ec4;
    border-radius: 15px;
}

#workspaces button.urgent {
    color: #0f0f0f;
    background-color: #9ec3c4;
    border-radius: 15px;
}

#workspaces button:hover {
	background-color: #c49ec4;
	color: #0f0f0f;
	border-radius: 15px;
}

#custom-date, #clock, #battery, #pulseaudio, #network, #workspaces {
	background-color: #0f0f0f;
	padding: 5px 10px;
	margin: 5px 0px;
}

#workspaces {
	background-color: #262626;
	border-radius: 15px 0px 0px 15px;
}

#custom-date {
	color: #9ec3c4;
}

#clock {
    color: #a39ec4;
    border-radius: 0px 15px 15px 0px;
    margin-right: 10px;
}

#battery {
    color: #9ec49f;
}

#battery.charging {
    color: #9ec49f;
}

#battery.warning:not(.charging) {
    background-color: #c49ea0;
    color: #0f0f0f;
}

#network {
	color: #c4c19e;
	border-radius: 0px 0px 0px 0px;
}

#pulseaudio {
	color: #a5b4cb;
}
      '';
    };
}
