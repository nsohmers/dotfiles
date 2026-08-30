return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")
      local keymap = vim.keymap

      -- hunk navigation
      keymap.set("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, { buffer = bufnr, desc = "Go to next git hunk" })

      keymap.set("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, { buffer = bufnr, desc = "Go to previous git hunk" })

      -- see the diff
      keymap.set("n", "<leader>gp", gitsigns.preview_hunk, { buffer = bufnr, desc = "Preview git hunk diff" })
      keymap.set("n", "<leader>gd", gitsigns.diffthis, { buffer = bufnr, desc = "Diff this file against index" })
      keymap.set("n", "<leader>gb", gitsigns.toggle_current_line_blame,
        { buffer = bufnr, desc = "Toggle git blame for current line" })

      -- stage / revert
      keymap.set({ "n", "v" }, "<leader>gs", gitsigns.stage_hunk, { buffer = bufnr, desc = "Stage git hunk" })
      keymap.set({ "n", "v" }, "<leader>gr", gitsigns.reset_hunk, { buffer = bufnr, desc = "Revert (reset) git hunk" })
      keymap.set("n", "<leader>gR", gitsigns.reset_buffer, { buffer = bufnr, desc = "Revert (reset) whole file" })
    end,
  },
}
