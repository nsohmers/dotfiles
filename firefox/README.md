# Firefox config — not a normal stow package

Everything else in this repo is mirrored into `$HOME` verbatim by `stow`. This directory can't
work that way: Firefox profile folders are named with a random hash generated at profile creation
(e.g. `36fpuoxe.default-release`), which isn't something a static repo structure can mirror to —
it's different per machine and even per profile recreation on the same machine.

So `chrome/` and `user.js` here are just source content. A `.stow-local-ignore` in this directory
makes `stow firefox` (and therefore `stow */`) a deliberate no-op — **don't remove that file**, or
a future `stow */` will happily create `~/chrome` and `~/user.js` directly in your home directory,
which is not what you want.

## What's actually wired up (on this machine, right now)

Two plain symlinks, created manually, into the profile currently used by regular (release-channel)
Firefox:

```bash
PROFILE="$HOME/Library/Application Support/Firefox/Profiles/36fpuoxe.default-release"
ln -s ~/dotfiles/firefox/chrome "$PROFILE/chrome"
ln -s ~/dotfiles/firefox/user.js "$PROFILE/user.js"
```

If you ever create a new profile and want this applied there too (or Firefox ever changes which
folder that profile lives in), find the current folder name with:

```bash
cat ~/Library/Application\ Support/Firefox/profiles.ini   # look at the relevant Path=
```

and re-run the two `ln -s` commands above with the new path. A profile *rename* via `about:profiles`
does not change the on-disk folder, so that alone won't break these symlinks.

**Restart Firefox fully (quit, not just close the window) after (re)creating these** — `user.js` is
only read at startup, and `toolkit.legacyUserProfileCustomizations.stylesheets` (the pref that makes
`userChrome.css` load at all) needs a restart to take effect too.

## Contents

- `chrome/userChrome.css` — currently imports only `hacks/urlHighlight.css` and
  `hacks/minimal_text_fields.css`. The rest of `hacks/` (button click effects, dark context menu,
  minimal toolbar buttons, sidebery mods, tab-bar hiding) came from a fuller theme
  (`userChrome.full-theme.css.reference`, from [MrOtherGuy/firefox-csshacks](https://github.com/MrOtherGuy/firefox-csshacks))
  that isn't applied — add an `@import` line to bring any of it back.
- `user.js` — [Betterfox](https://github.com/yokoffing/Betterfox)'s official recommended `user.js`,
  applied verbatim (not the separate, more aggressive standalone `Securefox.js` module — just the
  bundled one, which the project designs and tests as "no breakage"). Four sections: Fastfox
  (performance/cache tuning), Securefox (the embedded moderate security/privacy section — ETP
  Strict, HTTPS-Only, telemetry/Shield/Normandy disabled, speculative-connect/prefetch disabled,
  disk-cache avoidance, and more), Peskyfox (UI decluttering, including the
  `toolkit.legacyUserProfileCustomizations.stylesheets` pref that makes `userChrome.css` load at
  all), and Smoothfox (empty here — no scroll overrides added). One addition on top, in the file's
  own designated "MY OVERRIDES" section: WebRTC local-IP leak protection, which isn't part of the
  bundle. To pick up upstream updates later, diff this file against
  `https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js` — the only difference should
  be that one override block.
