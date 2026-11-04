{
  programs.nixvim.plugins = {
    snacks = {
      enable = true;
      settings = {
        bigfile.enabled = true;
        dashboard = {
          enabled = true;
          sections = [
            { section = "header"; }
            { section = "keys"; gap = 1; padding = 1; }
          ];
        };
        explorer.enabled = true;
        indent.enabled = true;
        input.enabled = true;
        notifier = {
          enabled = true;
          timeout = 3000;
        };
        picker.enabled = true;
        quickfile.enabled = true;
        scope.enabled = true;
        scroll.enabled = true;
        statuscolumn.enabled = true;
        words.enabled = true;
        styles.notification.wo.wrap = true;
      };
    };

    which-key = {
      enable = true;
      settings = {
        preset = "helix";
        spec = [
          {
            __unkeyed-1 = "<leader><tab>";
            group = "tabs";
          }
          {
            __unkeyed-1 = "<leader>b";
            group = "buffer";
          }
          {
            __unkeyed-1 = "<leader>c";
            group = "code";
            mode = [
              "n"
              "x"
            ];
          }
          {
            __unkeyed-1 = "<leader>f";
            group = "file/find";
          }
          {
            __unkeyed-1 = "<leader>g";
            group = "git";
          }
          {
            __unkeyed-1 = "<leader>gh";
            group = "hunks";
          }
          {
            __unkeyed-1 = "<leader>q";
            group = "quit/session";
          }
          {
            __unkeyed-1 = "<leader>s";
            group = "search";
          }
          {
            __unkeyed-1 = "<leader>u";
            group = "ui";
          }
          {
            __unkeyed-1 = "<leader>w";
            group = "windows";
          }
          {
            __unkeyed-1 = "<leader>x";
            group = "diagnostics/quickfix";
          }
          {
            __unkeyed-1 = "[";
            group = "prev";
          }
          {
            __unkeyed-1 = "]";
            group = "next";
          }
          {
            __unkeyed-1 = "g";
            group = "goto";
          }
          {
            __unkeyed-1 = "gs";
            group = "surround";
          }
          {
            __unkeyed-1 = "z";
            group = "fold";
          }
        ];
      };
    };

    lualine = {
      enable = true;
      settings = {
        options = {
          theme = "auto";
          globalstatus = true;
          disabled_filetypes.statusline = [
            "dashboard"
            "alpha"
            "ministarter"
            "snacks_dashboard"
          ];
        };
        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [ "branch" ];
          lualine_c = [
            "diagnostics"
            {
              __unkeyed-1 = "filetype";
              icon_only = true;
              separator = "";
              padding = {
                left = 1;
                right = 0;
              };
            }
            {
              __unkeyed-1 = "filename";
              path = 1;
            }
          ];
          lualine_x = [ "diff" ];
          lualine_y = [ "progress" ];
          lualine_z = [ "location" ];
        };
      };
    };

    bufferline = {
      enable = true;
      settings.options = {
        close_command.__raw = "function(n) Snacks.bufdelete(n) end";
        right_mouse_command.__raw = "function(n) Snacks.bufdelete(n) end";
        diagnostics = "nvim_lsp";
        always_show_bufferline = false;
        offsets = [
          {
            filetype = "snacks_layout_box";
          }
        ];
      };
    };

    nui.enable = true;
    noice = {
      enable = true;
      settings = {
        lsp.override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.stylize_markdown" = true;
        };
        routes = [
          {
            filter = {
              event = "msg_show";
              any = [
                { find = "%d+L, %d+B"; }
                { find = "; after #%d+"; }
                { find = "; before #%d+"; }
              ];
            };
            view = "mini";
          }
        ];
        presets = {
          bottom_search = true;
          command_palette = true;
          long_message_to_split = true;
        };
      };
    };
  };
}
