return {
  "saghen/blink.cmp",
  event = "InsertEnter",
  version = "1.*",
  dependencies = {
    "rafamadriz/friendly-snippets", -- useful snippets
  },
  opts = {
    completion = {
      documentation = { auto_show = true },
    },
    signature = { enabled = true },
    -- keeps the same keys as the old nvim-cmp setup
    keymap = {
      preset = "none",
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-space>"] = { "show", "fallback" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  },
  opts_extend = { "sources.default" },
}
