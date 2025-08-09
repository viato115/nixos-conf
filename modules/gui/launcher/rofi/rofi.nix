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
      modi = "drun,filebrowser";
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
}
