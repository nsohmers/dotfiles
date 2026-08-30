# tmux, for someone who's never gotten used to it

tmux is a terminal multiplexer: one background process (the **server**) holds any number of
**sessions**, each session holds **windows** (think: tabs), each window holds one or more
**panes** (splits). The whole point is that all of it keeps running even when you close the
terminal app or your SSH connection drops — you just reattach later and everything (running
dev servers, watchers, a half-finished agent conversation) is exactly where you left it.

In this setup specifically: **one session per project.** Not one big session with a million
windows — a *session named after the repo*, so switching projects means switching sessions, and
you never have twelve unrelated windows in one list.

## The one idea worth actually internalizing

Every tmux command starts with the **prefix key**, `Ctrl-b`, released, then a second key. So
"prefix then c" means: press `Ctrl-b`, let go of both keys, then press `c`. It's not held down
together. The exceptions in this config are the handful of bindings made "global" with `-n`
(no prefix needed) — those are the `Ctrl+Alt`-based ones (see below), because you use them
constantly and a prefix would get old fast.

## One-time setup

The plugin manager (TPM) wasn't actually installed before — it's cloned to `~/.tmux/plugins/tpm`
now, and `tmux-thumbs` (see below) is fetched. If you add another `@plugin` line to
`tmux.conf` in the future, press **prefix + I** (capital i) inside any tmux session to fetch it.

## Starting and leaving a session

You don't "quit" tmux the way you quit an app — you **detach**, and the session keeps running.

| Do this | To |
|---|---|
| `tmux` | Start a brand-new, unnamed session (rarely what you want here — see sessionizer) |
| `prefix d` | Detach — leave the session running in the background, back to your normal shell |
| `tmux ls` | List every running session, from outside tmux |
| `tmux attach -t <name>` | Reattach to a specific session, from outside tmux |
| closing the terminal window | Also just detaches (the session survives) — this is the whole point |

## The way you'll actually open projects: the sessionizer

Forget `tmux new -s myproject` — press **`prefix f`**. It fuzzy-finds a directory (currently
searching `~/dotfiles` and `~/Documents` — edit `SEARCH_ROOTS` in
[tmux-sessionizer](tmux/.local/bin/tmux-sessionizer) if your projects live elsewhere) and either
creates a new session named after that directory, or switches you to it if it already exists.
This is the single most-used binding in the whole setup: **one key to jump to any project**,
whether or not you have a session for it yet.

## Panes: splitting and moving around

