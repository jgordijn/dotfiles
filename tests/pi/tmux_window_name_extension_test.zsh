#!/usr/bin/env zsh
emulate -L zsh
setopt errreturn nounset pipefail

EXTENSION_FILE=/Users/jgordijn/.pi/agent/extensions/tmux-window-name.ts

fail() {
  print -u2 -- "FAIL: $1"
  exit 1
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local message="$3"
  [[ "$haystack" == *"$needle"* ]] || fail "$message (missing: $needle)"
}

source_text=$(<"$EXTENSION_FILE")

assert_contains "$source_text" "@pi-title-locked" 'extension should check the pi title lock flag'
assert_contains "$source_text" "@opencode-title-locked" 'extension should remain compatible with the legacy title lock flag'
assert_contains "$source_text" "isCurrentTmuxWindowTitleLocked" 'extension should centralize tmux lock detection'
assert_contains "$source_text" "if (await isCurrentTmuxWindowTitleLocked(pi)) return false;" 'rename should bail out when the tmux window is locked'

print -- "ok tmux_window_name_extension_test"
