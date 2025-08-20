{
  config, 
  pkgs,
  lib,
  user,
  inputs,
  hostname,
  ... 
}:

let 
  custom = {
    font = "Mononoki Nerd Font";
    fontsitze = 16;
    primary_accent = "cba6f7";
    secondary_accent = "89b4fa";
    tertiary_accent = "f5f5f5";
    background = "11111B";
    opacity = "1";
    palette = import ./colors.nix;
  };

in
{
  _module.args = { inherit inputs custom; };
  
  imports = [
  ./imports.nix
  ];


  # Packages to install for specified user
  home.packages = with pkgs; [

    # Basics
    fd
    nvd
    nix-output-monitor
    kitty
    pfetch
    eza
    fortune 
    zathura
    mpv
    ffmpeg
    pavucontrol
    blueman
    ripgrep
    fzf
    trash-cli
    nerd-fonts.mononoki
    bat
    zip
    unzip
    feh
    foot
    imagemagick
    #obsidian
    gawk
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
    blueberry
    polkit_gnome
    alacritty
    scrcpy
    python3
    glib
#    renpy
    nil
    nixpkgs-fmt
    btop
    dysk

    # Hyprland specific
    #pulseaudio
    wl-clipboard
    wl-gammactl
    wlsunset
     #find
    

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
    openssl
    ltrace
    strace
  ]

  ++ lib.optionals (hostname == "nixpad") [
    write_stylus
    acpi
    upower
    brightnessctl
  ]


  ++ lib.optionals (hostname == "nixtop") [

  ];

#  home.sessionVariables = lib.mkIf (hostname == "nixtop") {
#    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
#  };


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


  home.username = "nico";
  home.homeDirectory = "/home/nico";

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;  # Let Home Manager install and manage itself.
  home.stateVersion = "22.11";          # Please read the comment before changing.
}
