
{
  pkgs,
  lib,
  ...
}: {
  home.file."/home/nico/.bashrc" = {
    text = ''
      #!/bin/bash
      # Viato's very own bash config.
      # GitLab: https://gitlab.com/viato115
      export TERM='foot'
      export HISTCONTROL=ignoredups:erasedups
      export EDITOR='nvim'
      source ~/.bash_aliases
      export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
      pfetch
      date | awk '{print $1,$2,$3,$4,$6}' ; acpi | grep 'Battery 0' | awk '{print $1,$3,$4}' | sed 's/,$//'
      rm .bash_history* 2>/dev/null ; rm .wget* 2>/dev/null
      bind 'set completion-ignore-case on' 
      [[ $- != *i* ]] && return
    '';
  };

  home.file."/home/nico/.bash_aliases" = {
    text = ''
      #!/bin/bash
      # Viato's very own bash alias config.
      # GitLab: https://gitlab.com/viato115
      alias ..='cd ..'
      alias ...='cd ../..'
      alias .3='cd ../../..'
      alias .4='cd ../../../..'
      alias .5='cd ../../../../..'
      alias x='exit'
      alias compdetails='uname -o && uname -r && uname -p'
      alias cleartrash="rm -rf ~/.local/share/Trash/*"
      alias nv='nvim'
      alias NV='nvim .'
      alias ls='exa -al --color=always --group-directories-first' # my preferred listing
      alias la='exa -a --color=always --group-directories-first'  # all files and dirs
      alias ll='exa -l --color=always --group-directories-first'  # long format
      alias lt='exa -aT --color=always --group-directories-first' # tree listing
      alias l.='exa -a | egrep "^\."'
      alias grep='grep --color=auto'
      alias egrep='egrep --color=auto'
      alias fgrep='fgrep --color=auto'
      alias cp="cp -i"
      alias mv='mv -i'
      alias rm='rm -I'
      alias df='df -h'                                  # human-readable sizes
      alias free='free -m'                              # show sizes in MB
      alias ssn="sudo shutdown now"
      alias sr="sudo reboot"
      alias rr='ranger'
      alias cls="clear ; pfetch ; date | awk '{print $ 1,$ 2,$ 3,$ 4,$ 6}' ; acpi | grep 'Battery 0' | awk '{print $ 1,$ 3,$ 4}' | sed 's/,$//'"
      alias liwr='libreoffice --writer'
      alias lica='libreoffice --calc'
      alias nix-lg='sudo nix-env -p /nix/var/nix/profiles/system --list-generations'
      alias nix-rb='sudo nixos-rebuild switch --rollback'
      alias hm-gens='home-manager generations'
      alias vol='wpctl set-volume 48'
      alias hmflake='export NIXPKGS_ALLOW_UNFREE=1 && home-manager switch --flake .#nico@nixpad --impure --show-trace'
      alias iio='/usr/local/bin/iio-hyprland'
    '';
  };

  home.file."/home/nico/.profile" = {
    text = ''
      #!/bin/bash
      # Viato's very own shell profile config.
      # GitLab: https://gitlab.com/viato115
      if [ -n "$BASH_VERSION" ]; then
          # include .bashrc if it exists
          if [ -f "$HOME/.bashrc" ]; then
      	. "$HOME/.bashrc"
          fi
      fi
      if [ -d "$HOME/bin" ] ; then
          PATH="$HOME/bin:$PATH"
      fi
      if [ -d "$HOME/.local/bin" ] ; then
          PATH="$HOME/.local/bin:$PATH"
      fi
    '';
  };
  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      initExtra = ''
      export TERM='foot'
      export HISTCONTROL=ignoredups:erasedups
      export EDITOR='nvim'
      export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
      pfetch
      date | awk '{print $1,$2,$3,$4,$6}' ; acpi | grep 'Battery 0' | awk '{print $1,$3,$4}' | sed 's/,$//'
      rm .bash_history* 2>/dev/null ; rm .wget* 2>/dev/null
      [[ $- != *i* ]] && return
      '';
     # shellAliases = {
     #   ".." = "cd ..";
     #   "..." = "cd ../..";
     #   ".3" = "cd ../../..";
     #   ".4" = "cd ../../../..";
     #   ".5" = "cd ../../../../..";
     #   x = "exit";
     #   compdetails = "uname -o && uname -r && uname -p";
     #   cleartrash = "rm -rf ~/.local/share/Trash/*";
     #   nv = "nvim";
     #   NV = "nvim .";
     #   ls = "exa -al --color=always --group-directories-first";
     #   la = "exa -a --color=always --group-directories-first";
     #   ll = "exa -l --color=always --group-directories-first";
     #   lt = "exa -aT --color-always --group-directories-first";
     #   grep = "grep --color=auto";
     #   egrep = "egrep --color-auto";
     #   fgrep = "fgrep --color-auto";
     #   cp = "cp -i";
     #   mv = "mv -i";
     #   rm = "rm -i";
     #   df = "df -h";
     #   free = "free -m";
     #   ssn = "sudo shutdown now";
     #   sr = "sudo reboot";
     #   rr = "ranger";
     #   cls = "clear ; pfetch ; date | awk '{print $ 1,$ 2,$ 3,$ 4,$ 6}' ; acpi | grep 'Battery 0' | awk '{print $ 1,$ 3,$ 4}' | sed 's/,$//'";
     #   liwr = "libreoffice --writer";
     #   lica = "libreoffice --calc";
     #   nix-lg = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
     #   nix-rb = "sudo nixos-rebuild switch --rollback";
     #   hm-gens = "home-manager generations";
     #   vol = "wpctl set-volume 48";
     #   hmflake = "export NIXPKGS_ALLOW_UNFREE=1 && home-manager switch --flake .#nico@nixpad --impure --show-trace";
     #   iio = "/usr/local/bin/iio-hyprland";
     # };
    };
  };
}
