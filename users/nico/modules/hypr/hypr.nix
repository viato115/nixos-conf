{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [ mako libnotify grim slurp pamixer];

  home.file.".config/hypr/hyprpaper.conf" = {
    text = ''
      preload = ~/.config/nixos/pics/wallpaper.png
      preload = ~/.config/nixos/pics/neo_tokyo.png
      wallpaper = eDP-1, ~/.config/nixos/pics/neo_tokyo.png
    '';
  };


  home.file.".local/bin/wrappedhl" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      
      cd ~
      
      export HYPRLAND_LOG_WLR=1
      
      export XCURSOR_SIZE=24

      export XDG_CURRENT_DESKTOP=Hyprland
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=Hyprland
      
      export MOZ_ENABLE_WAYLAND=1
      export QT_AUTO_SCREEN_SCALE_FACTOR=1
      export QT_QPA_PLATFORM=wayland
      export QT_QPA_PLATFORMTHEME="qt5ct"
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      
      exec Hyprland
    '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
    extraConfig = lib.fileContents ./hyprland.conf;
  };
}
