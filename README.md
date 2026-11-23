# NixOS and Home Manager configuration

This repository contains the NixOS configurations and standalone Home Manager
configurations for my machines. It follows NixOS unstable and is a work in
progress.

| Host | Machine | Desktop sessions |
| --- | --- | --- |
| `nixpad` | Lenovo ThinkPad L13 Yoga Gen 2 | Niri |
| `nixtop` | AMD desktop, dual-booting NixOS and Windows | Niri |

The `hosts/nixwsl/` directory contains an older WSL configuration. It is not
currently exposed as an output in `flake.nix` and has not been validated as
part of the current setup.

## Where things live

| Path | Purpose |
| --- | --- |
| `flake.nix` | Inputs and entry points for each NixOS and Home Manager configuration |
| `hosts/<host>/` | Machine-specific settings, hardware configuration and system module imports |
| `profiles/nixos/core.nix` | Common Nix settings |
| `profiles/nixos/desktop.nix` | Common desktop system settings, such as networking, audio and locale |
| `profiles/home/desktop.nix` | Common desktop applications, services, appearance and host-specific additions |
| `users/nico/home.nix` | Shared user settings and command-line packages |
| `users/nico/imports.nix` | Shared Home Manager command-line modules |
| `modules/nixos/` | Reusable NixOS modules, including gaming and system services |
| `modules/home/` | Home Manager modules, including compositors, applications and user services |
| `shared/` | Shared assets, including wallpapers and themes |

Some modules and backup files are kept for later but are not imported. A file
being present in the tree does not enable it: it must be imported by a host,
profile or another imported module.

## How the configurations are assembled

For NixOS, `flake.nix` selects `hosts/<host>/default.nix`. Each current host
then imports its hardware configuration, `imports.nix`, and the shared NixOS
core and desktop profiles.

For Home Manager, `coreHomeModules` selects `users/nico/home.nix`, which
imports `users/nico/imports.nix`. The `desktopHomeModules` list adds the
shared home desktop profile to that core. Each current home configuration
uses the desktop list and adds the Niri compositor module. The `hostname`
argument supplies host-specific settings.

Niri's shared layout and bindings are in
`modules/home/compositors/niri/config.kdl`; the input and output settings are
in `nixpad-input.kdl` and `nixtop-input.kdl` in the same directory.

For a future headless machine, define a suitable NixOS host and a Home Manager
configuration using `coreHomeModules` without the desktop or compositor
modules. Provide the required `hostname` argument and review the shared
command-line tools for that host's needs.

## Building and switching

Run these commands from the repository:

```sh
cd ~/.config/nixos
git status -sb
```

Git-based flakes include tracked files. If you create a new configuration file,
add it to Git before building; for example, replace the path below with the new
file's path:

```sh
git add -- path/to/new-file.nix
```

On nixtop, both Home Manager configurations can be built without activating them:

```sh
nix build '.#homeConfigurations."nico@nixtop".activationPackage' --no-link
nix build '.#homeConfigurations."nico@nixpad".activationPackage' --no-link
```

For NixOS changes, the system configurations can also be built without switching:

```sh
nix build .#nixosConfigurations.nixtop.config.system.build.toplevel --no-link
nix build .#nixosConfigurations.nixpad.config.system.build.toplevel --no-link
```

Activate NixOS changes **on the machine being changed** with:

```sh
nh os switch
```

Home Manager is standalone, so activate home changes separately, using the
command for the machine you are on:

```sh
# On nixtop:
nh home switch . -c "nico@nixtop"

# On nixpad:
nh home switch . -c "nico@nixpad"
```

Review and commit changes before synchronizing the repository between machines.
Do not change `system.stateVersion` or `home.stateVersion` just because the
system has been updated.

## To do

- Configure sops-nix.
- Add a dashboard and/or bar.
