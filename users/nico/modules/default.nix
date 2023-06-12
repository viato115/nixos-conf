{
  config,
  pkgs,
  ...
}: 

let 
  modules = [
    ./hypr/hypr.nix
    ./kitty/kitty.nix
    ./foot/foot.nix
    ./bash/bash.nix
    ./dolphin/dolphin.nix
    ./ranger/ranger.nix
    ./btop/btop.nix
  ];
in
{
  imports = modules;
}
