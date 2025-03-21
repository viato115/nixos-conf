{
  config,
  pkgs,
  lib,
  ...
}: 
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      popup-nvim
      telescope-nvim
      telescope-media-files-nvim
      treesitter
      nvim-tree-lua
      alpha-nvim
      dracula-nvim
      tokyonight-nvim
    ];

  #    extraConfig = ''
  #      lua require("nico.options")
  #      lua require("nico.keymaps")
  #      lua require("nico.telescope")
  #      lua require("nico.nvimtree")
  #      lua require("nico.treesitter")
  #      lua require("nico.alpha-nvim")
  #    '';
  };

  home.file.".config/nvim/lua/nico".source = ./nvim/lua/nico;
  home.file.".config/nvim/init.lua".source = ./nvim/init.lua;



# After this point you'll just encounter endless lines of config files. Turn around while you can

  home.file.".config/nvim/init.lua" = {
    text = ''
      require "nico.options"
      require "nico.keymaps"
      require "nico.plugins"
      require "nico.telescope"
      require "nico.treesitter"
      require "nico.nvimtree"
      --require "nico.dracula"
      require "nico.alpha-nvim"
      require "nico.toyko-night"
      --
      vim.cmd('autocmd VimEnter * source /home/nico/.config/nvim/lua/nico/nvimtree.lua')
    '';
  };

  home.file.".config/nvim/lua/nico/alpha-nvim.lua" = {
    text = ''
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")
      local opt = { noremap = true, silent = true }
      local logo = [[
      
      
      
      
      
      
      
                                                   
            ████ ██████           █████      ██
           ███████████             █████ 
           █████████ ███████████████████ ███   ███████████
          █████████  ███    █████████████ █████ ██████████████
         █████████ ██████████ █████████ █████ █████ ████ █████
       ███████████ ███    ███ █████████ █████ █████ ████ █████
      ██████  █████████████████████ ████ █████ █████ ████ ██████
      ]]
      
      
      -- set footnotes
      local function footer()
        local total_plugins = vim.fn.len(vim.fn.globpath("~/.local/share/nvim/site/pack/packer/start", "*", 0, 1))
        local datetime = os.date(" %d-%m-%Y   %H:%M:%S")
        local version = vim.version()
        local nvim_version_info = "  v" .. version.major .. "." .. version.minor .. "." .. version.patch
        return datetime .. "   " .. total_plugins .. " plugins" .. nvim_version_info
      end
      
      -- set header
      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", "<cmd>lua require'telescope.builtin'.find_files({ find_command = { 'rg', '--files', '--hidden', '-g', '!.git' }})<cr>"),
        dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
      }
      dashboard.section.footer.val = footer()
      dashboard.section.footer.opts.hl = "Constant"
      -- dashboard.section.header.opts.hl = "AlphaHeader"
      -- dashboard.opts.layout[1].val = 6
      -- return dashboard
      alpha.setup(dashboard.opts)
      vim.cmd([[ autocmd FileType alpha setlocal nofoldenable ]])
    '';
  };

  home.file.".config/nvim/lua/nico/dracula.lua" = {
    text = ''
      local dracula = require("dracula")
      dracula.setup({
        -- customize dracula color palette
        theme = 'dracula-soft',
        colors = {
          bg = "#282A36",
          fg = "#F8F8F2",
          selection = "#44475A",
          comment = "#6272A4",
          red = "#FF5555",
          orange = "#FFB86C",
          yellow = "#F1FA8C",
          green = "#50fa7b",
          purple = "#BD93F9",
          cyan = "#8BE9FD",
          pink = "#FF79C6",
          bright_red = "#FF6E6E",
          bright_green = "#69FF94",
          bright_yellow = "#FFFFA5",
          bright_blue = "#D6ACFF",
          bright_magenta = "#FF92DF",
          bright_cyan = "#A4FFFF",
          bright_white = "#FFFFFF",
          menu = "#21222C",
          visual = "#3E4452",
          gutter_fg = "#4B5263",
          nontext = "#3B4048",
        },
        -- show the '~' characters after the end of buffers
        show_end_of_buffer = true, -- default false
        -- use transparent background
        transparent_bg = true, -- default false
        -- set custom lualine background color
        lualine_bg_color = "#44475a", -- default nil
        -- set italic comment
        italic_comment = true, -- default false
        -- overrides the default highlights see `:h synIDattr`
        overrides = {
          -- Examples
          -- NonText = { fg = dracula.colors().white }, -- set NonText fg to white
          -- NvimTreeIndentMarker = { link = "NonText" }, -- link to NonText highlight
          -- Nothing = {} -- clear highlight of Nothing
        },
      })
    '';
  };

  home.file.".config/nvim/lua/nico/nvimtree.lua" = {
    text = ''
      --local tree_cb = require'nvim-tree.config'.nvim_tree_callback
      
      
      
      local function on_attach(bufnr)
        local api = require('nvim-tree.api')
        local function opts(desc)
          return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end
        vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,          opts('CD'))
        vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer,     opts('Open: In Place'))
        vim.keymap.set('n', '<C-k>', api.node.show_info_popup,              opts('Info'))
        vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                     opts('Rename: Omit Filename'))
      --  vim.keymap.set('n', '<C-t>', api.node.open.tab,                     opts('Open: New Tab'))
      --  vim.keymap.set('n', '<C-v>', api.node.open.vertical,                opts('Open: Vertical Split'))
        vim.keymap.set('n', '<C-x>', api.node.open.horizontal,              opts('Open: Horizontal Split'))
        vim.keymap.set('n', '<BS>',  api.node.navigate.parent_close,        opts('Close Directory'))
        vim.keymap.set('n', '<CR>',  api.node.open.edit,                    opts('Open'))
        vim.keymap.set('n', '<Tab>', api.node.open.preview,                 opts('Open Preview'))
        vim.keymap.set('n', '>',     api.node.navigate.sibling.next,        opts('Next Sibling'))
        vim.keymap.set('n', '<',     api.node.navigate.sibling.prev,        opts('Previous Sibling'))
        vim.keymap.set('n', '.',     api.node.run.cmd,                      opts('Run Command'))
        vim.keymap.set('n', '-',     api.tree.change_root_to_parent,        opts('Up'))
        vim.keymap.set('n', 'a',     api.fs.create,                         opts('Create'))
        vim.keymap.set('n', 'bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
        vim.keymap.set('n', 'B',     api.tree.toggle_no_buffer_filter,      opts('Toggle No Buffer'))
        vim.keymap.set('n', 'c',     api.fs.copy.node,                      opts('Copy'))
        vim.keymap.set('n', 'C',     api.tree.toggle_git_clean_filter,      opts('Toggle Git Clean'))
        vim.keymap.set('n', '[c',    api.node.navigate.git.prev,            opts('Prev Git'))
        vim.keymap.set('n', ']c',    api.node.navigate.git.next,            opts('Next Git'))
        vim.keymap.set('n', 'd',     api.fs.remove,                         opts('Delete'))
        vim.keymap.set('n', 'D',     api.fs.trash,                          opts('Trash'))
        vim.keymap.set('n', 'E',     api.tree.expand_all,                   opts('Expand All'))
        vim.keymap.set('n', 'e',     api.fs.rename_basename,                opts('Rename: Basename'))
        vim.keymap.set('n', ']e',    api.node.navigate.diagnostics.next,    opts('Next Diagnostic'))
        vim.keymap.set('n', '[e',    api.node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
        vim.keymap.set('n', 'F',     api.live_filter.clear,                 opts('Clean Filter'))
        vim.keymap.set('n', 'f',     api.live_filter.start,                 opts('Filter'))
        vim.keymap.set('n', 'g?',    api.tree.toggle_help,                  opts('Help'))
        vim.keymap.set('n', 'gy',    api.fs.copy.absolute_path,             opts('Copy Absolute Path'))
        vim.keymap.set('n', 'H',     api.tree.toggle_hidden_filter,         opts('Toggle Dotfiles'))
        vim.keymap.set('n', 'I',     api.tree.toggle_gitignore_filter,      opts('Toggle Git Ignore'))
        vim.keymap.set('n', 'J',     api.node.navigate.sibling.last,        opts('Last Sibling'))
        vim.keymap.set('n', 'K',     api.node.navigate.sibling.first,       opts('First Sibling'))
        vim.keymap.set('n', 'm',     api.marks.toggle,                      opts('Toggle Bookmark'))
        --vim.keymap.set('n', 'o',     api.node.open.edit,                    opts('Open'))
        vim.keymap.set('n', 'l',     api.node.open.edit,                    opts('Open'))
        vim.keymap.set('n', 'O',     api.node.open.no_window_picker,        opts('Open: No Window Picker'))
        vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
        vim.keymap.set('n', 'P',     api.node.navigate.parent,              opts('Parent Directory'))
        vim.keymap.set('n', 'q',     api.tree.close,                        opts('Close'))
        vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
        vim.keymap.set('n', 'R',     api.tree.reload,                       opts('Refresh'))
        vim.keymap.set('n', 's',     api.node.run.system,                   opts('Run System'))
        vim.keymap.set('n', 'S',     api.tree.search_node,                  opts('Search'))
        vim.keymap.set('n', 'U',     api.tree.toggle_custom_filter,         opts('Toggle Hidden'))
        vim.keymap.set('n', 'W',     api.tree.collapse_all,                 opts('Collapse'))
        vim.keymap.set('n', 'x',     api.fs.cut,                            opts('Cut'))
        vim.keymap.set('n', 'y',     api.fs.copy.filename,                  opts('Copy Name'))
        vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,             opts('Copy Relative Path'))
        vim.keymap.set('n', '<2-LeftMouse>',  api.node.open.edit,           opts('Open'))
        vim.keymap.set('n', '<2-RightMouse>', api.tree.change_root_to_node, opts('CD'))
      
        vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
      --  vim.keymap.set('n', 'O', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
        vim.keymap.set('n', 'v', api.node.open.vertical, opts('Open: Vertical Split'))
      end
      
      
      require("nvim-tree").setup { -- BEGIN_DEFAULT_OPTS
        on_attach = on_attach,
        auto_reload_on_write = true,
        disable_netrw = true,
        hijack_cursor = true,
        hijack_netrw = true,
        hijack_unnamed_buffer_when_opening = false,
        sort_by = "name",
        root_dirs = {},
        prefer_startup_root = false,
        sync_root_with_cwd = true,
        reload_on_bufenter = false,
        respect_buf_cwd = false,
        on_attach = "default",
        --remove_keymaps = false,       -- Removed??
        select_prompts = false,
        view = {
          centralize_selection = false,
          cursorline = true,
          debounce_delay = 15,
          width = 30,
          --hide_root_folder = false,  -- Removed??
          side = "left",
          preserve_window_proportions = false,
          number = false,
          relativenumber = false,
          signcolumn = "yes",
         -- mappings = {
         --   custom_only = false,
         --   list = {
         --   --  { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
         --   --  { key = "h", cb = tree_cb "close_node" },
         --   --  { key = "v", cb = tree_cb "vsplit" }
         --     -- user mappings go here
         --   },
         -- },
          float = {
            enable = false,
            quit_on_focus_loss = true,
            open_win_config = {
              relative = "editor",
              border = "rounded",
              width = 35,
              height = 35,
              row = 1,
              col = 1,
            },
          },
        },
        renderer = {
          add_trailing = false,
          group_empty = false,
          highlight_git = false,
          full_name = false,
          highlight_opened_files = "none",
          highlight_modified = "none",
          root_folder_label = ":~:s?$?/..?",
          indent_width = 2,
          indent_markers = {
            enable = false,
            inline_arrows = true,
            icons = {
              corner = "└",
              edge = "│",
              item = "│",
              bottom = "─",
              none = " ",
            },
          },
          icons = {
            webdev_colors = true,
            git_placement = "before",
            modified_placement = "after",
            padding = " ",
            symlink_arrow = " ➛ ",
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
              modified = true,
            },
            glyphs = {
              default = "",
              symlink = "",
              bookmark = "",
              modified = "●",
              folder = {
                arrow_closed = "",
                arrow_open = "",
                default = "",
                open = "",
                empty = "",
                empty_open = "",
                symlink = "",
                symlink_open = "",
              },
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "",
                ignored = "◌",
              },
            },
          },
          special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
          symlink_destination = true,
        },
        hijack_directories = {
          enable = true,
          auto_open = true,
        },
        update_focused_file = {
          enable = false,
          update_root = false,
          ignore_list = {},
        },
        system_open = {
          cmd = "",
          args = {},
        },
        diagnostics = {
          enable = false,
          show_on_dirs = false,
          show_on_open_dirs = true,
          debounce_delay = 50,
          severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
          },
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          },
        },
        filters = {
          dotfiles = false,
          git_clean = false,
          no_buffer = false,
          custom = {},
          exclude = {},
        },
        filesystem_watchers = {
          enable = true,
          debounce_delay = 50,
          ignore_dirs = {},
        },
        git = {
          enable = true,
          ignore = true,
          show_on_dirs = true,
          show_on_open_dirs = true,
          timeout = 400,
        },
        modified = {
          enable = false,
          show_on_dirs = true,
          show_on_open_dirs = true,
        },
        actions = {
          use_system_clipboard = true,
          change_dir = {
            enable = true,
            global = false,
            restrict_above_cwd = false,
          },
          expand_all = {
            max_folder_discovery = 300,
            exclude = {},
          },
          file_popup = {
            open_win_config = {
              col = 1,
              row = 1,
              relative = "cursor",
              border = "shadow",
              style = "minimal",
            },
          },
          open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
              enable = true,
              picker = "default",
              chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
              exclude = {
                filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                buftype = { "nofile", "terminal", "help" },
              },
            },
          },
          remove_file = {
            close_window = true,
          },
        },
        trash = {
          cmd = "gio trash",
        },
        live_filter = {
          prefix = "[FILTER]: ",
          always_show_folders = true,
        },
        tab = {
          sync = {
            open = false,
            close = false,
            ignore = {},
          },
        },
        notify = {
          threshold = vim.log.levels.INFO,
        },
        ui = {
          confirm = {
            remove = true,
            trash = true,
          },
        },
        experimental = {
          git = {
            async = true,
          },
        },
        log = {
          enable = false,
          truncate = false,
          types = {
            all = false,
            config = false,
            copy_paste = false,
            dev = false,
            diagnostics = false,
            git = false,
            profile = false,
            watcher = false,
          },
        },
      } -- END_DEFAULT_OPTS
      
      
      
        -- Default mappings. Feel free to modify or remove as you wish.
        --
        -- BEGIN_DEFAULT_ON_ATTACH
        -- END_DEFAULT_ON_ATTACH
      
      
        -- Mappings migrated from view.mappings.list
        --
        -- You will need to insert "your code goes here" for any mappings with a custom action_cb
    '';
  };

  home.file.".config/nvim/lua/nico/options.lua" = {
    text = ''
      --
      -- In this file, I set some basic options to configure NVIM.
      
      local options = {
        backup = false,
        clipboard = "unnamedplus",
        cmdheight = 1,
        completeopt = { "menuone", "noselect" },
        conceallevel = 0,  				-- makes `` visible in .md files
        fileencoding = "utf-8",
        hlsearch = true,
        ignorecase = true,
        pumheight = 10,
        mouse = a,
        showmode = false,
        showtabline = 1,
        smartcase = true,
        smartindent = true,
        swapfile = false,
        splitbelow = true,
        splitright = true,
        undofile = true,
        updatetime = 300,
        expandtab = true,
        tabstop = 2,
        shiftwidth = 2,
        cursorline = false,
        number = true,
        relativenumber = false,
        numberwidth = 4,
        signcolumn = "no",
        wrap = false,
        scrolloff = 8,
        sidescrolloff = 8,
        guifont = "Mononoki Nerd Font:h14",
        termguicolors = true,  -- set term gui colors, most terms support this
        fillchars = { eob = ' ' }
      }
      
      for k, v in pairs(options) do
          vim.opt[k] = v
      end
      
      vim.cmd [[set iskeyword+=-]]
      vim.cmd "set whichwrap+=<,>,[,],h,l"
    '';
  };

  home.file.".config/nvim/lua/nico/telescope.lua" = {
    text = ''
      local status_ok, telescope = pcall(require, "telescope")
      if not status_ok then
        return
      end
      
      telescope.load_extension('media_files')
      
      local actions = require "telescope.actions"
      
      telescope.setup {
        defaults = {
          path_display = { "smart" },
      
          mappings = {
            i = {
              ["<C-c>"] = actions.close,
      --        ["<C-n>"] = actions.cycle_history_next,
      --        ["<C-p>"] = actions.cycle_history_previous,
      
      
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
      
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
      
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
      
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
      
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions.complete_tag,
              ["<C-_>"] = actions.which_key,
            },
            n = {
              ["<ESC>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
      
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
      
              ["<Down>"] = actions.move_selection_next,
              ["<Up>"] = actions.move_selection_previous,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
      
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
      
              ["<PageUp>"] = actions.results_scrolling_up,
              ["<PageDown>"] = actions.results_scrolling_down,
      
              ["?"] = actions.which_key,
            },
          },
        },
      
        extensions = {
          media_files = {
            filetypes = {"png", "jpg", "jpeg"},
            find_cmd = "rg"
          },
        },
      } 
    '';
  };

  home.file.".config/nvim/lua/nico/tokyo-night.lua" = {
    text = ''
      require("tokyonight").setup({
        style = "night",
        transparent = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          sidebars = "transparent", -- style for sidebars, see below
          floats = "dark", -- style for floating windows
        },
        sidebars = { "packer" },
      
        on_colors = function(colors)
          colors.bg = "#16161e"
        end,
      
        on_highlights = function(hl, c)
          local prompt = "#2d3149"
          hl.TelescopeNormal = {
            bg = c.bg_dark,
            fg = c.fg_dark,
          }
          hl.TelescopeBorder = {
            bg = c.bg_dark,
            fg = c.bg_dark,
          }
          hl.TelescopePromptNormal = {
            bg = prompt,
          }
          hl.TelescopePromptBorder = {
            bg = prompt,
            fg = prompt,
          }
          hl.TelescopePromptTitle = {
            bg = prompt,
            fg = prompt,
          }
          hl.TelescopePreviewTitle = {
            bg = c.bg_dark,
            fg = c.bg_dark,
          }
          hl.TelescopeResultsTitle = {
            bg = c.bg_dark,
            fg = c.bg_dark,
          }
        end,
      })
      
      vim.cmd("colorscheme tokyonight-night")
    '';
  };

  home.file.".config/nvim/lua/nico/treesitter.lua" = {
    text = ''
      local status_ok, configs = pcall(require, "nvim-treesitter.configs")
      if not status_ok then
        return
      end
      
      configs.setup {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "bash", "cmake", "css", "go", "html", "ini", "java", "javascript", "json", "make", "markdown", "markdown_inline", "ninja", "nix", "perl", "python", "rust", "toml", "typescript", "yaml" }, --  "all" or a list of languages
        sync_install = false, -- install languages synchronously (only applies to ensure_installed)
        ignore_installed = { "" }, -- list of parsers to ignore installing
        highlight = {
          enable = true, -- false will disable the whole extension
          disable = { "" }, -- list of languages that will be disabled
          additional_vim_regex_highlighting = true,
        },
        indent = { enable = true, disable = { "" } },
        rainbow = {
          enable = true,
          -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
          extended_mode = true, -- also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
          max_file_lines = nil,  -- do not enable for files with more than n lines, int
          -- colors = {}, -- table of hex strings
          -- termcolors = {}, -- table of colour name strings
        },
      }
    '';
  };
}
