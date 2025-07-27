{
  pkgs,
  config,
  lib,
  hostname,
  ...
}: with lib; 

let
  footFonts = {
    nixpad = "Mononoki Nerd Font:size=14";
    nixtop = "Mononoki Nerd Font:size=11";  
  };
in
{

 # home.file.".config/foot/foot.ini" = {
 #   text = ''
 #      shell=bash
 #      pad=20x20
 #      term=foot
 #      app-id=foot
 #      title=foot
 #      locked-title=no
 #      #font=Mononoki Nerd Font:size=8
 #      dpi-aware=yes
 #     [bell]
 #      urgent=no
 #      notify=no
 #     [scrollback]
 #      lines=1000
 #      multiplier=3.0
 #      indicator-position=relative
 #     [cursor]
 #      style=block
 #      blink=yes
 #      beam-thickness=1.5
 #     [mouse]
 #      hide-when-typing=yes
 #     [colors]
 #      alpha=1
 #      background=1a1b26
 #      foreground=c0caf5
 #     ## Normal/regular colors (color palette 0-7)
 #      regular0=15161E  # black
 #      regular1=f7768e  # red
 #      regular2=9ece6a  # green
 #      regular3=e0af68  # yellow
 #      regular4=7aa2f7  # blue
 #      regular5=bb9af7  # magenta
 #      regular6=7dcfff  # cyan
 #      regular7=a9b1d6  # white
 #     # Bright colors (color palette 8-15)
 #      bright0=414868   # bright black
 #      bright1=f7768e   # bright red
 #      bright2=9ece6a   # bright green
 #      bright3=e0af68   # bright yellow
 #      bright4=7aa2f7   # bright blue
 #      bright5=bb9af7   # bright magenta
 #      bright6=7dcfff   # bright cyan
 #      bright7=c0caf5   # bright white
 #      selection-foreground=ffffff
 #      selection-background=44475a
 #      urls=8be9fd
 #     [key-bindings]
 #      clipboard-copy=Control+Shift+c XF86Copy
 #      clipboard-paste=Control+Shift+v XF86Paste
 #      search-start=Control+Shift+r
 #      spawn-terminal=Control+Shift+n
 #   '';
 # #};

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = footFonts.${hostname};
        pad = "20x20";
        term = "foot";
        dpi-aware = true;
      };
      bell = {
        urgent = false;
        notify = false;
      };
      cursor = {
        style = "block";
        blink = true;
        beam-thickness = "1.5";
      };
      mouse = {
        hide-when-typing = true;
      };
      colors = {
        alpha = "1";
        background = "1a1b26";
        foreground = "c0caf5";
      ## Normal/regular colors (color palette 0-7)
        regular0 = "15161E";  # black  
        regular1 = "f7768e";  # red
        regular2 = "9ece6a";  # green
        regular3 = "e0af68";  # yellow
        regular4 = "7aa2f7";  # blue
        regular5 = "bb9af7";  # magenta
        regular6 = "7dcfff";  # cyan
        regular7 = "a9b1d6";  # white
      # Bright colors (color palette 8-15)
        bright0 = "414868";   # bright black
        bright1 = "f7768e";   # bright red
        bright2 = "9ece6a";   # bright green
        bright3 = "e0af68";   # bright yellow
        bright4 = "7aa2f7";   # bright blue
        bright5 = "bb9af7";   # bright magenta
        bright6 = "7dcfff";   # bright cyan
        bright7 = "c0caf5";   # bright white
        selection-foreground = "ffffff";
        selection-background = "44475a";
        urls = "8be9fd";
      };
    };
  };
}
