{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  home.packages = with pkgs; [ libnotify grim slurp pamixer];

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
    extraConfig = lib.fileContents ./hyprland.conf;
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "~/.config/nixos/pics/wallpaper.png"
        "~/.config/nixos/pics/neo_tokyo.png"
      ];
      wallpaper = [
        "eDP-1,~/.config/nixos/pics/neo_tokyo.png"
        "DP-3,~/.config/nixos/pics/neo_tokyo.png"
      ];

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
