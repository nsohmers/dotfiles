# Firefox config — not a normal stow package

Everything else in this repo is mirrored into `$HOME` verbatim by `stow`. This directory can't
work that way: Firefox profile folders are named with a random hash generated at profile creation
(e.g. `36fpuoxe.default-release`), which isn't something a static repo structure can mirror to —
it's different per machine and even per profile recreation on the same machine.

So `chrome/`, `user.js`, and `relink-profile.sh` here are just source content, not stow-mirrored.
A `.stow-local-ignore` in this directory excludes them, making `stow firefox` (and therefore
`stow */`) only touch the one thing here that IS safely portable: the LaunchAgent plist under
`Library/LaunchAgents/`. **Don't remove `.stow-local-ignore`**, or a future `stow */` will happily
create `~/chrome`, `~/user.js`, and `~/relink-profile.sh` directly in your home directory.

## What's actually wired up — self-healing, not a one-time symlink

**Incident, Sept 2026:** the original setup here was two manually-created symlinks into a specific
profile folder (`36fpuoxe.default-release`). Firefox updated to `155.0.1`, silently abandoned that
profile (left it completely empty — no data recoverable), and created a fresh, unconfigured
replacement. The hardening and custom CSS were inactive for over a week before anyone noticed,
because nothing was watching for this. Suspected root cause: `browser.profiles.enabled` (part of
Betterfox's Peskyfox section) turns on Firefox's still-actively-developed profile-switcher
subsystem — exactly the kind of feature prone to migration bugs on update. It's overridden back to
`false` in this file's own "MY OVERRIDES" section (a later `user_pref` call wins over an earlier one
for the same key, so the upstream bundle body stays untouched and diffable).

Regardless of whether that was the actual trigger, profile paths are inherently unstable (random
hash, and now confirmed capable of being replaced outright), so the fix is structural:
[`relink-profile.sh`](relink-profile.sh) resolves the *current* default-release profile from
`profiles.ini` every time it runs — never hardcodes a path — and (re)creates the `chrome`/`user.js`
symlinks there if they're missing or stale. A LaunchAgent
([`Library/LaunchAgents/com.nsohmers.firefox-relink.plist`](Library/LaunchAgents/com.nsohmers.firefox-relink.plist))
runs it automatically: once at every login (`RunAtLoad`), and immediately whenever Firefox touches
`profiles.ini` (`WatchPaths`) — which is exactly the moment a profile swap like the Sept 2026 one
would happen. Logs at `~/Library/Logs/firefox-relink.log`.

To check it's alive: `launchctl list | grep firefox-relink`. To re-run it manually (e.g. right after
creating a brand new profile, or if you just want to confirm it's pointed at the right place):

```bash
~/dotfiles/firefox/relink-profile.sh
```

**Restart Firefox fully (quit, not just close the window) after it (re)links** — `user.js` is only
read at startup, and `toolkit.legacyUserProfileCustomizations.stylesheets` (the pref that makes
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
  all), and Smoothfox (empty here — no scroll overrides added). Two additions on top, both in the
  file's own designated "MY OVERRIDES" section (so the upstream bundle body stays untouched): WebRTC
  local-IP leak protection (not part of the bundle), and `browser.profiles.enabled` forced back to
  `false` (see "Incident, Sept 2026" below). To pick up upstream updates later, diff this file
  against `https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js` — the only difference
  should be that one override block.
