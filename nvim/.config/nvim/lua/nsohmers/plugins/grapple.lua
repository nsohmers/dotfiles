return {
  {
    "cbochs/grapple.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      scope = "git_branch", -- tags are scoped per git branch, like the old harpoon mark_branch setting
    },
    config = function(_, opts)
      require("grapple").setup(opts)

      local keymap = vim.keymap -- for conciseness

      keymap.set("n", "<leader>h", function() require("grapple").toggle() end,
        { desc = "Add/remove current buffer from grapple list" })
      keymap.set("n", "<leader>m", function() require("grapple").toggle_tags() end,
        { desc = "Show grapple list" })

      for i = 1, 9 do
        keymap.set("n", "<leader>" .. i, function() require("grapple").select({ index = i }) end,
          { desc = "Go to mark " .. i .. " in grapple list" })
      end

      -- Toggle previous & next buffers stored within the grapple list
      keymap.set("n", "<leader>p", function() require("grapple").cycle_tags("previous") end,
        { desc = "Go to previous mark in grapple list" })
      keymap.set("n", "<leader>n", function() require("grapple").cycle_tags("next") end,
        { desc = "Go to next mark in grapple list" })
    end,
  },
}
