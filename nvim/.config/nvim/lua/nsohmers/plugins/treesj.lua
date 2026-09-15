return {
  {
    "Wansmer/treesj",
    keys = {
      { "<leader>j", function() require("treesj").toggle() end, desc = "Toggle split/join node" },
    },
    opts = {
      use_default_keymaps = false,
      max_join_length = 150,
    },
  },
}
