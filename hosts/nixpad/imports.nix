
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
    ../../modules/services/fhs-compat/fhs-compat.nix
    ../../modules/tui/programs/nh/nh.nix
  ];
in
{
  imports = modules;
}
