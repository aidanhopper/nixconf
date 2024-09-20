{ lib, config, ... }:

{

  options = {
    nvim.enable = lib.mkEnableOption "enable nvim";
  };

  config = lib.mkIf config.nvim.enable {

    programs.nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      colorschemes.onedark.enable = true;

      globals = {
        mapleader = " ";
        netrw_banner = false;
        wildmenu = true;
        wildmode = "longest:list,full";
        netrw_winsize = -25;
        netrw_liststyle = 3;
      };

      opts = {
        number = true;
        swapfile = false;
        cursorline = true;
        cursorcolumn = true;
        clipboard = "unnamedplus";
        relativenumber = true;
        expandtab = true;
        shiftwidth = 2;
        tabstop = 2;
        colorcolumn = "80";
        scrolloff = 8;
        signcolumn = "yes";
        hlsearch = false;
        showmatch = true;
        smartindent = true;
        incsearch = true;
        updatetime = 50;
      };

      plugins = {
        tmux-navigator.enable = true;
        telescope.enable = true;
        treesitter = {
          enable = true;
          settings = {
            auto_install = true;
            highlight.enable = true;
            indent.enable = true;
            incremental_selection.enable = true;
          };
        };
        lsp = {
          enable = true;
          servers = {
            clangd.enable = true;
            bashls.enable = true;
            nixd.enable = true;
            pylsp.enable = true;
            hls.enable = true;
          };
          keymaps = {
            lspBuf = {
              K = "hover";
              gD = "references";
              gd = "definition";
              gi = "implementation";
              gt = "type_definition";
            };
          };
        };
        cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            performance = {
              debounce = 60;
              fetchingTimeout = 200;
              maxViewEntries = 15;
            };
              sources = [
              { name = "nvim_lsp"; }
              { name = "path"; }
              { name = "buffer"; }
            ];
            mapping = {
              "<C-n>" = "cmp.mapping.select_next_item()";
              "<C-p>" = "cmp.mapping.select_prev_item()";
              "<C-e>" = "cmp.mapping.abort()";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
              "<C-u>" = "cmp.mapping.scroll_docs(-4)";
              "<C-d>" = "cmp.mapping.scroll_docs(4)";
            };
          };
        };
        cmp-nvim-lsp.enable = true;
        nvim-autopairs.enable = true;
        zen-mode = {
          enable = true;
          settings = {
            width = 80;
          };
        };
        undotree.enable = true;
        illuminate = { 
          enable = true; 
          providers = [
            "lsp"
            "treesitter"
            "regex"
          ];
        };
        trouble.enable = true;
        todo-comments.enable = true;
        neogen.enable = true;
        which-key = {
          enable = true;
          settings.delay = 500;
        };
      };

      keymaps = [
        {
          action = "<cmd>Telescope find_files<CR>";
          key = "<leader>pf";
          options = {
            silent = true;
          };
        }

        {
          action = "<cmd>Telescope git_commits<CR>";
          key = "<leader>pc";
          options = {
            silent = true;
          };
        }

        {
          action = "<cmd>Telescope live_grep<CR>";
          key = "<leader>pg";
          options = {
            silent = true;
          };
        }

        {
          action = "<cmd>w<CR>";
          key = "<leader>w";
        }

        {
          action = "<cmd>ZenMode<CR>";
          key = "<leader>zz";
          options = {
            silent = true;
          };
        }

        {
          action = "<cmd>Lexplore<CR>";
          key = "<leader>pv";
          options = {
            silent = true;
          };
        }

        {
          action = "<cmd>Trouble diagnostics<CR>";
          key = "<leader>pd";
          options = {
            silent = true;
          };
        }

        {
          action = "<cmd>lua vim.lsp.buf.format()<CR>";
          key = "<leader>f";
          options = {
            silent = true;
          };
        }

        {
          action = "<cmd>Neogen<CR>";
          key = "<leader>vdd";
          options = {
            silent = true;
          };
        }

        {
          action = "<cmd>Neogen func<CR>";
          key = "<leader>vdf";
          options = {
            silent = true;
          };
        }

        {
          action = "<cmd>Neogen type<CR>";
          key = "<leader>vdt";
          options = {
            silent = true;
          };
        }

        {
          action = "<cmd>Neogen file<CR>";
          key = "<leader>vdf";
          options = {
            silent = true;
          };
        }

        {
          action = "<cmd>Neogen class<CR>";
          key = "<leader>vdc";
          options = {
            silent = true;
          };
        }
      ];
    };

  };

}
