{ config, pkgs, inputs, ... }:
{
  hardware = {
    opengl = {
      enable = true; 
      driSupport = true;
      driSupport32bit = true;
    };
  };

  services = {
    xserver.videoDrivers = ["amdgpu"];
  };

  programs = {
    steam = {
      enable = true;
      gamescopeSessions.enable = true;
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
