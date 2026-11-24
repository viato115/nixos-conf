{ pkgs, lib, hostname, ... }:
{
  # Both current machines use this profile. A headless home can omit it.
  imports = [
    ../../modules/home/programs/terminals/kitty/kitty.nix
    ../../modules/home/programs/terminals/foot/foot.nix
    ../../modules/home/programs/file-managers/dolphin/dolphin.nix
    ../../modules/home/programs/cli/cava/cava.nix
    ../../modules/home/services/dunst/dunst.nix
    ../../modules/home/programs/browsers/firefox/firefox.nix
    ../../modules/home/launchers/rofi/rofi.nix
    ../../modules/home/appearance/gtk3/gtk3.nix
    ../../modules/home/power/power-menu.nix
  ];

  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      background = [
        {
          monitor = "";
          path = "screenshot";
          blur_passes = 2;
          blur_size = 5;
          brightness = 0.8;
        }
      ];

      label = [
        {
          monitor = "";
          text = "$TIME";
          color = "rgba(255, 158, 100, 1.0)";
          font_size = 60;
          font_family = "Mononoki Nerd Font";
          position = "0, 100";
          halign = "center";
          valign = "center";
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "280, 55";
          position = "0, -35";
          halign = "center";
          valign = "center";

          outer_color = "rgba(255, 158, 100, 1.0)";
          inner_color = "rgba(26, 27, 38, 0.9)";
          font_color = "rgba(192, 202, 245, 1.0)";
          outline_thickness = 2;
          dots_center = true;
          fade_on_empty = false;
          placeholder_text = "Password";
        }
      ];
    };
  };



  # Shared Wayland appearance and tools, independent of the compositor.
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    package = pkgs.vimix-cursors;
    name = "Vimix-cursors";
    size = 16;
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      wallpaper = [
        {
          monitor = "*";
          path = "${../../shared/pics/flowers.png}";
          fit_mode = "cover";
        }
      ];
      splash = false;
    };
  };

  # Desktop packages and host-specific additions.
  home.packages = with pkgs; [

    # Applications shared by the current desktops.
    vivaldi
    zathura
    mpv
    ffmpeg
    pavucontrol
    blueman
    nerd-fonts.mononoki
    feh
    imagemagick
    obsidian
    libreoffice
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
    jre8
    playerctl
    networkmanagerapplet
    gjs
    gnome-bluetooth
    gtk3
    hyprpicker
    polkit_gnome
    scrcpy
    glib
    gnome-frog
    discord

    # Wayland and desktop utilities.
    wl-clipboard
    wl-gammactl
    wlsunset
    mission-center
    libnotify
    grim
    slurp
    pamixer

    # Security and investigation tools.
    sleuthkit
    zsteg
    stegsolve
    binwalk
    autopsy
    nmap
    wireshark
    exiftool
    bviplus
    scalpel
  ]

  ++ lib.optionals (hostname == "nixpad") [
    styluslabs-write-bin
    acpi
    upower
    brightnessctl
  ]

  ++ lib.optionals (hostname == "nixtop") [
    prismlauncher
  ];

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };


  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 52.52;
    longitude = 13.40;
  };


}
