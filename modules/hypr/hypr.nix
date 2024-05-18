{
  custom ? {
    fontsize = "12";
    primary_accent = "cba6f7";
    secondary_accent = "89b4fa";
    tertiary_accent = "f5f5f5";
    background = "11111B";
    opacity = ".85";
    cursor = "Numix-Cursor";
  },
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
    settings = {
      "$mainMod" = "SUPER";
      monitor = [
      "monitor=eDP-1,preferred,auto,1"
      "monitor=eDP-1,transform,0"
      "monitor=DP-3,1920x1080@60,1920x0,1"
      ]
      exec-once = [
        "waybar"
        "exec-once = hyprpaper -c ~/.config/hypr/hyprpaper.conf"
        "exec-once = dunst -conf ~/.config/dunst/dunstrc"
        "exec-once = foot --server"
        "exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ];
      input = {
        kb_layout = "de";
        follow_mouse = 2
        touchpad = {
          natural_scroll = false
          disable_while_typing = yes
          scroll_factor = 0.5
          tap-to-click = true
          clickfinger_behavior = true
          sensitivity = 0 
        };
      };
      general = {
        gaps_in = 4;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgb(${custom.primary_accent})";
        "col.inactive_border" = "rgba(${custom.background}00)";
        allow_tearing = true;
        layout = "dwindle";
      };
      decoration = {
        rounding = 10;
        shadow_ignore_window = true;
        drop_shadow = true;
        shadow_range = 50;
        shadow_render_power = 3;
        # "col.shadow" = "rgb(${custom.primary_accent})";
        "col.shadow" = "rgba(${custom.primary_accent}00)";
        "col.shadow_inactive" = "rgba(${custom.background}00)";
        blur = {
          enabled = true;
          size = 6;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
          noise = 0.0117;
          contrast = 1.2;
          xray = false;
          brightness = 1;
        };
      };
      animations = {
        enabled = true;
        bezier = [ "easeinoutsine, 0.37, 0, 0.63, 1" ];
        animation = [ 
          "windows,1,2,easeinoutsine,slide" 
          "border,1,10,default"
          "fade,1,1,default"
          "workspaces,1,2,easeinoutsine,slide"
        ];
      };
       dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };
      master = {
        new_is_master = true;
      };
    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 4;
      workspace_swipe_create_new = false;
      workspace_swipe_forever = false;
    }
    misc = {
      animate_manual_resizes = true;
      enable_swallow = true;
      swallow_regex = ^(foot)$;
      disable_hyprland_logo  = true;
      disable_splash_rendering = true;
    }  
    cursor = {
      inactive_timeout = 5;
      hide_on_touch = true;
    }
    
    bind = [
        # Exit to tty
        "$mainMod SHIFT, X, exit"
        
        # Launch
        "$mainMod, RETURN, exec, footclient"
        "$mainMod, D, exec, wofi"
        "bind = $mainMod, T, exec, alacritty"
        "bind = $mainMod, Return, exec, footclient"
        "bind = $mainMod SHIFT, Return, exec, kitty"
        "bind = $mainMod, C, killactive,"
        "bind = $mainMod, W, exec, firefox"
        "bind = $mainMod, E, exec, dolphin"
        "bind = $mainMod, I, exec, obsidian"
        "bind = SUPERSHIFT, SPACE, togglefloating,"
        "#bind = SUPERSHIFT, V, exec, kitty NV"
        "bind = $mainMod, R, exec, kitty /usr/local/bin/iio-hyprland"
        "bind = $mainMod, P, pseudo, # dwindle"
        "bind = $mainMod, J, togglesplit, # dwindle"
        "bind = $mainMod, F, fullscreen"
        "bind = SUPERSHIFT, O, exec, ~/scripts/screenshot.sh"

         # Focus Windows
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"

        # Move Windows
        "$mainMod SHIFT,H,movewindow,l"
        "$mainMod SHIFT,L,movewindow,r"
        "$mainMod SHIFT,K,movewindow,u"
        "$mainMod SHIFT,J,movewindow,d"
        
        # Switch workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

      bindm = [
        # Move and resize windows with mouse too
        "$mainMod, mouse:272, movewindow"
        "$mainMod SHIFT, mouse:272, resizewindow"
      ];
      layerrule = [
        "blur, waybar"
        "blur, wofi"
        "ignorezero, wofi"
      ];
      # Volume
      bindle = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%+
      bindle = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%-
      bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    # extraConfig = lib.fileContents ./hyprland.conf;  
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
