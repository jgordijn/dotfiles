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

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local message="$3"
  [[ "$haystack" == *"$needle"* ]] || fail "$message (missing: $needle, actual: $haystack)"
}

start_tmux_server() {
  TMUX_SOCKET="dotfiles-window-title-test-${EPOCHSECONDS}-${$}-${RANDOM}"
  env -u TMUX tmux -L "$TMUX_SOCKET" -f "$TMUX_CONF" new-session -d -s test >/dev/null
}

stop_tmux_server() {
  if [[ -n ${TMUX_SOCKET:-} ]]; then
    env -u TMUX tmux -L "$TMUX_SOCKET" kill-server >/dev/null 2>&1 || true
    unset TMUX_SOCKET
  fi
}

tmux_prefix_binding() {
  local key="$1"
  env -u TMUX tmux -L "$TMUX_SOCKET" list-keys -T prefix "$key"
}

tmux_window_state() {
  env -u TMUX tmux -L "$TMUX_SOCKET" display-message -p '#{window_name}|#{allow-rename}|#{automatic-rename}|#{@pi-title-locked}'
}

lock_window_title() {
  local title="$1"
  env -u TMUX tmux -L "$TMUX_SOCKET" rename-window "$title"
  env -u TMUX tmux -L "$TMUX_SOCKET" set-window-option @pi-title-locked on >/dev/null
  env -u TMUX tmux -L "$TMUX_SOCKET" set-window-option allow-rename off >/dev/null
}

unlock_window_title() {
  env -u TMUX tmux -L "$TMUX_SOCKET" set-window-option -u @pi-title-locked >/dev/null
  env -u TMUX tmux -L "$TMUX_SOCKET" set-window-option -u allow-rename >/dev/null
}

assert_window_state() {
  local expected_title="$1"
  local expected_allow_rename="$2"
  local expected_automatic_rename="$3"
  local expected_lock_flag="$4"
  local title allow_rename automatic_rename lock_flag

  IFS='|' read -r title allow_rename automatic_rename lock_flag <<< "$(tmux_window_state)"

  assert_eq "$expected_title" "$title" 'window title should match'
  assert_eq "$expected_allow_rename" "$allow_rename" 'allow-rename should match'
  assert_eq "$expected_automatic_rename" "$automatic_rename" 'automatic-rename should stay disabled'
  assert_eq "$expected_lock_flag" "$lock_flag" 'pi title lock flag should match'
}

test_title_lock_binding_disables_cli_window_renames() {
  emulate -L zsh
  start_tmux_server
  {
    local binding="$(tmux_prefix_binding T)"
    assert_contains "$binding" 'set-window-option @pi-title-locked on' 'manual title binding should keep the pi lock'
    assert_contains "$binding" 'set-window-option allow-rename off' 'manual title binding should block application-driven renames'
  } always {
    stop_tmux_server
  }
}

test_title_unlock_binding_reenables_cli_window_renames() {
  emulate -L zsh
  start_tmux_server
  {
    local binding="$(tmux_prefix_binding u)"
    assert_contains "$binding" 'set-window-option -u @pi-title-locked' 'unlock binding should clear the pi lock'
    assert_contains "$binding" 'set-window-option -u allow-rename' 'unlock binding should restore application-driven renames'
  } always {
    stop_tmux_server
  }
}

test_manual_title_lock_turns_off_allow_rename_until_unlocked() {
  emulate -L zsh
  start_tmux_server
  {
    local initial_title
    initial_title="$(env -u TMUX tmux -L "$TMUX_SOCKET" display-message -p '#{window_name}')"
    assert_window_state "$initial_title" '1' '0' ''

    lock_window_title 'Focus'
    assert_window_state 'Focus' '0' '0' 'on'

    unlock_window_title
    assert_window_state 'Focus' '1' '0' ''
  } always {
    stop_tmux_server
  }
}

for test_fn in ${(ok)functions[(I)test_*]}; do
  $test_fn
  print -- "ok $test_fn"
done
