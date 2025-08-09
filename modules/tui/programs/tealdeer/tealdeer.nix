{ pkgs, ... }:
{
  programs.tealdeer = {
    enable = true;

    settings = {
      style.description = {
        foreground = "white";
        underline = false;
        bold = true;
        italic = false;
      };
      style.command_name = {
        foreground = "blue";
        underline = false;
        bold = false;
        italic = false;
      };
      style.example_text = {
        foreground = "green";
        underline = false;
        bold = false;
        italic = false;
      };
      style.example_code = {
        foreground = "cyan";
        underline = false;
        bold = false;
        italic = false;
      };
      style.example_variable = {
        foreground = "yellow";
        underline = false;
        bold = false;
        italic = false;
      };
      display = {
        compact = false;
        use_pager = false;
      };
      updates = {
        auto_update = true;
        auto_update_interval_hours = 24;
      };
    };
  };
}
