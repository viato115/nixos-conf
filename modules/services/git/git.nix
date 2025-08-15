{ pkgs, ... }:
{
  home.packages = [pkgs.gh];

  home.sessionVariables.DELTA_PAGER = "less -R";

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "viato115";
    userEmail = "nschmidt618@gmail.com";

    delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
        true-color = "never";

        features = "unobstrusive-line-numbers decorations";
        unobtrusive-line-numbers = {
         line-numbers = true;
         line-numbers-left-format = "{nm:>4}│";
         line-numbers-right-format = "{np:>4}│";
         line-numbers-left-style = "grey";
         line-numbers-right-style = "grey";
        };
        decorations = {
          commit-decoration-style = "bold grey box ul";
          file-style = "bold blue";
          file-decoration-style = "ul";
          hunk-header-decoration-style = "box";
        };
      };
    };

    extraConfig = {
      init.defaultBranch = "main";
      diff.colorMoved = "default";
      merge.conflictedstyle = "diff3";
      push.autoSetupRemove = true;
      core.editor = "nvim";
      push.default = "default";
      merge.stat = "true";
      core.whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
      repack.usedeltabaseoffset = "true";
      pull.ff = "only";
      rebase = {
        autoSquash = true;
        autoStash = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };

      aliases = {
        st = "status";
        d = "diff";
        p = "pull";
        fuck = "commit --amend -m";
      };
    };
  };
}
