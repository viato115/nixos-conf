{
  config,
  pkgs,
  lib,
  #inputs,
  ...
}: {
  gtk = {
    enable = true;
    gtk3 = {
      extraConfig = {
        gtk-theme-name = "fuji";
        gtk-icon-theme-name = "fuji";
        gtk-font-name = "Roboto 11";
        gtk-cursor-theme-name = "WhiteSur-cursors";
        gtk-cursor-theme-size = 0;
        gtk-toolbar-style = "GTK_TOOLBAR_ICONS";
        gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
        gtk-button-images = 0;
        gtk-menu-images = 1;
        gtk-enable-event-sounds = 0;
        gtk-enable-input-feedback-sounds = 0;
        gtk-xft-antialias = 1;
        gtk-xft-hinting = 1;
        gtk-xft-hintstyle = "hintslight";
        gtk-xft-rgba = "rgb";
        gtk-overlay-scrolling = 1;
      };
      extraCss = ''
        headerbar { color: #f0f0f0 ;
          background-color: #0f0f0f ;
        }
        headerbar:backdrop {
          color: #f0f0f0 ;
          background-color: #0f0f0f ;
        }
        menubar {
        	color: #f0f0f0;
          background-color: #0f0f0f
        }
      '';
    };
  };

  home.file.".config/gtk-3.0/import-gsettings" = {
    text = ''
      #!/bin/sh
      # usage: import-gsettings
      if [ ! -f "$config" ]; then exit 1; fi
      gnome_schema="org.gnome.desktop.interface"
      config="/home/$USER/.config/gtk-3.0/settings.ini"
      gtk_theme="$(grep 'gtk-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      icon_theme="$(grep 'gtk-icon-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      cursor_theme="$(grep 'gtk-cursor-theme-name' "$config" | sed 's/.*\s*=\s*//')"
      font_name="$(grep 'gtk-font-name' "$config" | sed 's/.*\s*=\s*//')"
      gsettings set "$gnome_schema" gtk-theme "$gtk_theme"
      gsettings set "$gnome_schema" icon-theme "$icon_theme"
      gsettings set "$gnome_schema" cursor-theme "$cursor_theme"
      gsettings set "$gnome_schema" font-name "$font_name"
    '';
  };
}
