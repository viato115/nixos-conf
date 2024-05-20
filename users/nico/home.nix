{
  profile,
  config, 
  pkgs,
  lib,
  user,
  inputs,
  hyprland,
  ... 
}:

let 
  custom = {
    font = "Mononoki Nerd Font";
    fontsitze = 12;
    primary_accent = "cba6f7";
    secondary_accent = "89b4fa";
    tertiary_accent = "f5f5f5";
    background = "11111B";
    opacity = "1";
    #cursor = "Numix-Cursor";
    palette = import /home/nico/.config/nixos/users/nico/colors.nix;
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
   acpi
   kitty
   pfetch
   eza
   fortune 
   neovim
   zathura
   mpv
   ffmpeg
   pavucontrol
   blueman
   ripgrep
   fzf
   trash-cli
   bat
   zip
   unzip
   feh
   #firefox-wayland
   chafa
   foot
   imagemagick
   w3m
   #obsidian
   write_stylus
   gawk
   libreoffice
   hunspell
   hunspellDicts.de_DE
   hunspellDicts.en_US
   jre8
   tldr
   playerctl
   networkmanagerapplet
   gjs
   gnome.gnome-bluetooth
   upower
   gtk3
   hyprpicker
   blueberry
   polkit_gnome
   alacritty
   scrcpy
   python3
   glib
   steam-run
#   renpy
   rofi-wayland

   # Hyprland specific
   pulseaudio
   wl-clipboard
   wl-gammactl
   wlsunset

   (pkgs.nerdfonts.override { fonts = [ "Mononoki" ]; })
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


  home.username = "nico";
  home.homeDirectory = "/home/nico";

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;  # Let Home Manager install and manage itself.
  home.stateVersion = "22.11";          # Please read the comment before changing.
}
