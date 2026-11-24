{ config, lib, pkgs, ... }:
{
  services.greetd = {
    enable = true;

    settings.default_session = {
      command = lib.mkForce (
        "${pkgs.tuigreet}/bin/tuigreet --time "
        + "--greeting 'Welcome back, Nico' "
        + "--theme 'container=#1a1b26;border=#7aa2f7;text=#c0caf5;time=#ff9e64;prompt=#ff9e64;input=#c0caf5;action=#7aa2f7;button=#ff9e64' "
        + "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions "
        + "--cmd ${config.programs.niri.package}/bin/niri-session"
      );
      user = "greeter";
    };
  };
}
