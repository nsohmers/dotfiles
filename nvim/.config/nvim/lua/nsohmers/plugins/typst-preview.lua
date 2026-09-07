return {
  "chomosuke/typst-preview.nvim",
  ft = "typst",
  version = "1.*",
  config = function()
    require("typst-preview").setup({})

    -- buffer-local so it can't shadow the global <leader>t* tab commands outside .typ files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "typst",
      callback = function(ev)
        vim.keymap.set("n", "<leader>tv", "<cmd>TypstPreviewToggle<cr>",
          { buffer = ev.buf, desc = "Toggle Typst preview" })
      end,
    })
  end,
}
