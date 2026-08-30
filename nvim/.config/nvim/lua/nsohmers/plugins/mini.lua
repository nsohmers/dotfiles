return {
  {
    "echasnovski/mini.pairs",
    version = "*",
    event = { "InsertEnter" },
    opts = {},
  },
  {
    "echasnovski/mini.surround",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- mapped to match nvim-surround's mnemonic (ys/cs/ds) instead of mini's own sa/sd/sr default
      mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        update_n_lines = "",
        suffix_last = "",
        suffix_next = "",
      },
      search_method = "cover_or_next",
    },
  },
  {
    "echasnovski/mini.ai",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    -- provides the af/if/ac/ic/aa/ia textobjects; reads the query files shipped by
    -- nvim-treesitter-textobjects below without using that plugin's own keymaps/setup
    dependencies = { { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" } },
    config = function()
      local ai = require("mini.ai")
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
        },
      })
    end,
  },
}
