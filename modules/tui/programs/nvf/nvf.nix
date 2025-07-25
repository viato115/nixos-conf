{ pkgs, lib, ... }:
let telescopeFzf = pkgs.vimPlugins.telescope-fzf-native-nvim;
in
{
  programs.nvf = {

    # general settings 
    enable = true;
    settings.vim = {
      theme.enable = true;
      theme.name = "tokyonight";
      theme.style = "night";
      viAlias = true;
      vimAlias = true;
      lsp = {
        enable = true;
      };
      

      # plugins
      dashboard.alpha.enable = true;

      telescope = {
        enable = true;
        extensions = [
          {
            name = "fzf";
            packages = [ telescopeFzf ];
            setup = { fzf = { fuzzy = true; }; };
          }
        ];
      };
      
      filetree.nvimTree = {
        enable = true;
        mappings = {
          findFile = "<leader>ff";
          toggle = "<leader>e";
        };
      };





      languages = {
        enableTreesitter = true;
        nix.enable = true;
        rust.enable = true;
        python.enable = true;
        lua.enable = true;
        markdown.enable = true;
      };
    };
  };
}
