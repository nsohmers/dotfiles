# Keybindings reference

`<leader>` is `Space` in Neovim. tmux `prefix` is the default `C-b`. This covers everything as of
the nvim/tmux modernization pass — press `<leader>` and wait in Neovim to get a live which-key
popup of most of these instead of coming back to this file.

## Neovim

### Navigation (grapple pins)
| Key | Action |
|---|---|
| `<leader>h` | Add/remove current buffer from the grapple list |
| `<leader>m` | Open the grapple list menu |
| `<leader>1`-`9` | Jump to grapple mark 1-9 |
| `<leader>n` / `<leader>p` | Cycle to next/previous grapple mark |
| `<C-^>` | Jump to alternate (last) buffer *(built-in)* |

### Finding things (Snacks picker)
| Key | Action |
|---|---|
| `<leader><leader>` | Smart picker (recent files, frecency-sorted) — your default jump |
| `<leader>ff` | Find files in cwd |
| `<leader>fr` | Find recent files |
| `<leader>fg` | Grep string in files |
| `<leader>fc` | Grep the word under cursor |
| `<leader>fs` | Find document symbols |
| `<leader>fb` | Find open buffers |
| `<leader>tt` | Toggle a floating terminal |

### LSP (active once a language server attaches to the buffer)
| Key | Action |
|---|---|
| `K` | Hover documentation |
| `gd` | Go to definition (picker) |
| `gD` | Go to declaration |
| `gi` | Go to implementation (picker) |
| `gt` | Go to type definition (picker) |
| `gR` | Show references (picker) |
| `<leader>ca` | Code actions (normal + visual) |
| `<leader>rn` | Rename symbol |
| `<leader>d` | Show line diagnostics (float) |
| `<leader>D` | Show buffer diagnostics (picker) |
| `[d` / `]d` | Previous/next diagnostic |
| `<leader>dv` | Toggle diagnostic virtual-lines vs virtual-text |
| `<leader>rs` | Restart the LSP client(s) attached to this buffer |

### Editing
| Key | Action |
|---|---|
| `ys{motion}{char}` | Add surround (mini.surround) |
| `cs{old}{new}` | Change surround |
| `ds{char}` | Delete surround |
| `af` / `if` | Around/inside function (treesitter) |
| `ac` / `ic` | Around/inside class (treesitter) |
| `aa` / `ia` | Around/inside argument/parameter (treesitter) |
| `<` / `>` (visual) | Indent/dedent and reselect |
| `<leader>+` / `<leader>-` | Increment/decrement number under cursor |
| `<leader>z` (normal or visual) | Format file or selection (conform.nvim) |
| `s` / `S` | Flash jump / Flash treesitter jump |
| `-` | Open Oil (file explorer as a buffer) |

### Git (gitsigns)
| Key | Action |
|---|---|
| `]c` / `[c` | Next/previous git hunk |
| `<leader>gp` | Preview hunk diff |
| `<leader>gd` | Diff file against index |
| `<leader>gb` | Toggle current-line git blame |
| `<leader>gs` | Stage hunk (normal or visual) |
| `<leader>gr` | Revert (reset) hunk (normal or visual) |
| `<leader>gR` | Revert (reset) the whole file |
| `prefix+g` (tmux) | Full lazygit UI in a popup |

### AI agents (sidekick.nvim)
| Key | Action |
|---|---|
| `<leader>aa` | Pick an agent CLI to toggle (Claude, Codex, …) |
| `<leader>ai` | Toggle the Claude agent terminal |
| `<leader>ac` | Toggle the Codex agent terminal |
| `<leader>as` | Send the current selection to the focused agent |
| `<leader>af` | Send the whole file to the focused agent |
| `<leader>ap` | Pick from the prompt library (explain, fix, write tests, …) |

Next Edit Suggestions (inline ghost-text, Copilot-style) are turned off — its default accept key
is `<Tab>`, which blink.cmp already owns for completion. See "Using the agent terminal" below.

#### Using the agent terminal
`<leader>ai`/`<leader>ac`/`<leader>aa` open a real, interactive CLI session (literally `claude` or
`codex` running in a terminal buffer) — it's not a chat modal, it behaves like any `:terminal`.
That means Neovim's terminal-mode rules apply: you're in terminal-insert mode when it opens (type
directly into it); `<C-\><C-n>` drops you into normal mode over the terminal if you want to scroll
back or leave without killing it; `i`/`a` gets you back into typing mode.

