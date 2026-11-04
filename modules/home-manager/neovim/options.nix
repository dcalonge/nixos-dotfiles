{
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = "\\";
    };

    opts = {
      autowrite = true;
      clipboard = "unnamedplus";
      completeopt = "menu,menuone,noselect";
      conceallevel = 2;
      confirm = true;
      cursorline = true;
      expandtab = true;
      fillchars = "fold: ,foldsep: ,diff:╱,eob: ";
      foldlevel = 99;
      formatoptions = "jcroqlnt";
      grepformat = "%f:%l:%c:%m";
      grepprg = "rg --vimgrep";
      ignorecase = true;
      inccommand = "nosplit";
      jumpoptions = "view";
      laststatus = 3;
      linebreak = true;
      list = true;
      mouse = "a";
      number = true;
      pumblend = 10;
      pumheight = 10;
      relativenumber = true;
      ruler = false;
      scrolloff = 4;
      sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds";
      shiftround = true;
      shiftwidth = 2;
      showmode = false;
      sidescrolloff = 8;
      signcolumn = "yes";
      smartcase = true;
      smartindent = true;
      smoothscroll = true;
      spelllang = "en";
      splitbelow = true;
      splitkeep = "screen";
      splitright = true;
      tabstop = 2;
      termguicolors = true;
      timeoutlen = 300;
      undofile = true;
      undolevels = 10000;
      updatetime = 200;
      virtualedit = "block";
      wildmode = "longest:full,full";
      winminwidth = 5;
      wrap = false;
    };

    diagnostic.settings = {
      underline = true;
      update_in_insert = false;
      severity_sort = true;
      virtual_text = {
        spacing = 4;
        source = "if_many";
        prefix = "●";
      };
    };

    autoGroups = {
      highlight_yank.clear = true;
      resize_splits.clear = true;
      last_loc.clear = true;
      close_with_q.clear = true;
      auto_create_dir.clear = true;
    };

    autoCmd = [
      {
        event = "TextYankPost";
        group = "highlight_yank";
        callback.__raw = "function() (vim.hl or vim.highlight).on_yank() end";
      }
      {
        event = "VimResized";
        group = "resize_splits";
        callback.__raw = ''
          function()
            local current_tab = vim.fn.tabpagenr()
            vim.cmd("tabdo wincmd =")
            vim.cmd("tabnext " .. current_tab)
          end
        '';
      }
      {
        event = "BufReadPost";
        group = "last_loc";
        callback.__raw = ''
          function(event)
            local buf = event.buf
            local mark = vim.api.nvim_buf_get_mark(buf, '"')
            local lcount = vim.api.nvim_buf_line_count(buf)
            if mark[1] > 0 and mark[1] <= lcount then
              pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
          end
        '';
      }
      {
        event = "FileType";
        group = "close_with_q";
        pattern = [
          "help"
          "lspinfo"
          "man"
          "qf"
          "checkhealth"
          "notify"
        ];
        callback.__raw = ''
          function(event)
            vim.bo[event.buf].buflisted = false
            vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
          end
        '';
      }
      {
        event = "BufWritePre";
        group = "auto_create_dir";
        callback.__raw = ''
          function(event)
            if event.match:match("^%w%w+:[\\/][\\/]") then
              return
            end
            local file = vim.uv.fs_realpath(event.match) or event.match
            vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
          end
        '';
      }
    ];
  };
}
