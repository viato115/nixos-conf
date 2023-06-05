{
  config, 
  pkgs,
  lib,
  user,
  inputs,
  hyprland,
  ... 
}: {

  imports = [
   # /home/nico/.config/nixos/users/nico/modules/hypr/default.nix
   # /home/nico/.config/nixos/users/nico/modules/kitty/default.nix
   # /home/nico/.config/nixos/users/nico/modules/foot/default.nix
   /home/nico/.config/nixos/users/nico/modules/default.nix
   /home/nico/.config/nixos/users/nico/modules/bash/bash.nix
  ];


  # Packages to install for specified user
  home.packages = with pkgs; [

   # Basics
   greetd.tuigreet
   acpi
   kitty
   pfetch
   exa
   fortune 
   neovim
   ranger
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
   hyprpaper
   feh
   firefox-wayland
   chafa
   foot
   imagemagick
   w3m
   obsidian
   write_stylus
   btop
   wl-clipboard
   gawk
   libreoffice
   hunspell
   hunspellDicts.de_DE
   hunspellDicts.en_US
   jre8


   # Hyprland specific
   pulseaudio
   qt6.qtwayland
   libsForQt5.qt5.qtwayland
   libsForQt5.kdegraphics-thumbnailers
   libsForQt5.dolphin
   libsForQt5.qt5ct
   libsForQt5.dolphin-plugins
   libsForQt5.kdegraphics-thumbnailers
   libsForQt5.breeze-icons
   libsForQt5.qtstyleplugin-kvantum

   (pkgs.nerdfonts.override { fonts = [ "Mononoki" ]; })
  ];


  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 52.52;
    longitude = 13.40;
  };

#  services.iiorient = {
#    enable = true;
#    devices = [ "wacom-hid-51f8-finger" ];
#    monitors = [ "eDP-1" ];
#  };


#  programs = {
#    bash = {
#      enable = true;
#      interactiveShellInit = (builtins.readFile /home/nico/.bashrc);
#     # initExtra = ''
#     #   if test $(id --user $USER) = 1000 && test $(tty) = "/dev/tty1"
#     #   then
#     #     exec Hyprland
#     #   fi
#     # '';
#    };
#  };



 # Manage dotfiles
 # home.file = {
 # };


  home.username = "nico";
  home.homeDirectory = "/home/nico";

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;  # Let Home Manager install and manage itself.
  home.stateVersion = "22.11";          # Please read the comment before changing.
}
