{ config, pkgs, lib, hostname, ... }:

let
  hostMonitors = {
    nixpad = [
      "monitor=eDP-1,preferred,auto,1"
      "monitor=eDP-1,transform,0"
#      "monitor=DP-3,1920x1080@60,1920x0,1"
#      "monitor=DP-3,transform,1"
    ];
    nixtop = [
      "monitor=DP-3,1920x1080@60,0x0,1"
      "monitor=HDMI-A-1,1920x1080@60,1920x0,1"
    ];
  };
  monitorsConf = builtins.concatStringsSep "\n" (hostMonitors.${hostname} or []);

  hostWallpapers = {
      nixpad = [
        # "monitor-name,path"
        "eDP-1,~/.config/nixos/shared/pics/a_drawing_of_a_wolf_and_a_lion.png"
        "DP-3,~/.config/nixos/shared/pics/a_drawing_of_a_wolf_and_a_lion.png"
      ];
      nixtop = [
        "DP-3,~/.config/nixos/shared/pics/flowers.png"
        "HDMI-A-1,~/.config/nixos/shared/pics/flowers.png"
      ];
    };
    wallpapers = hostWallpapers.${hostname} or [];

  sharedConfig = lib.fileContents ./hyprland.conf;

in
{
  home = {
    packages = with pkgs; [ libnotify grim slurp pamixer vimix-cursors ];
    pointerCursor = {
      gtk.enable = true;
          package = pkgs.vimix-cursors;
          name = "Vimix-cursors";
          size = 16;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    extraConfig = ''
      ${monitorsConf}
      ${sharedConfig}
    '';
  };
 
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/.config/nixos/shared/pics/wallpaper.png"
        "~/.config/nixos/shared/pics/neo_tokyo.png"
        "~/.config/nixos/shared/pics/floral.png"
        "~/.config/nixos/shared/pics/a_drawing_of_a_wolf_and_a_lion.png"
        "~/.config/nixos/shared/pics/flowers.png"
      ];
      wallpaper = wallpapers;
      splash = false;
    };
  }; 


  home.file.".local/bin/wrappedhl" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      cd ~

      export HYPRLAND_LOG_WLR=1
      export WLR_RENDERER_ALLOW_SOFTWARE=1

      export XCURSOR_SIZE=24

      export XDG_CURRENT_DESKTOP=Hyprland
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=Hyprland

      export MOZ_ENABLE_WAYLAND=1
      export MOZ_USE_XINPUT2=1
      export QT_AUTO_SCREEN_SCALE_FACTOR=1
      export QT_QPA_PLATFORM=wayland
      export QT_QPA_PLATFORMTHEME="qt5ct"
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

      exec Hyprland
    '';
  };
}
