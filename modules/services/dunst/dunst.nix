{
  config,
  pkgs,
  lib,
  #inputs,
  ...
}: let
  volume = let
    pamixer = lib.getExe pkgs.pamixer;
    notify-send = pkgs.libnotify + "/bin/notify-send";
  in
    pkgs.writeShellScriptBin "volume" ''
      #!/bin/sh

      ${pamixer} "$@"

      volume="$(${pamixer} --get-volume-human)"

      if [ "$volume" = "muted" ]; then
          ${notify-send} -r 69 \
              -a "Volume" \
              "Muted" \
              -i ${./mute.svg} \
              -t 888 \
              -u low
      else
          ${notify-send} -r 69 \
              -a "Volume" "Currently at $volume" \
              -h int:value:"$volume" \
              -i ${./volume.svg} \
              -t 888 \
              -u low
      fi
    '';
in {

  home.packages = with pkgs; [ volume papirus-icon-theme libnotify ];

  services.dunst = {
    enable = true;
    configFile = "~/.config/dunst/dunstrc";
    settings = {
      global = {
        title = "Dunst";
        class = "Dunst";
        width = 350;
        height = 150;
        origin = "bottom-right";
        offset = "40x40";
        notification_limit = 4;
        shrink = true;
        transparency = 0;
        padding = 10;
        horizontal_padding = 10;
        frame_width = 4;
        frame_color = "#0f0f0f";
        corner_radius = 10;
        separator_color = "#4c4c4c";
        progress_bar_height = 5;
        progress_bar_min_width = 0;
        progress_bar_max_width = 300;
        progress_bar_frame_width = 0;
        font = "Mononoki Nerd Font 11";
       # format = "<span size='110%' font_desc='Mononoki Nerd Font' weight='500' foreground='#c49ec4'>%s</span>\n%b";
        alignment = "center";
        markup = "full";
        always_run_script = true;
        sort = true;
        word_wrap = true;
        ignore_newline = "no";
        show_indicators = true;
        line_height = 0;
        #idle_threshold = 120;
        show_age_threshold = 60;
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 128;
        icon_path = "/usr/share/icons/Papirus-Dark/48x48/actions/:/usr/share/icons/Papirus-Dark/48x48/apps/:/usr/share/icons/Papirus-Dark/48x48/devices/:/usr/share/icons/Papirus-Dark/48x48/emblems/:/usr/share/icons/Papirus-Dark/48x48/emotes/:/usr/share/icons/Papirus-Dark/48x48/mimetypes/:/usr/share/icons/Papirus-Dark/48x48/places/:/usr/share/icons/Papirus-Dark/48x48/status/";
        icon_theme = "Papirus-Dark";
        enable_recursive_icon_lookup = true;
        sticky_history = true;
        browser = "${config.programs.firefox.package}/bin/firefox";
        mouse_left_click = "close_current";
        mouse_middle_click = "context_all";
        mouse_right_click = "close_all";
      };
      urgency_low = {
        timeout = 5;
        background = "#0f0f0f";
        foreground = "#e7e7e7";
        highlight = "#c49ec4";
      };
      urgency_normal = {
        timeout = 10;
        background = "#0f0f0f";
        foreground = "#e7e7e7";
        highlight = "#c49ec4";
      };
      urgency_critikal = {
        timeout = 0;
        background = "#0f0f0f";
        foreground = "#e7e7e7";
        highlight = "#c49ec4";
      };
    };
  };

  home.file."shared/scripts/dunst/launch" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      pkill dunst
      dunst -config ~/.config/dunst/dunstrc &
      dunstify -u critical "Critical message" "critical message"
      dunstify -u normal "Normal message" "normal message"
      dunstify -u low "Low message" "low message"
    '';
  };
}
