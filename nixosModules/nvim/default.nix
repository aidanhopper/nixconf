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
        netrw_keepdir = 0;
        netrw_winsize = 30;
        wildmenu = true;
        wildmode = "longest:list,full";
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
        lazygit.enable = true;
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
          action = "<cmd>Ex<CR>";
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
      ];
    };

  };

}
