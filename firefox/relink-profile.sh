#!/usr/bin/env bash
# Keeps chrome/ and user.js symlinked into whatever Firefox currently considers
# its default-release profile. Firefox profile paths include a random hash and
# can be replaced entirely — confirmed: it silently abandoned the old one and
# created a fresh, unconfigured profile after a Sept 2026 update. This
# re-resolves the current path every run instead of assuming it's stable.
# Run at login and whenever profiles.ini changes — see
# Library/LaunchAgents/com.nsohmers.firefox-relink.plist.
set -euo pipefail

FIREFOX_DIR="$HOME/Library/Application Support/Firefox"
PROFILES_INI="$FIREFOX_DIR/profiles.ini"
DOTFILES_FIREFOX="$HOME/dotfiles/firefox"

if [[ ! -f "$PROFILES_INI" ]]; then
  echo "profiles.ini not found at $PROFILES_INI, nothing to do"
  exit 0
fi

# Pick the default-release (regular Firefox) profile, not dev-edition.
profile_rel=$(awk -F'=' '/^Default=/ {print $2}' "$PROFILES_INI" | grep "default-release" | grep -v "dev-edition" | head -1)

if [[ -z "$profile_rel" ]]; then
  echo "could not find a default-release profile in profiles.ini"
  exit 1
fi

profile_dir="$FIREFOX_DIR/$profile_rel"

if [[ ! -d "$profile_dir" ]]; then
  echo "resolved profile dir does not exist: $profile_dir"
  exit 1
fi

relink() {
  local name="$1" target="$2" dest="$profile_dir/$1"
  if [[ -L "$dest" ]]; then
    [[ "$(readlink "$dest")" == "$target" ]] && return 0
    rm "$dest"
  elif [[ -e "$dest" ]]; then
    echo "WARNING: $dest exists and isn't a symlink, leaving it alone"
    return 1
  fi
  ln -s "$target" "$dest"
  echo "linked $dest -> $target"
}

relink "chrome" "$DOTFILES_FIREFOX/chrome"
relink "user.js" "$DOTFILES_FIREFOX/user.js"
echo "current default-release profile: $profile_dir"
