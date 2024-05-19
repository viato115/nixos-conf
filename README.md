# This is my NixOS and Home-Manager config repo, it is still WIP.

System: Lenovo ThinkPad L13 Yoga Gen2 (2-in-1 convertible Laptop) on NixOS unstable with standalone Home-Manager and Hyprland.

**TODO**:
- Convert my current Neovim Config to Flakes
- Build iio-hyprland the nix way (currently problem 1)
- Configure Mako/Dunst, EWW and Wofi/Rofi
- Add ad blocking network module

## I currently have 1 problem:
<p>Since I have a 2-in-1 convertible Laptop, I want to make use of the touchscreen in tablet mode. Tablet mode (disabling the keyboard and touchpad when folded backwards) works,
but rotating the screen orientation (horizontal to vertical), does not.<br>
For that I have found a program called 'iio-hyprland' on GitHub. I added the Wacom HID names of my own device into main.c<br>
Building this the normal "non Nix method", I get a binary called "iio-hyprland" in /usr/local/bin which I can run.<br>
Since building it the normal way doesn't add the build binary into /nix/store, and I am using NixOS, I figured I'll try building it the Nix way by writing a default.nix file and running it with "nix-build -E 'with import <:nixpkgs> {}; callPackage ./default.nix' (had to put a : in front of nixpkgs because it wouldn't be displayed in this README without it.)".
For that I found two guides:<br>
- https://elatov.github.io/2022/01/building-a-nix-package/
- https://nix-tutorial.gitlabpages.inria.fr/nix-tutorial/first-experiment.html
<br>
It runs until ninja activate, where it throws me the error pasted in error1.txt.
It seems the script doesn't have permissions to write to /run, so I've tried 'sudo nix-build ...', doesn't work...
I've tried incorporating sudo into my default.nix, doesn't work. 
I've tried searching online, found nothing similar.<br>
And now I am out of ideas...</p>
