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
      "monitor=DP-3,1920x1080@60,0x0,1,vrr,1"
      "monitor=HDMI-A-1,1920x1080@60,1920x0,1,vrr,1"
    ];
  };
  monitorsConf = builtins.concatStringsSep "\n" (hostMonitors.${hostname} or []);

  wallpaperImage = ../../../../../shared/pics/flowers.png;

  sharedConfig = lib.fileContents ./hyprland.conf;

in
{
  home = {
    packages = with pkgs; [ libnotify grim slurp pamixer vimix-cursors ];
    pointerCursor = {
        enable = true;
        gtk.enable = true;
        package = pkgs.vimix-cursors;
        name = "Vimix-cursors";
        size = 16;
    };
 };

  wayland.windowManager.hyprland = {
    # The existing configuration in hyprland.conf uses Hyprlang syntax.
    # Lua mode would write it verbatim to hyprland.lua and make startup fail.
    configType = "hyprlang";
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
      wallpaper = [
        {
          monitor = "*";
          path = "${wallpaperImage}";
          fit_mode = "cover";
        }
      ];
      splash = false;
    };
  }; 

  programs.hyprshot = {
    enable = true;
    saveLocation = "$HOME/Pictures/Screenshots";
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
      export QT_QPA_PLATFORMTHEME="qt6ct"
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

      exec Hyprland
    '';
  };
}
