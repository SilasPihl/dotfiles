{ inputs, pkgs, user, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    extraPackages = with pkgs; [ gotools gofumpt delve ];

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    editorconfig.enable = true;
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "macchiato";
        integrations = {
          cmp = true;
          gitsigns = true;
          nvimtree = true;
        };
        term_colors = true;
      };
    };
    opts = {
      autoindent = true;
      breakindent = true;
      cursorline = true;
      clipboard = "unnamedplus";
      expandtab = true;
      hlsearch = true;
      ignorecase = true;
      incsearch = true;
      number = true;
      relativenumber = false;
      scrolloff = 10;
      shiftwidth = 2;
      smartcase = true;
      smartindent = true;
      softtabstop = 2;
      swapfile = false;
      tabstop = 2;
      termguicolors = true;
      undofile = true;
      updatetime = 50; # Faster completion
      wrap = false;
    };

    keymaps = [
      {
        key = "<leader>lg";
        mode = [ "n" ];
        action = "<cmd>LazyGit<cr>";
        options = {
          desc = "Lazygit";
          silent = true;
        };
      }
    ];

    # ref: https://nix-community.github.io/nixvim/index.html
    plugins = {
      barbar = {
        enable = true;
        settings = {
          animation = true;
          clickable = true;
          insert_at_start = false;
          icons = {
            filetype = {
              enabled = true;
            };
            buffer_number = true;
          };
          maximum_length = 30;
        };
        keymaps = {
          previous = {
            key = "<C-n>";
            mode = ["n"];
          };
          next = {
            key = "<C-p>";
            mode = ["n"];
          };
        };
      };
      cmp-buffer.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp.enable = true;
      cmp_luasnip.enable = true;
      conform-nvim.enable = true;
      copilot-vim.enable = true;
      flash.enable = true;
      friendly-snippets.enable = true;
      gitsigns.enable = true;
      illuminate.enable = true;
      indent-blankline.enable = true;
      lazy.enable = true;
      lazygit = {
        enable = true;
        settings = {
          config_file_path = "/Users/${user}/dotfiles/themes/lazygit/theme.yml";
          use_custom_config_file_path = 1;
        };
      };
      lint.enable = true;
      lsp = {
        enable = true;
        servers = {
          gopls = {
            enable = true;
            autostart = true;
            package = null; # ref: https://github.com/nix-community/nixvim/discussions/1442
            extraOptions.settings.gopls = {
              gofumpt = true;
              codelenses = {
                gc_details = false;
                generate = true;
                regenerate_cgo = true;
                run_govulncheck = true;
                test = true;
                tidy = true;
                upgrade_dependency = true;
                vendor = true;
              };
              hints = {
                assignVariableTypes = true;
                compositeLiteralFields = true;
                compositeLiteralTypes = true;
                constantValues = true;
                functionTypeParameters = true;
                parameterNames = true;
                rangeVariableTypes = true;
              };
              analyses = {
                fieldalignment = true;
                nilness = true;
                unusedparams = true;
                unusedwrite = true;
                useany = true;
              };
              usePlaceholders = true;
              completeUnimported = true;
              staticcheck = true;
              directoryFilters = ["-.git" "-.vscode" "-.idea" "-.vscode-test" "-node_modules"];
              semanticTokens = true;
            };
          };
          yamlls.enable = true;
        };
      };
      lualine.enable = true;
      neo-tree = {
        enable = true;
        closeIfLastWindow = true;
        hideRootNode = true;
        window = {
          position = "left";
          width = 30;
        };
        filesystem = {
          followCurrentFile = {
            enabled = true;
          };
          filteredItems = {
            hideDotfiles = false;
            hideGitignored = false;
          };
        };
      };
      neoclip.enable = true;
      neoscroll = {
        enable = true;
        settings = {
          performance_mode = true;
        };
      };
      nix-develop.enable = true;
      nix.enable = true;
      nvim-autopairs.enable = true;
      mini.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "<leader>g" = {
            action = "live_grep";
            options = {
              desc = "Telescope Live Grep";
            };
          };
          "<leader>p" = {
            action = "find_files";
            options = {
              desc = "Telescope Find Files";
            };
          };
          "<leader>b" = {
            action = "buffers";
            options = {
              desc = "Telescope Buffers";
            };
          };
          "<leader>k" = {
            action = "keymaps";
            options = {
              desc = "Telescope Keymaps";
            };
          };
          "gd" = {
            action = "lsp_definitions";
            options = {
              desc = "Telescope LSP Definitions";
            };
          };
          "gr" = {
            action = "lsp_references";
            options = {
              desc = "Telescope LSP References";
            };
          };
        };
      };
      todo-comments.enable = true;
      tmux-navigator.enable = true;
      treesitter = {
        enable = true;
        settings = {
          auto_install = true;
          highlight = {
            enable = true;
          };
        };
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          go
          gomod
          gosum
          gowork
          json
          lua
          make
          markdown
          nix
          regex
          toml
          vim
          vimdoc
          xml
          yaml
        ];
      };
      transparent.enable = true;
      treesitter-context.enable = true;
      treesitter-textobjects.enable = true;
      trouble.enable = true;
      ts-autotag.enable = true;
      ts-context-commentstring.enable = true;
      web-devicons.enable = true;
      which-key.enable = true;
    };

  };
}
