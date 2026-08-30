return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    -- automatic_enable calls vim.lsp.enable() for every installed server,
    -- picking up whatever config was registered via vim.lsp.config() in lspconfig.lua
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "clangd",
        "jdtls",
        "pyright",
        "marksman",
      },
      automatic_enable = true,
    })
  end,
}
