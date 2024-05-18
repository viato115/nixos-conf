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
    ./dunst/dunst.nix
    ./battery/battery_monitor.nix
    ./battery/suspend.nix
    ./gtk3/gtk3.nix
    ./firefox/firefox.nix

    ./bin/default.nix
  ];
in
{
  imports = modules;
}
