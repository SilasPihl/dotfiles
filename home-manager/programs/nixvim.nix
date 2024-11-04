{ inputs, pkgs, user, ... }:

{
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

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
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options = { desc = "Neotree"; };
      }
      {
        key = "<leader>g";
        mode = [ "n" ];
        action = "<cmd>LazyGit<CR>";
        options = { desc = "Lazygit"; };
      }
      {
        mode = "n";
        key = "<leader>t";
        action = ":FloatermToggle<CR>";
        options = { desc = "FloatermToggle"; };
      }
      {
        mode = "n";
        key = "<leader>z";
        action = "<cmd>Twilight<CR>";
        options = { desc = "Twilight"; };
      }
      {
        mode = "n";
        key = "<leader>Tf";
        action = "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>";
        options = { desc = "Test file"; };
      }
      {
        mode = "n";
        key = "<leader>Tfb";
        action =
          "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<CR>";
        options = { desc = "Test file with debugger"; };
      }
      {
        mode = "n";
        key = "<leader>Tn";
        action = "<cmd>lua require('neotest').run.run()<CR>";
        options = { desc = "Test nearest"; };
      }
      {
        mode = "n";
        key = "<leader>Tl";
        action = "<cmd>lua require('neotest').run.run_last()<CR>";
        options = { desc = "Test last"; };
      }
      {
        mode = "n";
        key = "<leader>Tlb";
        action =
          "<cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<CR>";
        options = { desc = "Test last with debugger"; };
      }
      {
        mode = "n";
        key = "<leader>Twf";
        action =
          "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<CR>";
        options = { desc = "Watch file"; };
      }
      {
        mode = "n";
        key = "<leader>Twf";
        action = "<cmd>lua require('neotest').summary.toggle()<CR>";
        options = { desc = "Summary toggle"; };
      }
    ];

    autoCmd = [{
      event = [ "BufWritePost" ];
      pattern = "*_test.go";
      command = '':lua require("neotest").run.run(vim.fn.expand("%")) '';
      desc = "Run Go tests on save for *_test.go files";
    }];

    # ref: https://nix-community.github.io/nixvim/index.html
    plugins = {
      barbar = {
        enable = true;
        settings = {
          animation = true;
          auto_hide = false;
          clickable = true;
          focus_on_close = "left";
          insert_at_end = false;
          insert_at_start = false;
          maximum_length = 30;
          maximum_padding = 2;
          minimum_padding = 1;
          no_name_title = "[No Name]";
        };
        keymaps = {
          close.key = "<C-c>";
          goTo1.key = "<C-1>";
          goTo2.key = "<C-2>";
          goTo3.key = "<C-3>";
          goTo4.key = "<C-4>";
          goTo5.key = "<C-5>";
          goTo6.key = "<C-6>";
          goTo7.key = "<C-7>";
          goTo8.key = "<C-8>";
          goTo9.key = "<C-9>";
          last.key = "<C-0>";
          previous.key = "<S-Tab>";
          next.key = "<Tab>";
          movePrevious.key = "<C-,>";
          moveNext.key = "<C-.>";
        };
      };
      cmp-buffer.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "nvim_lsp_signature_help"; }
            { name = "nvim_lsp_document_symbol"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
            { name = "cmdline"; }
            { name = "spell"; }
            { name = "dictionary"; }
            { name = "treesitter"; }
          ];
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" =
              "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
        };
      };
      cmp_luasnip.enable = true;
      conform-nvim.enable = true;
      copilot-vim.enable = true;
      flash.enable = true;
      floaterm = {
        enable = true;
        width = 0.8;
        height = 0.8;
        keymaps.toggle = "<leader>t";
      };
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
            package =
              null; # ref: https://github.com/nix-community/nixvim/discussions/1442
            extraOptions.settings.gopls = {
              buildFlags = [ "-tags=unit,integration" ];
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
              directoryFilters =
                [ "-.git" "-.vscode" "-.idea" "-.vscode-test" "-node_modules" ];
              semanticTokens = true;
            };
          };
          yamlls.enable = true;
        };
      };
      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
      };
      none-ls = {
        enable = true;
        enableLspFormat = true;
        sources.formatting.nixfmt.enable = true;
        sources.formatting.gofumpt.enable = true;
      };
      lualine.enable = true;
      neo-tree = {
        enable = true;
        autoCleanAfterSessionRestore = true;
        closeIfLastWindow = true;
        window = {
          position = "left";
          autoExpandWidth = true;
        };
        filesystem = {
          followCurrentFile.enabled = true;
          filteredItems = {
            hideHidden = false;
            hideDotfiles = false;
            forceVisibleInEmptyFolder = true;
            hideGitignored = false;
          };
        };
        defaultComponentConfigs = {
          diagnostics = {
            symbols = {
              hint = "";
              info = "";
              warn = "";
              error = "";
            };
            highlights = {
              hint = "DiagnosticSignHint";
              info = "DiagnosticSignInfo";
              warn = "DiagnosticSignWarn";
              error = "DiagnosticSignError";
            };
          };
        };
      };
      neoclip.enable = true;
      neotest = {
        enable = true;
        adapters.go = {
          enable = true;
          package = pkgs.vimPlugins.neotest-go;
          settings = { testFlags = [ "-tags=unit,integration" ]; };
        };
      };
      nix-develop.enable = true;
      nix.enable = true;
      noice.enable = true;
      notify.enable = true;
      nvim-autopairs.enable = true;
      mini.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "<leader>/" = {
            action = "live_grep";
            options = { desc = "Telescope Live Grep"; };
          };
          "<leader>p" = {
            action = "find_files";
            options = { desc = "Telescope Find Files"; };
          };
          "<leader>b" = {
            action = "buffers";
            options = { desc = "Telescope Buffers"; };
          };
          "<leader>k" = {
            action = "keymaps";
            options = { desc = "Telescope Keymaps"; };
          };
          "gd" = {
            action = "lsp_definitions";
            options = { desc = "Telescope LSP Definitions"; };
          };
          "gr" = {
            action = "lsp_references";
            options = { desc = "Telescope LSP References"; };
          };
        };
      };
      todo-comments.enable = true;
      tmux-navigator.enable = true;
      treesitter = {
        enable = true;
        settings = {
          auto_install = true;
          highlight = { enable = true; };
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
      trouble = {
        enable = true;
        settings = {
          auto_close = true;
          auto_fold = false;
          auto_open = false;
          auto_preview = false;
          auto_refresh = true;
        };
      };
      ts-autotag.enable = true;
      ts-context-commentstring.enable = true;
      twilight.enable = true;
      yanky = {
        enable = true;
        enableTelescope = true;
      };
      web-devicons.enable = true;
      which-key = {
        enable = true;
        settings = {
          delay = 200;
          expand = 1;
          notify = false;
          preset = false;
          replace = {
            desc = [
              [ "<space>" "SPACE" ]
              [ "<leader>" "SPACE" ]
              [ "<[cC][rR]>" "RETURN" ]
              [ "<[tT][aA][bB]>" "TAB" ]
              [ "<[bB][sS]>" "BACKSPACE" ]
            ];
          };
          spec = [
            {
              __unkeyed-1 = "<leader>b";
              group = "Buffers";
              icon = "󰓩 ";
            }
            {
              __unkeyed = "<leader>c";
              group = "Codesnap";
              icon = "󰄄 ";
              mode = "v";
            }
            {
              __unkeyed-1 = "<leader>bs";
              group = "Sort";
              icon = "󰒺 ";
            }
            {
              __unkeyed-1 = [
                {
                  __unkeyed-1 = "<leader>f";
                  group = "Normal Visual Group";
                }
                {
                  __unkeyed-1 = "<leader>f<tab>";
                  group = "Normal Visual Group in Group";
                }
              ];
              mode = [ "n" "v" ];
            }
            {
              __unkeyed-1 = "<leader>t";
              group = "Terminal";
            }
            {
              __unkeyed-1 = "<leader>e";
              group = "Neo-tree";
            }
            {
              __unkeyed-1 = "<leader>z";
              group = "Twilight";
            }
            {
              __unkeyed-1 = "<leader>T";
              group = "Test";
            }
            {
              __unkeyed-1 = "<leader>w";
              group = "windows";
              proxy = "<C-w>";
            }
            {
              __unkeyed-1 = "<leader>cS";
              __unkeyed-2 = "<cmd>CodeSnapSave<CR>";
              desc = "Save";
              mode = "v";
            }
            {
              __unkeyed-1 = "<leader>db";
              __unkeyed-2 = {
                __raw = ''
                  function()
                    require("dap").toggle_breakpoint()
                  end
                '';
              };
              desc = "Breakpoint toggle";
              mode = "n";
              silent = true;
            }
          ];
          win = { border = "single"; };
        };
      };
    };
  };
}
