
{
  config,
  pkgs,
  ...
}:
let
  modules = [
    ./swap.nix
    ../../modules/nixos/services/battery/battery_monitor.nix
    ../../modules/nixos/services/battery/suspend.nix
    ../../modules/nixos/services/greetd/default.nix
    ../../modules/nixos/services/fhs-compat/fhs-compat.nix
    ../../modules/nixos/programs/nh/nh.nix
  ];
in
{
  imports = modules;
}
