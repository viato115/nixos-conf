{ pgks, lib, ... }:
{
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        theme.enable = true;
        theme.name = "tokyonight";
        theme.style = "dark";
        lsp = {
          enable = true;
        };

        languages = {
          enableTreeSitter = true;
          nix.enable = true;
          rust.enable = true;
          python.enable = true;
          lua.enable = true;
          markdown.enable = true;
        };
      };
    };
  };
}