You almost never need to think about tmux panes vs. Neovim splits separately — `Ctrl-Alt-h/j/k/l`
moves in whichever direction, seamlessly crossing from a Neovim split straight into a tmux pane
and back, because it detects whether the focused pane is running Neovim and forwards the
keystroke accordingly (that's `vim-tmux-navigator` in `nvim`, matched against `C-M-h/j/k/l` here).

It's `Ctrl+Alt`, not plain `Alt`, because AeroSpace already claims plain `alt-h/j/k/l` globally for
switching focus between macOS windows — that grab happens before Ghostty (or anything running
inside it) ever sees the keystroke, so pane-nav had to move to a combo AeroSpace doesn't touch.

| Key | Does |
|---|---|
| `prefix %` | Split pane vertically (stock tmux default, untouched here) |
| `prefix "` | Split pane horizontally (stock tmux default) |
| `Ctrl-Alt-h` / `-j` / `-k` / `-l` | Move left/down/up/right — pane *or* Neovim split |
| `prefix z` | Zoom the current pane fullscreen (toggle); stock default |
| `prefix R` | Respawn a dead pane in place (e.g. a crashed dev server), keeping the layout |
| `prefix x` | Kill the current pane (stock default, asks to confirm) |

## Windows (tabs, one per "concern")

Per the setup's own convention: session = project, **window = concern** — one for the editor, one
for a shell, one for a dev server, one for an agent. Not one window per file or per task.

| Key | Does |
|---|---|
| `prefix c` | New window (stock default) |
| `prefix n` / `prefix p` | Next/previous window (stock default) |
| `prefix 0`-`9` | Jump straight to window number N (stock default) |
| `prefix ,` | Rename the current window (stock default — do this, "2: zsh" beats "2: -zsh") |
| `prefix w` | Interactive window picker (stock default) |

## Popups — a floating window over whatever you're doing

| Key | Does |
|---|---|
| `prefix g` | lazygit, full-screen-ish popup, no layout disruption. Press `q` to close it |
| `prefix t` | A plain scratch shell popup, for a quick one-off command |

Both close by exiting the program inside them (`q` for lazygit, `exit`/`Ctrl-d` for the shell) or
just pressing the same prefix combo again in some cases — either way your underlying pane layout
is untouched the whole time.

## Mouse mode

`mouse on` is set, so — unlike a lot of tmux configs you'll see online — you don't have to touch
the keyboard for the basics: click a pane to focus it, drag a border to resize, scroll with the
wheel/trackpad to scroll back through output (this automatically enters copy mode for you), and
click-drag over text to select it. It's there so you're not forced to learn everything below on
day one; use the keyboard version once the mouse version feels slow.

## Copy mode — scrolling back and copying text

Scrolling up with the mouse drops you into copy mode automatically. To do it deliberately instead:

1. `prefix [` — enter copy mode (you'll see a position indicator in the top-right)
2. Move with `h j k l` (this config uses vi-style copy-mode keys, so it's the same muscle memory
   as Neovim) or search with `/`
3. `v` to start a selection, move to extend it, `y` to yank it and exit copy mode
4. `q` at any point to bail out of copy mode without copying anything

Because `set-clipboard on` is set, whatever you `y` here also lands in your **system** clipboard
(via OSC 52) — including over SSH, no extra setup needed.

There's also **tmux-thumbs**: press **prefix + Space**, and every file path, git hash, and URL
visible in the pane gets a little hint label — type the label to copy that string instantly,
without entering copy mode and manually selecting.

## Session-to-session moves

| Key | Does |
|---|---|
| `prefix f` | Sessionizer — jump to (or create) a project session by fuzzy-finding its directory |
| `prefix L` | Jump back to whichever session you were in immediately before this one |
| `prefix s` | Interactive list of all sessions to switch between (stock default) |
| `prefix $` | Rename the current session (stock default) |

## Nested tmux (only matters once you SSH into something that also runs tmux)

If you `ssh` into a box that starts its own tmux, your local prefix (`Ctrl-b`) would normally
control the *outer* (local) tmux even when you meant the *inner* (remote) one. Press **`F12`** to
toggle: it temporarily disables your local tmux's prefix entirely so every keystroke — including
`Ctrl-b` — passes straight through to the remote session. Press `F12` again to give control back
to your local tmux.

## A typical day, start to finish

1. Open Ghostty. If it doesn't already land you in tmux, run `tmux` or attach to yesterday's
   session with `tmux attach`.
2. `prefix f` → type part of a project name → land in that project's session, `cwd` already set.
3. You're in a fresh session with one window/pane: open Neovim, do your thing. `Ctrl-Alt-l` /
   `Ctrl-Alt-h` to hop over to a shell pane you split off with `prefix "` for running a quick
   command, back to the editor with `Ctrl-Alt-h`/`Ctrl-Alt-l` again.
4. Need the full git picture? `prefix g` for lazygit, look around, `q` to close it, right back to
   what you were doing.
5. Want an agent running alongside? Either a dedicated window (`prefix c`) running `claude`/`codex`
   directly, or — since the Neovim config's sidekick.nvim is wired to tmux — just use `<leader>ai`
   from inside Neovim; it manages its own tmux window for the agent, which is why it survives
   quitting Neovim.
6. Starting a second, unrelated project? `prefix f` again, pick the other directory — you now have
   two sessions running side by side. `prefix L` bounces between the two if that's all you're
   juggling.
7. Done for the day? Just close the terminal, or `prefix d`. Nothing dies. Tomorrow: reopen Ghostty,
   `prefix f`, same project, same session, dev server still running from yesterday if it didn't
   crash.

## Full key reference

See the tmux section of [KEYBINDINGS.md](KEYBINDINGS.md) for the compact table of everything
customized here (as opposed to this file, which is the "why" and "how do I actually use it").
