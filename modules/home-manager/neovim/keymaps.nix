let
  map = mode: key: action: desc: {
    inherit mode key action;
    options = {
      inherit desc;
      silent = true;
    };
  };
  n = map "n";
  lua = code: "<cmd>lua ${code}<cr>";
  snacks = code: lua "Snacks.${code}";
  picker = name: snacks "picker.${name}()";
  remap = keymap: keymap // { options = keymap.options // { remap = true; }; };
  expr = keymap: keymap // { options = keymap.options // { expr = true; }; };
in
{
  programs.nixvim.keymaps = [
    (expr (map [ "n" "x" ] "j" "v:count == 0 ? 'gj' : 'j'" "Down"))
    (expr (map [ "n" "x" ] "<Down>" "v:count == 0 ? 'gj' : 'j'" "Down"))
    (expr (map [ "n" "x" ] "k" "v:count == 0 ? 'gk' : 'k'" "Up"))
    (expr (map [ "n" "x" ] "<Up>" "v:count == 0 ? 'gk' : 'k'" "Up"))

    (remap (n "<C-h>" "<C-w>h" "Go to Left Window"))
    (remap (n "<C-j>" "<C-w>j" "Go to Lower Window"))
    (remap (n "<C-k>" "<C-w>k" "Go to Upper Window"))
    (remap (n "<C-l>" "<C-w>l" "Go to Right Window"))

    (n "<C-Up>" "<cmd>resize +2<cr>" "Increase Window Height")
    (n "<C-Down>" "<cmd>resize -2<cr>" "Decrease Window Height")
    (n "<C-Left>" "<cmd>vertical resize -2<cr>" "Decrease Window Width")
    (n "<C-Right>" "<cmd>vertical resize +2<cr>" "Increase Window Width")

    (n "<A-j>" "<cmd>execute 'move .+' . v:count1<cr>==" "Move Down")
    (n "<A-k>" "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==" "Move Up")
    (map "i" "<A-j>" "<esc><cmd>m .+1<cr>==gi" "Move Down")
    (map "i" "<A-k>" "<esc><cmd>m .-2<cr>==gi" "Move Up")
    (map "v" "<A-j>" ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv" "Move Down")
    (map "v" "<A-k>" ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv" "Move Up")

    (n "<S-h>" "<cmd>bprevious<cr>" "Prev Buffer")
    (n "<S-l>" "<cmd>bnext<cr>" "Next Buffer")
    (n "<leader>bb" "<cmd>e #<cr>" "Switch to Other Buffer")
    (n "<leader>`" "<cmd>e #<cr>" "Switch to Other Buffer")
    (n "<leader>bd" (snacks "bufdelete()") "Delete Buffer")
    (n "<leader>bo" (snacks "bufdelete.other()") "Delete Other Buffers")
    (n "<leader>bD" "<cmd>:bd<cr>" "Delete Buffer and Window")

    (map [ "i" "n" ] "<esc>" "<cmd>noh<cr><esc>" "Escape and Clear hlsearch")
    (n "<leader>ur" "<cmd>nohlsearch<bar>diffupdate<bar>normal! <C-L><cr>" "Redraw / Clear hlsearch / Diff Update")

    (expr (map "n" "n" "'Nn'[v:searchforward].'zv'" "Next Search Result"))
    (expr (map [ "x" "o" ] "n" "'Nn'[v:searchforward]" "Next Search Result"))
    (expr (map "n" "N" "'nN'[v:searchforward].'zv'" "Prev Search Result"))
    (expr (map [ "x" "o" ] "N" "'nN'[v:searchforward]" "Prev Search Result"))

    (map "i" "," ",<c-g>u" "Undo break-point")
    (map "i" "." ".<c-g>u" "Undo break-point")
    (map "i" ";" ";<c-g>u" "Undo break-point")

    (map [ "i" "x" "n" "s" ] "<C-s>" "<cmd>w<cr><esc>" "Save File")
    (n "<leader>K" "<cmd>norm! K<cr>" "Keywordprg")

    (map "v" "<" "<gv" "Indent Left")
    (map "v" ">" ">gv" "Indent Right")

    (n "gco" "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>" "Add Comment Below")
    (n "gcO" "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>" "Add Comment Above")

    (n "<leader>fn" "<cmd>enew<cr>" "New File")
    (n "<leader>xl" "<cmd>lopen<cr>" "Location List")
    (n "<leader>xq" "<cmd>copen<cr>" "Quickfix List")

    (n "<leader>cd" (lua "vim.diagnostic.open_float()") "Line Diagnostics")
    (n "]d" (lua "vim.diagnostic.jump({ count = 1, float = true })") "Next Diagnostic")
    (n "[d" (lua "vim.diagnostic.jump({ count = -1, float = true })") "Prev Diagnostic")
    (n "]e" (lua "vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })") "Next Error")
    (n "[e" (lua "vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })") "Prev Error")
    (n "]w" (lua "vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN, float = true })") "Next Warning")
    (n "[w" (lua "vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN, float = true })") "Prev Warning")

    (n "<leader>qq" "<cmd>qa<cr>" "Quit All")
    (n "<leader>ui" "<cmd>Inspect<cr>" "Inspect Pos")
    (n "<leader>uI" "<cmd>InspectTree<cr>" "Inspect Tree")

    (remap (n "<leader>-" "<C-W>s" "Split Window Below"))
    (remap (n "<leader>|" "<C-W>v" "Split Window Right"))
    (remap (n "<leader>wd" "<C-W>c" "Delete Window"))

    (n "<leader><tab>l" "<cmd>tablast<cr>" "Last Tab")
    (n "<leader><tab>o" "<cmd>tabonly<cr>" "Close Other Tabs")
    (n "<leader><tab>f" "<cmd>tabfirst<cr>" "First Tab")
    (n "<leader><tab><tab>" "<cmd>tabnew<cr>" "New Tab")
    (n "<leader><tab>]" "<cmd>tabnext<cr>" "Next Tab")
    (n "<leader><tab>d" "<cmd>tabclose<cr>" "Close Tab")
    (n "<leader><tab>[" "<cmd>tabprevious<cr>" "Previous Tab")

    (n "<leader><space>" (picker "files") "Find Files")
    (n "<leader>," (picker "buffers") "Buffers")
    (n "<leader>/" (picker "grep") "Grep")
    (n "<leader>:" (picker "command_history") "Command History")
    (n "<leader>n" (snacks "picker.notifications()") "Notification History")
    (n "<leader>e" (snacks "explorer()") "File Explorer")

    (n "<leader>fb" (picker "buffers") "Buffers")
    (n "<leader>fc" (lua "Snacks.picker.files({ cwd = vim.fn.stdpath('config') })") "Find Config File")
    (n "<leader>ff" (picker "files") "Find Files")
    (n "<leader>fg" (picker "git_files") "Find Files (git-files)")
    (n "<leader>fr" (picker "recent") "Recent")
    (n "<leader>fp" (picker "projects") "Projects")
    (n "<leader>fe" (snacks "explorer()") "File Explorer")

    (n "<leader>gc" (picker "git_log") "Git Log")
    (n "<leader>gs" (picker "git_status") "Git Status")
    (n "<leader>gd" (picker "git_diff") "Git Diff (hunks)")
    (n "<leader>gg" (snacks "lazygit()") "Lazygit")
    (n "<leader>gb" (snacks "git.blame_line()") "Git Blame Line")
    (map [ "n" "x" ] "<leader>gB" (snacks "gitbrowse()") "Git Browse (open)")

    (n "<leader>s\"" (picker "registers") "Registers")
    (n "<leader>s/" (picker "search_history") "Search History")
    (n "<leader>sa" (picker "autocmds") "Autocmds")
    (n "<leader>sb" (picker "lines") "Buffer Lines")
    (n "<leader>sc" (picker "command_history") "Command History")
    (n "<leader>sC" (picker "commands") "Commands")
    (n "<leader>sd" (picker "diagnostics") "Diagnostics")
    (n "<leader>sD" (picker "diagnostics_buffer") "Buffer Diagnostics")
    (n "<leader>sg" (picker "grep") "Grep")
    (n "<leader>sh" (picker "help") "Help Pages")
    (n "<leader>sH" (picker "highlights") "Highlights")
    (n "<leader>sj" (picker "jumps") "Jumps")
    (n "<leader>sk" (picker "keymaps") "Keymaps")
    (n "<leader>sm" (picker "marks") "Marks")
    (n "<leader>sM" (picker "man") "Man Pages")
    (n "<leader>sq" (picker "qflist") "Quickfix List")
    (n "<leader>sR" (picker "resume") "Resume")
    (n "<leader>ss" (picker "lsp_symbols") "LSP Symbols")
    (n "<leader>sS" (picker "lsp_workspace_symbols") "LSP Workspace Symbols")
    (n "<leader>su" (picker "undo") "Undo History")
    (map [ "n" "x" ] "<leader>sw" (picker "grep_word") "Visual selection or word")

    (n "<leader>uC" (picker "colorschemes") "Colorschemes")
    (n "<leader>un" (snacks "notifier.hide()") "Dismiss All Notifications")
    (n "<leader>cR" (snacks "rename.rename_file()") "Rename File")
    (map [ "n" "t" ] "<c-/>" (snacks "terminal()") "Terminal (Root Dir)")
    (map [ "n" "t" ] "<c-_>" (snacks "terminal()") "which_key_ignore")
    (n "]]" (snacks "words.jump(vim.v.count1)") "Next Reference")
    (n "[[" (snacks "words.jump(-vim.v.count1)") "Prev Reference")

    (n "<leader>bp" "<cmd>BufferLineTogglePin<cr>" "Toggle Pin")
    (n "<leader>bP" "<cmd>BufferLineGroupClose ungrouped<cr>" "Delete Non-Pinned Buffers")
    (n "<leader>br" "<cmd>BufferLineCloseRight<cr>" "Delete Buffers to the Right")
    (n "<leader>bl" "<cmd>BufferLineCloseLeft<cr>" "Delete Buffers to the Left")
    (n "[B" "<cmd>BufferLineMovePrev<cr>" "Move Buffer Prev")
    (n "]B" "<cmd>BufferLineMoveNext<cr>" "Move Buffer Next")

    (n "<leader>ghs" "<cmd>Gitsigns stage_hunk<cr>" "Stage Hunk")
    (n "<leader>ghr" "<cmd>Gitsigns reset_hunk<cr>" "Reset Hunk")
    (n "<leader>ghS" "<cmd>Gitsigns stage_buffer<cr>" "Stage Buffer")
    (n "<leader>ghu" "<cmd>Gitsigns undo_stage_hunk<cr>" "Undo Stage Hunk")
    (n "<leader>ghR" "<cmd>Gitsigns reset_buffer<cr>" "Reset Buffer")
    (n "<leader>ghp" "<cmd>Gitsigns preview_hunk_inline<cr>" "Preview Hunk Inline")
    (n "<leader>ghb" (lua "require('gitsigns').blame_line({ full = true })") "Blame Line")
    (n "<leader>ghd" "<cmd>Gitsigns diffthis<cr>" "Diff This")
    (n "]h" (lua "require('gitsigns').nav_hunk('next')") "Next Hunk")
    (n "[h" (lua "require('gitsigns').nav_hunk('prev')") "Prev Hunk")

    (map [ "n" "x" "o" ] "s" (lua "require('flash').jump()") "Flash")
    (map [ "n" "x" "o" ] "S" (lua "require('flash').treesitter()") "Flash Treesitter")
    (map "o" "r" (lua "require('flash').remote()") "Remote Flash")
    (map [ "o" "x" ] "R" (lua "require('flash').treesitter_search()") "Treesitter Search")
    (map "c" "<c-s>" (lua "require('flash').toggle()") "Toggle Flash Search")

    (n "<leader>xx" "<cmd>Trouble diagnostics toggle<cr>" "Diagnostics (Trouble)")
    (n "<leader>xX" "<cmd>Trouble diagnostics toggle filter.buf=0<cr>" "Buffer Diagnostics (Trouble)")
    (n "<leader>cs" "<cmd>Trouble symbols toggle<cr>" "Symbols (Trouble)")
    (n "<leader>cS" "<cmd>Trouble lsp toggle<cr>" "LSP references/definitions/... (Trouble)")
    (n "<leader>xL" "<cmd>Trouble loclist toggle<cr>" "Location List (Trouble)")
    (n "<leader>xQ" "<cmd>Trouble qflist toggle<cr>" "Quickfix List (Trouble)")

    (n "]t" (lua "require('todo-comments').jump_next()") "Next Todo Comment")
    (n "[t" (lua "require('todo-comments').jump_prev()") "Previous Todo Comment")
    (n "<leader>xt" "<cmd>Trouble todo toggle<cr>" "Todo (Trouble)")
    (n "<leader>xT" "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>" "Todo/Fix/Fixme (Trouble)")
    (n "<leader>st" (snacks "picker.todo_comments()") "Todo")

    (n "<leader>qs" (lua "require('persistence').load()") "Restore Session")
    (n "<leader>qS" (lua "require('persistence').select()") "Select Session")
    (n "<leader>ql" (lua "require('persistence').load({ last = true })") "Restore Last Session")
    (n "<leader>qd" (lua "require('persistence').stop()") "Don't Save Current Session")

    (map [ "n" "x" ] "<leader>sr" (lua "require('grug-far').open({ transient = true })") "Search and Replace")

    (map [ "n" "x" ] "<leader>cf" (lua "require('conform').format({ lsp_format = 'fallback' })") "Format")
    (n "<leader>cp" "<cmd>MarkdownPreviewToggle<cr>" "Markdown Preview")
  ];
}
