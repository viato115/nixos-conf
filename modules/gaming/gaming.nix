{ config, pkgs, lib, inputs, ... }:
{
  hardware = {
    graphics = {
      enable = lib.mkDefault true; 
      enable32Bit = true;
    };
  };

  services = {
    xserver.videoDrivers = ["amdgpu"];
  };

  programs = {
    java.enable = lib.mkDefault true;
    steam = {
      enable = lib.mkDefault true;
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      mangohud
      protonup-qt
      lutris
      bottles
      heroic
      steam-run
      wineWowPackages.stable
      winetricks
      wineWowPackages.waylandFull
    ];
  };
}
