{ config, pkgs, lib, hostname, ... }:

let
  hostMonitors = {
    nixpad = [
      {
        output = "eDP-1";
        mode = "preferred";
        position = "auto";
        scale = 1;
        transform = 0;
      }
    ];
    nixtop = [
      {
        output = "DP-3";
        mode = "1920x1080@60";
        position = "0x0";
        scale = 1;
        vrr = 1;
      }
      {
        output = "HDMI-A-1";
        mode = "1920x1080@60";
        position = "1920x0";
        scale = 1;
        vrr = 1;
      }
    ];
  };

  wallpaperImage = ../../../../../shared/pics/flowers.png;

  sharedConfig = lib.fileContents ./hyprland.lua;

  hyprlandPackage = config.wayland.windowManager.hyprland.finalPackage;

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
    configType = "lua";
    enable = true;
    xwayland.enable = true;
    settings.monitor = hostMonitors.${hostname} or [];
    extraConfig = sharedConfig;
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

      export PATH="${hyprlandPackage}/bin:$PATH"

      exec "${hyprlandPackage}/bin/start-hyprland" \
        --path "${hyprlandPackage}/bin/Hyprland" \
        -- --config "${config.xdg.configHome}/hypr/hyprland.lua"
    '';
  };
}
