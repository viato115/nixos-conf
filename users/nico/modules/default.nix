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
  ];
in
{
  imports = modules;
}
