{
  plugins = {
    gitsigns = {
      enable = true;
      settings.signs = {
        add.text = "▎";
        change.text = "▎";
        delete.text = "▁";
        topdelete.text = "▔";
        changedelete.text = "▎";
        untracked.text = "▎";
      };
    };

    flash.enable = true;

    trouble = {
      enable = true;
      settings.modes.lsp.win.position = "right";
    };

    todo-comments.enable = true;
    persistence.enable = true;
    grug-far.enable = true;

    mini = {
      enable = true;
      mockDevIcons = true;
      modules = {
        icons = { };
        ai = {
          n_lines = 500;
        };
        pairs = { };
        surround = {
          mappings = {
            add = "gsa";
            delete = "gsd";
            find = "gsf";
            find_left = "gsF";
            highlight = "gsh";
            replace = "gsr";
            update_n_lines = "gsn";
          };
        };
      };
    };
  };
}
