#!/usr/bin/env zsh
emulate -L zsh
setopt errreturn nounset pipefail

SCRIPT_DIR=${0:A:h}
ROOT_DIR=${SCRIPT_DIR:h:h}
TMUX_CONF=$ROOT_DIR/dot-tmux.conf

fail() {
  print -u2 -- "FAIL: $1"
  exit 1
}

assert_eq() {
  local expected="$1"
  local actual="$2"
  local message="$3"
  [[ "$expected" == "$actual" ]] || fail "$message (expected: $expected, actual: $actual)"
}

tmux_session_segment_format() {
  local line
  line=$(grep -E '^set -g @nova-segment-session "' "$TMUX_CONF") || fail "tmux config should declare a session segment"
  line=${line#*\"}
  line=${line%\"}
  print -- "$line"
}

tmux_render_session_segment() {
  local session_name="$1"
  local format="$2"
  local socket_name="dotfiles-tmux-test-${EPOCHSECONDS}-${$}-${RANDOM}"
  local output

  {
    env -u TMUX tmux -L "$socket_name" -f /dev/null new-session -d -s "$session_name" >/dev/null
    output=$(env -u TMUX tmux -L "$socket_name" display-message -p "$format")
    print -- "$output"
  } always {
    env -u TMUX tmux -L "$socket_name" kill-server >/dev/null 2>&1 || true
  }
}

test_session_segment_keeps_short_session_names() {
  emulate -L zsh
  local format="$(tmux_session_segment_format)"
  local actual="$(tmux_render_session_segment 'Team' "$format")"

  assert_eq 'Team' "$actual" 'short session names should remain unchanged'
}

test_session_segment_truncates_long_session_names() {
  emulate -L zsh
  local format="$(tmux_session_segment_format)"
  local actual="$(tmux_render_session_segment 'CreativePortalTeamAccess' "$format")"

  assert_eq 'Creative…' "$actual" 'long session names should be truncated with an ellipsis'
}

for test_fn in ${(ok)functions[(I)test_*]}; do
  $test_fn
  print -- "ok $test_fn"
done
