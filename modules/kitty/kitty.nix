{
  pkgs,
  config,
  lib,
  ...
}: with lib; {

  programs.kitty = {
    enable = true;
    extraConfig = ''
      font_family Mononoki Nerd Font Complete Regular
      bold_font auto
      italic_font auto
      bold_italic_font auto
      font_size 14.0
      disable_ligatures never
      font_features none
      
      cursor_stop_blinking_after 15.0

      scrollback_lines 2000
      scrollback_pager less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER
      scrollback_pager_history_size 0
      wheel_scroll_multiplier 5.0
      touch_scroll_multiplier 3.0
      mouse_hide_wait 3.0

      url_style curly
      open_url_with firefox
      open_url_modifiers kitty_mod

      sync_to_monitor yes
      input_delay 3
      enable_audio_bell no
      visual_bell_duration 0.0
      window_alert_on_bell no
      bell_on_tab no
      command_on_bell none

      remember_window_size no
      window_border_width 1.0
      draw_minimal_border yes
      placement_strategy center
      confirm_os_window_close 0

      background_opacity 0.9
      background_image none

      shell bash
      editor neovim
      close_on_child_death no
      listen_on none
      update_check_interval 24
      clipboard_control write-clipboard write-primary
      term xterm-kitty
      linux_display_server auto

      kitty_mod ctrl+shift
      map kitty_mod+c copy_to_clipboard
      map kitty_mod+v paste_from_clipboard

      cursor_shape Underline
      cursor_underline_thickness 1
      window_padding_width 10
      
      # Special
      foreground #f8f8f2
      background #282a36
      
      # Black
      color0  #21222c
      color8  #6272a4
      
      # Red
      color1  #ff5555
      color9  #ff6e6e
      
      # Green
      color2  #50fa7b
      color10 #69ff94
      
      # Yellow
      color3  #f1fa8c
      color11 #ffffa5
      
      # Blue
      color4  #bd93f9
      color12 #d6acff
      
      # Magenta
      color5  #ff79c6
      color13 #ff92df
      
      # Cyan
      color6  #8be9fd
      color14 #a4ffff

      # White
      color7  #f8f8f2
      color15 #ffffff
      
      # Cursor
      cursor #f8f8f2
      cursor_text_color background
      
      # Selection highlight
      selection_foreground  #ffffff
      selection_background  #44475a

      url_color #8be9fd

      # Splits/Windows
      active_border_color #f8f8f2
      inactive_border_color #6272a4

    #  foreground           #f8f8f2
    #  background           #282a36
    #  title_fg             #f8f8f2
    #  title_bg             #282a36
    #  margin_bg            #6272a4
    #  margin_fg            #44475a
    #  removed_bg           #ff5555
    #  highlight_removed_bg #ff5555
    #  removed_margin_bg    #ff5555
    #  added_bg             #50fa7b
    #  highlight_added_bg   #50fa7b
    #  added_margin_bg      #50fa7b
    #  filler_bg            #44475a
    #  hunk_margin_bg       #44475a
    #  hunk_bg              #bd93f9
    #  search_bg            #8be9fd
    #  search_fg            #282a36
    #  select_bg            #f1fa8c
    #  select_fg            #282a36
    '';
  };
}
