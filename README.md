# This is my NixOS and Home-Manager config repo, it is still WIP.

System: Lenovo ThinkPad L13 Yoga Gen2 (2-in-1 convertible Laptop) on NixOS unstable with standalone Home-Manager and Hyprland.

**TODO**:
- Convert my current Neovim Config to Flakes
- Build iio-hyprland the nix way (currently problem 1)
- Configure Mako/Dunst, EWW and Wofi/Rofi
- Add ad blocking network module

## I currently have 1 problem:
Thanks to the amazing c2vi for making me aware that there is now a nix compatibility for iio-hyprland, my old problem is finally obsolete. 
I however encountered a new problem. 
So I added the yassineibr/iio-hyprland/... to my flake inputs aswell as added the iio-hyprland package to my hosts/nixpad/default.nix,
updating the system via "sudo nixos-rebuild switch --flake .#nixpad --impure" gives the error "error: attribute 'inputs' missing" (full log found in problem1/logfile.txt).
I've yet to find a solution.
