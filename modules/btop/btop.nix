{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    btop
  ];

  home.file.".config/btop/btop.conf" = {
    text = ''
      #? Config file for btop v. 1.2.13
      
      #* Name of a btop++/bpytop/bashtop formatted ".theme" file, "Default" and "TTY" for builtin themes.
      #* Themes should be placed in "../share/btop/themes" relative to binary or "$HOME/.config/btop/themes"
      color_theme = "/nix/store/z0m7qsr2ic1jp9951riqd7yx4bqvvkaw-btop-1.2.13/share/btop/themes/dracula.theme"
      
      #* If the theme set background should be shown, set to False if you want terminal background transparency.
      theme_background = False
      
      #* Sets if 24-bit truecolor should be used, will convert 24-bit colors to 256 color (6x6x6 color cube) if false.
      truecolor = True
      
      #* Set to true to force tty mode regardless if a real tty has been detected or not.
      #* Will force 16-color mode and TTY theme, set all graph symbols to "tty" and swap out other non tty friendly symbols.
      force_tty = False
      
      #* Define presets for the layout of the boxes. Preset 0 is always all boxes shown with default settings. Max 9 presets.
      #* Format: "box_name:P:G,box_name:P:G" P=(0 or 1) for alternate positions, G=graph symbol to use for box.
      #* Use whitespace " " as separator between different presets.
      #* Example: "cpu:0:default,mem:0:tty,proc:1:default cpu:0:braille,proc:0:tty"
      presets = "cpu:1:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty"
      
      #* Set to True to enable "h,j,k,l,g,G" keys for directional control in lists.
      #* Conflicting keys for h:"help" and k:"kill" is accessible while holding shift.
      vim_keys = True
      
      #* Rounded corners on boxes, is ignored if TTY mode is ON.
      rounded_corners = True
      
      #* Default symbols to use for graph creation, "braille", "block" or "tty".
      #* "braille" offers the highest resolution but might not be included in all fonts.
      #* "block" has half the resolution of braille but uses more common characters.
      #* "tty" uses only 3 different symbols but will work with most fonts and should work in a real TTY.
      #* Note that "tty" only has half the horizontal resolution of the other two, so will show a shorter historical view.
      graph_symbol = "block"
      
      # Graph symbol to use for graphs in cpu box, "default", "braille", "block" or "tty".
      graph_symbol_cpu = "default"
      
      # Graph symbol to use for graphs in cpu box, "default", "braille", "block" or "tty".
      graph_symbol_mem = "default"
      
      # Graph symbol to use for graphs in cpu box, "default", "braille", "block" or "tty".
      graph_symbol_net = "default"
      
      # Graph symbol to use for graphs in cpu box, "default", "braille", "block" or "tty".
      graph_symbol_proc = "default"
      
      #* Manually set which boxes to show. Available values are "cpu mem net proc", separate values with whitespace.
      shown_boxes = "cpu mem net proc"
      
      #* Update time in milliseconds, recommended 2000 ms or above for better sample times for graphs.
      update_ms = 1000
      
      #* Processes sorting, "pid" "program" "arguments" "threads" "user" "memory" "cpu lazy" "cpu direct",
      #* "cpu lazy" sorts top process over time (easier to follow), "cpu direct" updates top process directly.
      proc_sorting = "cpu lazy"
      
      #* Reverse sorting order, True or False.
      proc_reversed = False
      
      #* Show processes as a tree.
      proc_tree = False
      
      #* Use the cpu graph colors in the process list.
      proc_colors = True
      
      #* Use a darkening gradient in the process list.
      proc_gradient = True
      
      #* If process cpu usage should be of the core it's running on or usage of the total available cpu power.
      proc_per_core = False
      
      #* Show process memory as bytes instead of percent.
      proc_mem_bytes = True
      
      #* Show cpu graph for each process.
      proc_cpu_graphs = True
      
      #* Use /proc/[pid]/smaps for memory information in the process info box (very slow but more accurate)
      proc_info_smaps = False
      
      #* Show proc box on left side of screen instead of right.
      proc_left = False
      
      #* (Linux) Filter processes tied to the Linux kernel(similar behavior to htop).
      proc_filter_kernel = False
      
      #* Sets the CPU stat shown in upper half of the CPU graph, "total" is always available.
      #* Select from a list of detected attributes from the options menu.
      cpu_graph_upper = "total"
      
      #* Sets the CPU stat shown in lower half of the CPU graph, "total" is always available.
      #* Select from a list of detected attributes from the options menu.
      cpu_graph_lower = "total"
      
      #* Toggles if the lower CPU graph should be inverted.
      cpu_invert_lower = True
      
      #* Set to True to completely disable the lower CPU graph.
      cpu_single_graph = False
      
      #* Show cpu box at bottom of screen instead of top.
      cpu_bottom = False
      
      #* Shows the system uptime in the CPU box.
      show_uptime = True
      
      #* Show cpu temperature.
      check_temp = True
      
      #* Which sensor to use for cpu temperature, use options menu to select from list of available sensors.
      cpu_sensor = "Auto"
      
      #* Show temperatures for cpu cores also if check_temp is True and sensors has been found.
      show_coretemp = True
      
      #* Set a custom mapping between core and coretemp, can be needed on certain cpus to get correct temperature for correct core.
      #* Use lm-sensors or similar to see which cores are reporting temperatures on your machine.
      #* Format "x:y" x=core with wrong temp, y=core with correct temp, use space as separator between multiple entries.
      #* Example: "4:0 5:1 6:3"
      cpu_core_map = ""
      
      #* Which temperature scale to use, available values: "celsius", "fahrenheit", "kelvin" and "rankine".
      temp_scale = "celsius"
      
      #* Use base 10 for bits/bytes sizes, KB = 1000 instead of KiB = 1024.
      base_10_sizes = False
      
      #* Show CPU frequency.
      show_cpu_freq = True
      
      #* Draw a clock at top of screen, formatting according to strftime, empty string to disable.
      #* Special formatting: /host = hostname | /user = username | /uptime = system uptime
      clock_format = "%X"
      
      #* Update main ui in background when menus are showing, set this to false if the menus is flickering too much for comfort.
      background_update = True
      
      #* Custom cpu model name, empty string to disable.
      custom_cpu_name = ""
      
      #* Optional filter for shown disks, should be full path of a mountpoint, separate multiple values with whitespace " ".
      #* Begin line with "exclude=" to change to exclude filter, otherwise defaults to "most include" filter. Example: disks_filter="exclude=/boot /home/user".
      disks_filter = ""
      
      #* Show graphs instead of meters for memory values.
      mem_graphs = True
      
      #* Show mem box below net box instead of above.
      mem_below_net = False
      
      #* Count ZFS ARC in cached and available memory.
      zfs_arc_cached = True
      
      #* If swap memory should be shown in memory box.
      show_swap = True
      
      #* Show swap as a disk, ignores show_swap value above, inserts itself after first disk.
      swap_disk = True
      
      #* If mem box should be split to also show disks info.
      show_disks = True
      
      #* Filter out non physical disks. Set this to False to include network disks, RAM disks and similar.
      only_physical = True
      
      #* Read disks list from /etc/fstab. This also disables only_physical.
      use_fstab = True
      
      #* Setting this to True will hide all datasets, and only show ZFS pools. (IO stats will be calculated per-pool)
      zfs_hide_datasets = False
      
      #* Set to true to show available disk space for privileged users.
      disk_free_priv = False
      
      #* Toggles if io activity % (disk busy time) should be shown in regular disk usage view.
      show_io_stat = True
      
      #* Toggles io mode for disks, showing big graphs for disk read/write speeds.
      io_mode = False
      
      #* Set to True to show combined read/write io graphs in io mode.
      io_graph_combined = False
      
      #* Set the top speed for the io graphs in MiB/s (100 by default), use format "mountpoint:speed" separate disks with whitespace " ".
      #* Example: "/mnt/media:100 /:20 /boot:1".
      io_graph_speeds = ""
      
      #* Set fixed values for network graphs in Mebibits. Is only used if net_auto is also set to False.
      net_download = 100
      
      net_upload = 100
      
      #* Use network graphs auto rescaling mode, ignores any values set above and rescales down to 10 Kibibytes at the lowest.
      net_auto = True
      
      #* Sync the auto scaling for download and upload to whichever currently has the highest scale.
      net_sync = True
      
      #* Starts with the Network Interface specified here.
      net_iface = ""
      
      #* Show battery stats in top right if battery is present.
      show_battery = True
      
      #* Which battery to use if multiple are present. "Auto" for auto detection.
      selected_battery = "BAT0"
      
      #* Set loglevel for "~/.config/btop/btop.log" levels are: "ERROR" "WARNING" "INFO" "DEBUG".
      #* The level set includes all lower levels, i.e. "DEBUG" will show all logging info.
      log_level = "WARNING"
    '';
  };


  home.file.".config/btop/themes/dracula.theme" = {
    text = ''
      #Bashtop theme with nord palette (https://www.nordtheme.com)
      #by Justin Zobel <justin.zobel@gmail.com>
      
      # Colors should be in 6 or 2 character hexadecimal or single spaced rgb decimal: "#RRGGBB", "#BW" or "0-255 0-255 0-255"
      # example for white: "#ffffff", "#ff" or "255 255 255".
      
      # All graphs and meters can be gradients
      # For single color graphs leave "mid" and "end" variable empty.
      # Use "start" and "end" variables for two color gradient
      # Use "start", "mid" and "end" for three color gradient
      
      # Main background, empty for terminal default, need to be empty if you want transparent background
      theme[main_bg]="#282A36"
      
      # Main text color
      theme[main_fg]="#BD93F9"
      
      # Title color for boxes
      theme[title]="#f8f8f2"
      
      # Higlight color for keyboard shortcuts
      theme[hi_fg]="#ff79c6"
      
      # Background color of selected item in processes box
      theme[selected_bg]="#44475A"
      
      # Foreground color of selected item in processes box
      theme[selected_fg]="#ECEFF4"
      
      # Color of inactive/disabled text
      theme[inactive_fg]="#6272a4"
      
      # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
      theme[proc_misc]="#BD93F9"
      
      # Cpu box outline color
      theme[cpu_box]="#ff79c6"
      
      # Memory/disks box outline color
      theme[mem_box]="#ff79c6"
      
      # Net up/down box outline color
      theme[net_box]="#ff79c6"
      
      # Processes box outline color
      theme[proc_box]="#ff79c6"
      
      # Box divider line and small boxes line color
      theme[div_line]="#ff79c6"
      
      # Temperature graph colors
      theme[temp_start]="#bd93f9"
      theme[temp_mid]="#bd93f9"
      theme[temp_end]="#bd93f9"
      
      # CPU graph colors
      theme[cpu_start]="#bd93f9"
      theme[cpu_mid]="#bd93f9"
      theme[cpu_end]="#bd93f9"
      
      # Mem/Disk free meter
      theme[free_start]="#bd93f9"
      theme[free_mid]="#bd93f9"
      theme[free_end]="#bd93f9"
      
      # Mem/Disk cached meter
      theme[cached_start]="#bd93f9"
      theme[cached_mid]="#bd93f9"
      theme[cached_end]="#bd93f9"
      
      # Mem/Disk available meter
      theme[available_start]="#bd93f9"
      theme[available_mid]="#bd93f9"
      theme[available_end]="#bd93f9"
      
      # Mem/Disk used meter
      theme[used_start]="#bd93f9"
      theme[used_mid]="#bd93f9"
      theme[used_end]="#bd93f9"
      
      # Download graph colors
      theme[download_start]="#bd93f9"
      theme[download_mid]="#bd93f9"
      theme[download_end]="#bd93f9"
      
      # Upload graph colors
      theme[upload_start]="#bd93f9"
      theme[upload_mid]="#bd93f9"
      theme[upload_end]="#bd93f9"
    '';
  };
}
