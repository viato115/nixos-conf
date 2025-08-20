
{
  config,
  pkgs,
  ...
}:
let
  modules = [
    ../../modules/services/greetd/default.nix
    #    ../../modules/tui/programs/nh/nh.nix
    ../../modules/gaming/gaming.nix
    ../../modules/services/fhs-compat/fhs-compat.nix
    ../../modules/services/bluetooth/bluetooth.nix
    ../../modules/services/keyboard/keyboard.nix
    ../../modules/tui/programs/nh/nh.nix
  ];
in
{
  imports = modules;
}
