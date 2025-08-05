{ config, pkgs, lib, inputs, ... }:
{
  hardware = {
    graphics = {
      enable = lib.mkDefault true; 
      enable32Bit = true;
    };
  };

 # services = {
 #   xserver.videoDrivers = ["amdgpu"];
 # };

  programs = {
    java.enable = lib.mkDefault true;
    steam = {
      enable = lib.mkDefault true;
      gamescopeSession.enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    gamemode.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      mangohud
      #protonup-qt
      protonup
      lutris
      bottles
      heroic
      steam-run
      wineWowPackages.stable
      winetricks
      wineWowPackages.waylandFull
      lact
    ];
    sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/nico/.steam/root/compatibilitytools.d";
    };
  };
  systemd.packages = with pkgs; [ lact ];
  systemd.services.lactd.wantedBy = ["multi-user.target"];
}
