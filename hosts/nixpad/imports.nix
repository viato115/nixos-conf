
{
  config,
  pkgs,
  ...
}:
let
  modules = [
    ../../modules/tui/programs/nh/nh.nix
    ../../modules/services/battery/battery_monitor.nix
    ../../modules/services/battery/suspend.nix
    ../../modules/services/greetd/default.nix
  ];
in
{
  imports = modules;
}
