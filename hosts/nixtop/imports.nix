{
  config,
  pkgs,
  ...
}:
let
  modules = [
    ../../modules/nixos/services/greetd/default.nix
    ../../modules/nixos/gaming/gaming.nix
    ../../modules/nixos/services/fhs-compat/fhs-compat.nix
    ../../modules/nixos/services/bluetooth/bluetooth.nix
    ../../modules/nixos/services/keyboard/keyboard.nix
    ../../modules/nixos/programs/nh/nh.nix
  ];
in
{
  imports = modules;
}
