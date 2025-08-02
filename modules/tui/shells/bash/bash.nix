{
  pkgs,
  lib,
  hostname,
  ...
}:

let 
  greeter = if hostname == "nixpad" then ''
    pfetch
    LANG=de_DE.UTF-8 date +"%a, %d.%m.%Y %H:%M Uhr" ; acpi | grep 'Battery 0' | awk '{print $1,$3,$4}' | sed 's/,$//'
  '' else ''
    pfetch
    LANG=de_DE.UTF-8 date +"%a, %d.%m.%Y %H:%M Uhr"  
  '';
in

{
  programs = {
    bash = {
      enable = true;
      enableCompletion = true;
      historyControl = [ "ignoredups" "erasedups" ];
      historyFile = "/home/nico/.cache/bashhist.txt";
      historyFileSize = 100000;
      historyIgnore = [ "ls" "cd" "exit" "NV" "fzf" ];
      historySize = 1000;
      shellOptions = [ "-checkjobs" ];
      bashrcExtra = ''
        export TERM='foot'
        export EDITOR='nvim'
        export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
        export PATH=$PATH:/usr/bin:/usr/local/bin:$HOME/.local/bin
        export QT_STYLE_OVERRIDE=kvantum

        # Git prompt support
        if [ -f ${pkgs.git}/share/git/contrib/completion/git-prompt.sh ]; then
          source ${pkgs.git}/share/git/contrib/completion/git-prompt.sh
        fi

        export PS1='\[\e[38;5;111m\]\u@\h \[\e[38;5;117m\]\w \[\e[0m\]\$ ' 
        ${greeter}
        echo
        bind 'set completion-ignore-case on'

      '';

      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        ".3" = "cd ../../..";
        ".4" = "cd ../../../..";
        ".5" = "cd ../../../../..";
        x = "exit";
        compdetails = "uname -o && uname -r && uname -p";
        cleartrash = "rm -rf ~/.local/share/Trash/*";
        nv = "nvim";
        ls = "eza -al --color=always --group-directories-first";
        la = "eza -a --color=always --group-directories-first";
        ll = "eza -l --color=always --group-directories-first";
        lt = "eza -aT --color-always --group-directories-first";
        grep = "grep --color=auto";
        egrep = "egrep --color-auto";
        fgrep = "fgrep --color-auto";
        cp = "cp -i";
        mv = "mv -i";
        rm = "rm -i";
        df = "df -h";
        free = "free -m";
        ssn = "sudo shutdown now";
        sr = "sudo reboot";
        rr = "ranger";
        cls = "clear ; pfetch ; date | awk '{print $ 1,$ 2,$ 3,$ 4,$ 6}' ; acpi | grep 'Battery 0' | awk '{print $ 1,$ 3,$ 4}' | sed 's/,$//'";
        liwr = "libreoffice --writer";
        lica = "libreoffice --calc";
        nix-lg = "sudo nix-env -p /nix/var/nix/profiles/system --list-generations";
        nix-rb = "sudo nixos-rebuild switch --rollback";
        hm-gens = "home-manager generations";
        vol = "wpctl set-volume 48";
        hmflake = "home-manager switch --flake .#nico@nixpad --show-trace";
        iio = "/usr/local/bin/iio-hyprland";
        hyprexit = "hyprctl dispatch exit";
        nvc = "cd ~/.config/nixos && nv";
        cdw = "cd /mnt/windows";
        cdc = "cd /home/nico/.config/nixos"
      };
    };
  };
}
