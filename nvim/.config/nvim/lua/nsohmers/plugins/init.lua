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
    keys = {
      { "<C-A-h>",  "<cmd>TmuxNavigateLeft<cr>" },
      { "<C-A-j>",  "<cmd>TmuxNavigateDown<cr>" },
      { "<C-A-k>",  "<cmd>TmuxNavigateUp<cr>" },
      { "<C-A-l>",  "<cmd>TmuxNavigateRight<cr>" },
      { "<C-A-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
    },
  }
}
