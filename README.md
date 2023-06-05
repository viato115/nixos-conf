This is a test repo of my NixOS config dir.

System: Lenovo ThinkPad L13 Yoga Gen 2 (2-in-1 convertible Laptop) on NixOS with standalone Home-Manager and Hyprland

*TODO*: 
  a) Add a greeter (preferrebly tuigreet via greetd)
  b) Change absolute paths to relative paths in home.nix
  c) Build iio-hyprland the nix way (currently Problem 1)
  d) Configure Mako/Dunst, EWW and Wofi/Rofi
  e) Add ad blocking network module
  f) Fix weird Bash Shell in TTY and nvim-toggleterm




I currently have 2 problems:


Problem 1: 
  Since I have a 2-in-1 convertible Laptop, I want to make use of the touchscreen in tablet mode. Tablet mode (disabling the keyboard and touchpad when folded backwards) works, 
  but rotating the screen orientation (horizontal to vertical), does not. 
  For that I have found a program called 'iio-hyprland' on GitHub. I added the Wacom HID names of my own device into main.c. 
  Building this the normal "non Nix method", I get a binary called iio-hyprland in /usr/local/bin which i can run. 
  When running it, the screen rotates like it should, the problem is that the touch input does not rotate, so when I touch somewhere, it registers it where it would have been if the screen wasn't rotated. 
  Since building it the normal way doesn't add the build binary into /nix/store/, I thought that the binary maybe doesn't have proper access to the iio variable I added into my configuration.nix (/hosts/nixpad/default.nix), 
  so I figured I'll try building it the Nix way by writing a default.nix file and running it with "nix-build -E 'with import <:nixpkgs> {}; callPackage ./default.nix {}'  (had to put a : infront of nixpkgs because it wouldn't be displayed in this README without it)". For that I found two guides: 
  https://elatov.github.io/2022/01/building-a-nix-package/
  https://nix-tutorial.gitlabpages.inria.fr/nix-tutorial/first-experiment.html
  
  It runs until ninja activates, where the error pasted in error2.txt appears.
  It seems the script doesn't have permission to write to /run, so I've tried 'sudo nix-build default.nix', doesn't work. 
  I've tried incoporating sudo into my default.nix file, doesn't work. I've tried searching online, found nothing similar. 
  And now I'm out of ideas...



Problem 2:



