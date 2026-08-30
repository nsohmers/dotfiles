return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    indent = { enabled = true, indent = { char = "┊" } },
    notifier = { enabled = true },
    picker = { enabled = true },
    terminal = { enabled = true },
    image = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        header = [[

    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
           __________
         .'----------`.
         | .--------. |
         | |########| |       __________
         | |########| |      /__________\
.--------| `--------' |------|    --=-- |-------------.
|        `----,-.-----'      |o ======  |             |
|       ______|_|_______     |__________|             |
|      /  %%%%%%%%%%%%  \                            |
|     /  %%%%%%%%%%%%%%  \                           |
|     ^^^^^^^^^^^^^^^^^^^^                            |
+-----------------------------------------------------+
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ]],
        keys = {
          { icon = " ", key = "e", desc = "New File", action = ":ene" },
          { icon = " ", key = "-", desc = "Toggle file explorer", action = ":Oil" },
          { icon = "󰱼 ", key = "f", desc = "Find File", action = function() Snacks.picker.files() end },
          { icon = " ", key = "g", desc = "Find Word", action = function() Snacks.picker.grep() end },
          { icon = "󰁯  ", key = "r", desc = "Restore Session For Current Directory", action = ":SessionRestore" },
          { icon = " ", key = "q", desc = "Quit NVIM", action = ":qa" },
        },
      },
    },
  },
  keys = {
    { "<leader><leader>", function() Snacks.picker.smart() end, desc = "Smart find files (recent/frecency)" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Fuzzy find files in cwd" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Fuzzy find recent files" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep string in files" },
    { "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "Find document symbols" },
    { "<leader>fc", function() Snacks.picker.grep_word() end, desc = "Find string under cursor in cwd" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find files in buffers" },
    { "<leader>tt", function() Snacks.terminal.toggle() end, desc = "Toggle floating terminal" },
  },
}
