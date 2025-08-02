
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
    #    ../../modules/tui/programs/nh/nh.nix
    ../../modules/services/fhs-compat/fhs-compat.nix
  ];
in
{
  imports = modules;
}
