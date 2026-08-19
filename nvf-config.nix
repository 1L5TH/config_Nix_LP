{ pkgs, ... }:
{
  vim = {
    debugger.nvim-dap = {
      enable = true;
      ui.enable = true;
    };
    lineNumberMode = "number";
    clipboard.enable = true;
    clipboard.registers = "unnamedplus";
    theme = {
      enable = true;
      name = "tokyonight";
      style = "storm"; # Opciones: night, storm, day, moon
      transparent = true;
    };

    luaConfigRC.pre = ''
      -- 1. Detectar archivos .blade.php y asignarles el tipo de archivo "blade"
      vim.filetype.add({
        pattern = {
          ['.*%.blade%.php'] = 'blade',
        },
      })

      -- 2. Vincular a Treesitter para el resaltado inicial
      vim.treesitter.language.register("html", "blade")

      -- 3. Formatear automáticamente al guardar usando el ejecutable del sistema
      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = "*.blade.php",
        callback = function()
          -- Ejecuta blade-formatter de forma silenciosa sobre el archivo actual
          local file = vim.api.nvim_buf_get_name(0)
          vim.fn.system(string.format("${pkgs.blade-formatter}/bin/blade-formatter --write %s", vim.fn.shellescape(file)))
          -- Recarga el archivo para ver los cambios reflejados sin perder el cursor
          vim.cmd("checktime")
        end,
      })
    '';

    # Mantenemos Treesitter activo asegurando los parsers base
    treesitter = {
      enable = true;
      grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        html
        php
        blade # Agregamos el parser de blade si nvf lo soporta directamente en sus grammars
      ];
    };

    /*
      extraPlugins = with pkgs.vimPlugins; {
        gruvbox-plugin = {
          package = gruvbox-nvim;
          setup = ''
              require("gruvbox").setup({
              terminal_colors = true, -- add neovim terminal colors
              undercurl = true,
              underline = true,
              bold = true,
              italic = {
                strings = true,
                emphasis = true,
                comments = true,
                operators = false,
                folds = true,
              },
              strikethrough = true,
              invert_selection = false,
              invert_signs = false,
              invert_tabline = false,
              inverse = true, -- invert background for search, diffs, statuslines and errors
              contrast = "hard", -- can be "hard", "soft" or empty string
              palette_overrides = {},
              overrides = {},
              dim_inactive = false,
              transparent_mode = true,
            })
            vim.cmd("colorscheme gruvbox")
          '';
        };
      };
    */
    terminal.toggleterm = {
      enable = true;
      lazygit.enable = true;
      mappings = {
        open = "<A-i>";
      };
      setupOpts = {
        start_in_insert = true;
        direction = "float";
      };
    };
    options = {
      whichwrap = "h,l";
      #langmap = "fe,pr,gt,jy,lu,ui,yo,ñp,rs,sd,tf,dg,nj,ek,il,oñ,kn,FE,PR,GT,JY,LU,UI,YO,ÑP,RS,SD,TF,DG,NJ,EK,IL,OÑ,KN";
    };

    keymaps = [
      {
        key = "j";
        mode = "n";
        silent = true;
        action = "gj";
      }
      {
        key = "k";
        mode = "n";
        silent = true;
        action = "gk";
      }
      {
        key = "<C-S>";
        mode = "n";
        silent = true;
        action = ":update<CR>";
      }
      {
        key = "<leader>x";
        mode = "n";
        silent = true;
        action = ":bd<CR>";
      }
      {
        key = "<A-i>";
        mode = "t";
        silent = true;
        action = "<cmd>ToggleTerm<CR>";
      }
    ];

    statusline.lualine.enable = true;
    telescope.enable = true;
    autocomplete.nvim-cmp.enable = true;

    lsp = {
      formatOnSave = true;
      mappings = {
        format = "<leader>fm";
      };
      enable = true;
    };

    languages = {
      enableFormat = true;
      enableExtraDiagnostics = true;
      enableTreesitter = true;
      enableDAP = true;

      nix = {
        enable = true;
        format = {
          enable = true;
          type = [ "nixfmt" ];
        };
      };
      rust.enable = true;
      clang.enable = true;
      bash.enable = true;
      python.enable = true;
      typst.enable = true;
      r.enable = true;

      html.enable = true;
      css.enable = true;
      typescript = {
        enable = true;
        extensions.ts-error-translator = {
          enable = true;
          setupOpts = {
            auto_attach = true;
            auto_override_publish_diagnostics = false;
          };
        };
      };

      php = {
        enable = true;
        lsp = {
          enable = true;
          # Se pasa como una lista de strings
          servers = [ "intelephense" ];
        };
      };
      java.enable = true;
      sql.enable = true;
    };

    diagnostics = {
      config = {
        virtual_lines = true;
        virtual_text = true;
      };
    };
    filetree.nvimTree = {
      enable = true;
      openOnSetup = false;
      mappings = {
        toggle = "<C-n>";
      };
      setupOpts.actions.open_file.quit_on_open = false;
    };
    tabline.nvimBufferline = {
      enable = true;
      mappings = {
        cycleNext = "<C-Tab>";
        cyclePrevious = "<C-S-Tab>";
      };
    };
    autopairs.nvim-autopairs.enable = true;
  };
}
