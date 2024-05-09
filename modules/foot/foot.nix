{
  pkgs,
  config,
  lib,
  ...
}: with lib; {

  home.file.".config/foot/foot.ini" = {
    text = ''
       shell=bash
       pad=20x20
       term=foot
       app-id=foot
       title=foot
       locked-title=no
       font=Mononoki Nerd Font:size=8
       dpi-aware=yes
      [bell]
       urgent=no
       notify=no
      [scrollback]
       lines=1000
       multiplier=3.0
       indicator-position=relative
      [cursor]
       style=block
       blink=yes
       beam-thickness=1.5
      [mouse]
       hide-when-typing=yes
      [colors]
       alpha=0.9
       background=282a36
       foreground=f8f8f2
      ## Normal/regular colors (color palette 0-7)
       regular0=21222c  # black
       regular1=ff5555  # red
       regular2=50fa7b  # green
       regular3=f1fa8c  # yellow
       regular4=bd93f9  # blue
       regular5=ff79c6  # magenta
       regular6=8be9fd  # cyan
       regular7=f8f8f2  # white
      # Bright colors (color palette 8-15)
       bright0=6272a4   # bright black
       bright1=ff6e6e   # bright red
       bright2=69ff94   # bright green
       bright3=ffffa5   # bright yellow
       bright4=d6acff   # bright blue
       bright5=ff92df   # bright magenta
       bright6=a4ffff   # bright cyan
       bright7=ffffff   # bright white
       selection-foreground=ffffff
       selection-background=44475a
       urls=8be9fd
      [key-bindings]
       clipboard-copy=Control+Shift+c XF86Copy
       clipboard-paste=Control+Shift+v XF86Paste
       search-start=Control+Shift+r
       spawn-terminal=Control+Shift+n
    '';
  };

  programs.foot = {
    enable = true;
  };
}
