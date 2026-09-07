return {
  "nvim-lua/plenary.nvim",
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    -- Ctrl+Alt (not plain Alt) since AeroSpace already claims plain alt-h/j/k/l
    -- for OS-window focus; see tmux.conf for the matching M-side bindings.
    -- mode = {"n", "t"}: without "t" these never fire from inside a :terminal
    -- split (e.g. a shell or Claude Code running in a split) since lazy.nvim's
    -- `keys` defaults to normal mode only.
    keys = {
      { "<C-A-h>",  "<cmd>TmuxNavigateLeft<cr>",     mode = { "n", "t" } },
      { "<C-A-j>",  "<cmd>TmuxNavigateDown<cr>",      mode = { "n", "t" } },
      { "<C-A-k>",  "<cmd>TmuxNavigateUp<cr>",        mode = { "n", "t" } },
      { "<C-A-l>",  "<cmd>TmuxNavigateRight<cr>",     mode = { "n", "t" } },
      { "<C-A-\\>", "<cmd>TmuxNavigatePrevious<cr>",  mode = { "n", "t" } },
    },
  }
}
