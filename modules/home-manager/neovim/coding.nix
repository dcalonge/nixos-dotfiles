{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs; [
      clang-tools
      nixfmt
      prettier
      shfmt
      stylua
    ];

    plugins = {
      treesitter = {
        enable = true;
        highlight.enable = true;
        indent.enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          c
          cpp
          diff
          html
          javascript
          jsdoc
          json
          lua
          luadoc
          markdown
          markdown_inline
          nix
          printf
          python
          query
          regex
          toml
          tsx
          typescript
          vim
          vimdoc
          xml
          yaml
        ];
      };

      ts-comments.enable = true;
      lazydev.enable = true;
      friendly-snippets.enable = true;

      render-markdown = {
        enable = true;
        settings = {
          code = {
            sign = false;
            width = "block";
            right_pad = 1;
          };
          heading.sign = false;
          checkbox.enabled = false;
        };
      };
      markdown-preview.enable = true;

      blink-cmp = {
        enable = true;
        settings = {
          keymap.preset = "enter";
          completion = {
            menu.draw.treesitter = [ "lsp" ];
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 200;
            };
          };
          sources = {
            per_filetype.lua = [
              "lazydev"
              "lsp"
              "path"
              "snippets"
              "buffer"
            ];
            providers.lazydev = {
              name = "LazyDev";
              module = "lazydev.integrations.blink";
              score_offset = 100;
            };
          };
        };
      };

      conform-nvim = {
        enable = true;
        settings = {
          formatters_by_ft = {
            lua = [ "stylua" ];
            sh = [ "shfmt" ];
            bash = [ "shfmt" ];
            nix = [ "nixfmt" ];
            python = [
              "ruff_organize_imports"
              "ruff_format"
            ];
            c = [ "clang-format" ];
            cpp = [ "clang-format" ];
            markdown = [ "prettier" ];
          };
          format_on_save = {
            timeout_ms = 3000;
            lsp_format = "fallback";
          };
        };
      };
    };

    lsp = {
      inlayHints.enable = true;

      servers = {
        lua_ls = {
          enable = true;
          config.settings.Lua = {
            workspace.checkThirdParty = false;
            completion.callSnippet = "Replace";
            doc.privateName = [ "^_" ];
            hint = {
              enable = true;
              setType = false;
              paramType = true;
              paramName = "Disable";
              semicolon = "Disable";
              arrayIndex = "Disable";
            };
          };
        };
        bashls.enable = true;
        nixd.enable = true;
        pyright.enable = true;
        ruff.enable = true;
        clangd.enable = true;
        marksman.enable = true;
      };

      keymaps = [
        {
          key = "gd";
          action = "<cmd>lua Snacks.picker.lsp_definitions()<cr>";
          options.desc = "Goto Definition";
        }
        {
          key = "gr";
          action = "<cmd>lua Snacks.picker.lsp_references()<cr>";
          options = {
            desc = "References";
            nowait = true;
          };
        }
        {
          key = "gI";
          action = "<cmd>lua Snacks.picker.lsp_implementations()<cr>";
          options.desc = "Goto Implementation";
        }
        {
          key = "gy";
          action = "<cmd>lua Snacks.picker.lsp_type_definitions()<cr>";
          options.desc = "Goto T[y]pe Definition";
        }
        {
          key = "gD";
          lspBufAction = "declaration";
          options.desc = "Goto Declaration";
        }
        {
          key = "gK";
          lspBufAction = "signature_help";
          options.desc = "Signature Help";
        }
        {
          mode = "i";
          key = "<c-k>";
          lspBufAction = "signature_help";
          options.desc = "Signature Help";
        }
        {
          mode = [
            "n"
            "x"
          ];
          key = "<leader>ca";
          lspBufAction = "code_action";
          options.desc = "Code Action";
        }
        {
          key = "<leader>cr";
          lspBufAction = "rename";
          options.desc = "Rename";
        }
      ];
    };
  };
}
