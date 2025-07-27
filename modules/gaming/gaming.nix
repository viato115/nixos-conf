{ config, pkgs, inputs, ... }:
{
  hardware = {
    graphics = {
      enable = true; 
      enable32Bit = true;
    };
  };

  services = {
    xserver.videoDrivers = ["amdgpu"];
  };

  programs = {
    steam = {
      enable = true;
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
    ];
  };
}