To hand it your code instead of retyping it: visually select and hit `<leader>as` (selection) or
`<leader>af` (whole file) — these get inserted into the agent's prompt as context. `<leader>ap`
opens a library of canned prompts (explain this, fix this, write tests, …) if you don't want to
type a prompt from scratch.

Because `mux.backend = "tmux"` is set, the agent process actually lives in its own tmux window,
not inside Neovim's process — closing/reloading Neovim doesn't kill it. Re-open with the same
toggle key and you're back where you left off, even after `:qa`.

### Quickfix / diagnostics list
| Key | Action |
|---|---|
| `]q` / `[q` | Next/previous quickfix entry |
| `<leader>xx` | Toggle diagnostics (Trouble) |
| `<leader>xw` | Toggle buffer diagnostics (Trouble) |
| `<leader>xs` | Toggle symbols (Trouble) |
| `<leader>xf` | Toggle LSP references/defs (Trouble) |
| `<leader>xl` | Toggle location list (Trouble) |
| `<leader>xq` | Toggle quickfix list (Trouble) |
| `:grep {term}` then `<leader>xq` or `]q`/`[q` | Project-wide search → navigable list (uses `rg`) |

### Windows, tabs, buffers
| Key | Action |
|---|---|
| `<leader>wv` / `<leader>wh` | Split vertically / horizontally |
| `<leader>w=` | Equalize splits |
| `<leader>wx` | Close split |
| `<leader>w_` / `<leader>w\|` | Fullscreen split horizontally/vertically |
| `<leader>sm` | Maximize/minimize the current split |
| `<a-h/j/k/l>` | Move between splits (and tmux panes, seamlessly) |
| `<leader>tc` / `<leader>tx` | New tab / close tab |
| `<leader>tn` / `<leader>tp` | Next/previous tab |
| `<leader>tf` | Open current buffer in a new tab |
| `<leader>bx` | Delete current buffer |
| `<leader>bn` / `<leader>bp` | Next/previous buffer |
| `<leader>bf` / `<leader>bl` | First/last buffer |
| `<leader>a` | Go to last visited buffer |
| `<leader>wr` / `<leader>ws` | Restore/save session for cwd |

### Insert-mode completion (blink.cmp)
| Key | Action |
|---|---|
| `<Tab>` / `<S-Tab>` | Next/previous completion item |
| `<C-j>` / `<C-k>` | Next/previous completion item |
| `<C-Space>` | Open completion menu |
| `<C-e>` | Close completion menu |
| `<C-b>` / `<C-f>` | Scroll documentation up/down |
| `<CR>` | Accept selected item |

## tmux

| Key | Action |
|---|---|
| `C-M-h/j/k/l` (Ctrl+Alt) | Move between panes (passes through to Neovim splits when focused there) — plain Alt is AeroSpace's, so this uses Ctrl+Alt instead |
| `C-M-\` | Move to the last-used pane |
| `prefix+f` | Sessionizer — fuzzy-find a project dir, create/attach its session |
| `prefix+g` | lazygit in a popup |
| `prefix+t` | Scratch shell popup |
| `prefix+L` | Switch to the last session |
| `prefix+R` | Respawn a dead pane, keeping the layout |
| `F12` | Toggle passthrough for a nested tmux session |

## Where each of these lives

- Grapple / pickers / terminal: [nvim/.../plugins/grapple.lua](nvim/.config/nvim/lua/nsohmers/plugins/grapple.lua), [snacks.lua](nvim/.config/nvim/lua/nsohmers/plugins/snacks.lua)
- LSP: [nvim/.../plugins/lsp/lspconfig.lua](nvim/.config/nvim/lua/nsohmers/plugins/lsp/lspconfig.lua)
- Surround/textobjects: [nvim/.../plugins/mini.lua](nvim/.config/nvim/lua/nsohmers/plugins/mini.lua)
- Git: [nvim/.../plugins/gitsigns.lua](nvim/.config/nvim/lua/nsohmers/plugins/gitsigns.lua)
- Agents: [nvim/.../plugins/sidekick.lua](nvim/.config/nvim/lua/nsohmers/plugins/sidekick.lua)
- Quickfix/diagnostics toggles, windows/tabs/buffers: [nvim/.../core/keymaps.lua](nvim/.config/nvim/lua/nsohmers/core/keymaps.lua)
- Completion: [nvim/.../plugins/blink.lua](nvim/.config/nvim/lua/nsohmers/plugins/blink.lua)
- tmux: [tmux/.tmux.conf](tmux/.tmux.conf), [tmux/.local/bin/tmux-sessionizer](tmux/.local/bin/tmux-sessionizer)
