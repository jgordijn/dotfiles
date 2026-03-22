#!/usr/bin/env zsh
emulate -L zsh
setopt errreturn nounset pipefail

SCRIPT_DIR=${0:A:h}
ROOT_DIR=${SCRIPT_DIR:h:h}
HELPER=$ROOT_DIR/dot-config/zsh/lib/widget_init.zsh

source "$HELPER"

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

assert_false() {
  local message="$1"
  shift
  if "$@"; then
    fail "$message"
  fi
}

test_is_widget_shell_is_false_without_a_real_terminal() {
  emulate -L zsh
  source "$HELPER"

  assert_false "test environment should not look like an interactive terminal" zsh_is_widget_shell
}

test_invoke_if_widget_shell_skips_command_when_widget_shell_is_unavailable() {
  emulate -L zsh
  source "$HELPER"
  local -a calls=()
  zsh_is_widget_shell() { return 1 }
  record_call() { calls+=("$*") }

  zsh_invoke_if_widget_shell record_call first second

  assert_eq "0" "${#calls[@]}" "commands should be skipped when widgets are unavailable"
}

test_invoke_if_widget_shell_runs_command_when_widget_shell_is_available() {
  emulate -L zsh
  source "$HELPER"
  local -a calls=()
  zsh_is_widget_shell() { return 0 }
  record_call() { calls+=("$*") }

  zsh_invoke_if_widget_shell record_call first second

  assert_eq "1" "${#calls[@]}" "commands should run when widgets are available"
  assert_eq "first second" "$calls[1]" "command arguments should be preserved"
}

for test_fn in ${(ok)functions[(I)test_*]}; do
  $test_fn
  print -- "ok $test_fn"
done
