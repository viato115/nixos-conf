{ pkgs, lib, ... }:

let
  steamWrapper = pkgs.writeShellScriptBin "steam-wayland" ''
    set -e
    export STEAM_USE_WAYLAND=1
    exec ${pkgs.steam}/bin/steam "$@"
  '';

  steamDesktop = pkgs.makeDesktopItem {
    name = "steam-wayland";
    desktopName = "Steam (Wayland)";
    comment = "Steam client with Wayland environment";
    exec = "steam-wayland";
    icon = "steam";
    categories = [ "Game" ];
    terminal = false;
  };

  steamBundle = pkgs.symlinkJoin {
    name = "steam-wayland-launcher";
    paths = [ steamWrapper steamDesktop ];
  };
in {
  programs.steam = {
    enable = lib.mkDefault true;
    gamescopeSession.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  programs.gamemode.enable = true;

  hardware.graphics = {
    enable = lib.mkDefault true;
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    steamBundle
    steam-run
    mangohud
    protonup
    lutris
    bottles
    heroic
    winetricks
    wineWowPackages.waylandFull
    lact
  ];

  environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";

  systemd.packages = [ pkgs.lact ];
  systemd.services.lactd.wantedBy = [ "multi-user.target" ];
}
