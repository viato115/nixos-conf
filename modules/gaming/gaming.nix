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

  hardware = {
    graphics = lib.mkDefault {
      enable = true;
      enable32Bit = true;
      # package = [ pkgs.amdvlk ];
      # package32 = [ pkgs.driversi686Linux.amdvlk ];
    };

    amdgpu.amdvlk = {
      enable = true;
      support32Bit.enable = true;
      #support32Bit.package = [ pkgs.driversi686Linux.amdvlk ];
    };
  };

  security.wrappers.gamescope = {
    source = "${pkgs.gamescope}/bin/gamescope";
    capabilities = "cap_sys_nice+ep";
    owner = "root";
    group = "root";
  };

  environment.systemPackages = with pkgs; [
    steamBundle
    steam-run
    mangohud
    protonup
    protontricks
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
