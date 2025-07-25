
{
  config,
  pkgs,
  ...
}:
let
  modules = [
    ../../modules/services/battery/battery_monitor.nix
    ../../modules/services/battery/suspend.nix
    ../../modules/services/greetd/default.nix
    ../../modules/gui/DEs/wayland/hypr/hypr.nix
    ../../modules/services/gtk3/gtk3.nix
  ];
in
{
  imports = modules;
}
