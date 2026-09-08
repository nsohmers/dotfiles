return {
  "folke/sidekick.nvim",
  opts = {
    -- Next Edit Suggestions (AI ghost-text edit hints, accepted with <Tab>). blink.cmp already
    -- owns <Tab> for completion cycling, so the two are chained in blink.lua's keymap instead of
    -- fighting over the key: cmp menu selection first, then nes_jump_or_apply, then normal <Tab>.
    nes = { enabled = true },
    cli = {
      mux = {
        backend = "tmux", -- agent terminals survive nvim restarts via a tmux pane
        enabled = true,
      },
    },
  },
  keys = {
    {
      "<leader>aa",
      function() require("sidekick.cli").select() end,
      desc = "Sidekick: pick an agent CLI to toggle",
    },
    {
      "<leader>ai",
      function() require("sidekick.cli").toggle({ name = "claude" }) end,
      desc = "Sidekick: toggle Claude agent terminal",
    },
    {
      "<leader>ac",
      function() require("sidekick.cli").toggle({ name = "codex" }) end,
      desc = "Sidekick: toggle Codex agent terminal",
    },
    {
      "<leader>as",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = { "n", "v" },
      desc = "Sidekick: send selection to the focused agent",
    },
    {
      "<leader>af",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
      desc = "Sidekick: send whole file to the focused agent",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "v" },
      desc = "Sidekick: pick from the prompt library (explain, fix, write tests, ...)",
    },
  },
}
