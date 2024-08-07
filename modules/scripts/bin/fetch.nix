{
  config,
  pkgs,
  lib,
  #inputs,
  ...
}: {
  home.file.".local/bin/fetch" = {
    executable = true;
    text = ''
      #!/bin/bash
      # Tiny colored fetch script
      # elenapan @ github
      
      f=3 b=4
      for j in f b; do
        for i in {0..7}; do
          printf -v $j$i %b "\e[${!j}${i}m"
        done
      done
      d=$'\e[1m'
      t=$'\e[0m'
      v=$'\e[7m'
      
      # Items
      sep=
      s=$d$f0$sep$t
      
      ds=󰠄
      distro="$(uname -o | awk -F '"' '/PRETTY_NAME/ { print $2 }' /etc/os-release)"
      
      h=󰕮
      wmname="$(echo $XDG_CURRENT_DESKTOP)"
      
      k=󰻀
      kernel="$(uname -r | cut -d '-' -f1)"
      
      p=󰮯
      packages="$(pacman -Q | wc -l)"
      
      sh=󰨊
      shell=$(basename $SHELL)
      
      tput clear
      cat << EOF
                   $f6$ds  $t$distro
         (\ /)     $f4$k  $t$kernel
         ( $d. .$t)    $f3$p  $t$packages
         c($f1"$t)($f1"$t)   $d$f2$h  $t$wmname
                   $f1$sh  $t$shell
      EOF
    '';
  };
}
