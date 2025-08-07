{ config, pkgs, lib, inputs, ... }: 

let 
  steamCustomLauncher = pkgs.stdenv.mkDerivation {
    name = "steam-custom-launcher";
    src = null;
    buildCommand = ''
      mkdir -p $out/share/applications
      mkdir -p $out/bin

      cat > $out/share/applications/steam-custom.desktop <<EOF
      [Desktop Entry]
      Name=Steam (Custom Launch)
      Comment=Launch Steam with proper environment
      Exec=$out/bin/steam-launch.sh
      Icon=steam
      Terminal=false
      Type=Application
      Categories=Game;
      EOF

      cat > $out/bin/steam-launch.sh <<'EOF'
      #!/usr/bin/env bash
      export XDG_SESSION_TYPE=wayland
      export DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS"
      exec steam
      EOF
      chmod +x $out/bin/steam-launch.sh
    '';
  };

in

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
      steamCustomLauncher 
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
