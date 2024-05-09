{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [ 
    libsForQt5.dolphin
    libsForQt5.dolphin-plugins
    libsForQt5.kdegraphics-thumbnailers
    libsForQt5.qt5ct
    libsForQt5.breeze-icons
    libsForQt5.qtstyleplugin-kvantum
    qt6.qtwayland
    libsForQt5.qt5.qtwayland
  ];

  home.file.".config/qt5ct/qt5ct.conf" = {
    text = ''
      [Appearance]
      color_scheme_path=/home/nico/.config/qt5ct/colors/Dracula.conf
      custom_palette=true
      icon_theme=dracula-icons-main
      standard_dialogs=default
      style=kvantum-dark
      
      [Fonts]
      fixed=@Variant(\0\0\0@\0\0\0$\0M\0o\0n\0o\0n\0o\0k\0i\0 \0N\0\x65\0r\0\x64\0 \0\x46\0o\0n\0t@(\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0K\x10)
      general=@Variant(\0\0\0@\0\0\0$\0M\0o\0n\0o\0n\0o\0k\0i\0 \0N\0\x65\0r\0\x64\0 \0\x46\0o\0n\0t@(\0\0\0\0\0\0\xff\xff\xff\xff\x5\x1\0\x32\x10)
      
      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=2
      cursor_flash_time=1000
      dialog_buttons_have_icons=1
      double_click_interval=400
      gui_effects=General, AnimateMenu, AnimateCombo, AnimateTooltip, AnimateToolBox
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      stylesheets=@Invalid()
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3
      
      [PaletteEditor]
      geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\xc2\0\0\0\xdf\0\0\x3\x38\0\0\x2\xef\0\0\0\xc2\0\0\0\xdf\0\0\x3\x38\0\0\x2\xef\0\0\0\0\x2\0\0\0\a\x80\0\0\0\xc2\0\0\0\xdf\0\0\x3\x38\0\0\x2\xef)
      
      [SettingsWindow]
      geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\0\0\0\0\0\0\x2\xc2\0\0\x4\x1d\0\0\0\0\0\0\0\0\0\0\x2\xde\0\0\x3\x15\0\0\0\0\x2\0\0\0\a\x80\0\0\0\0\0\0\0\0\0\0\x2\xc2\0\0\x4\x1d)
      
      [Troubleshooting]
      force_raster_widgets=1
      ignored_applications=@Invalid()
    '';
  };


  home.file.".config/dolphinrc" = {
    text = ''
      MenuBar=Disabled

      [CompactMode]
      PreviewSize=80

      [DetailsMode]
      UseShortRelativeDates=false

      [General]
      RememberOpenedTabs=false
      ShowFullPath=true
      ShowSpaceInfo=false
      ShowToolTips=true
      ShowZoomSlider=false
      Version=202
      ViewPropsTimestamp=2023,5,18,23,12,35.264
      
      [KFileDialog Settings]
      Places Icons Auto-resize=false
      Places Icons Static Size=22

      [KPropertiesDialog]
      1920x1080 screen: Window-Maximized=true

      [MainWindow]
      MenuBar=Disabled
      ToolBarsMovable=Disabled

      [PreviewSettings]
      Plugins=

      [Search]
      Location=Everywhere
    '';
  };

  home.file.".config/qt5ct/colors/Dracula.conf" = {
    text = ''
      [ColorScheme]
      active_colors=#ffbd93f9, #ff424559, #ff484d6b, #ff6272a4, #ff44475a, #ff44475a, #ff6272a4, #ff44475a, #ffbd93f9, #ff282a36, #ff282a36, #ff44475a, #ff6272a4, #ffbd93f9, #ff8be9fd, #ff8be9fd, #ff44475a, #ff6272a4, #ff44475a, #fff8f8f2, #ff44475a
      disabled_colors=#ffbd93f9, #ff424559, #ff484d6b, #ff6272a4, #ff44475a, #ff44475a, #ff6272a4, #ff44475a, #ffbd93f9, #ff282a36, #ff282a36, #ff44475a, #ff6272a4, #ffbd93f9, #ff8be9fd, #ff8be9fd, #ff44475a, #ff6272a4, #ff44475a, #fff8f8f2, #ff44475a
      inactive_colors=#ffbd93f9, #ff424559, #ff484d6b, #ff6272a4, #ff44475a, #ff44475a, #ff6272a4, #ff44475a, #ffbd93f9, #ff282a36, #ff282a36, #ff44475a, #ff6272a4, #ffbd93f9, #ff8be9fd, #ff8be9fd, #ff44475a, #ff6272a4, #ff44475a, #fff8f8f2, #ff44475a
    '';
  };

}
