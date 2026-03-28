#!/usr/bin/env zsh
emulate -L zsh
setopt errreturn nounset pipefail

SCRIPT_DIR=${0:A:h}
ROOT_DIR=${SCRIPT_DIR:h:h}
HELPER=$ROOT_DIR/dot-config/zsh/lib/pi_varlock.zsh
SCHEMA=$ROOT_DIR/dot-config/zsh/scripts/private_zsh_modules/scripts/ahold/pi/.env.schema
LEGACY_SCHEMA=$ROOT_DIR/dot-config/varlock/pi/.env.schema
ALIASES_SCRIPT=$ROOT_DIR/dot-config/zsh/scripts/91_aliases.zsh

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

assert_file_missing() {
  local file_path="$1"
  local message="$2"

  [[ ! -e "$file_path" ]] || fail "$message"
}

assert_file_exists() {
  local file_path="$1"
  local message="$2"

  [[ -f "$file_path" ]] || fail "$message"
}

make_temp_dir() {
  mktemp -d 2>/dev/null || mktemp -d -t pi-varlock-test
}

test_config_dir_prefers_explicit_override() {
  emulate -L zsh
  source "$HELPER"
  export HOME=/tmp/pi-home
  export XDG_CONFIG_HOME=/tmp/pi-xdg
  export DOTFILES=/tmp/pi-dotfiles/zsh
  export PI_VARLOCK_CONFIG_DIR=/tmp/pi-override/

  local actual="$(zsh_pi_varlock_config_dir)"

  assert_eq "/tmp/pi-override/" "$actual" "explicit PI varlock config dir should win"
}

test_config_dir_prefers_the_private_ahold_module_when_available() {
  emulate -L zsh
  source "$HELPER"
  local tmp_dir="$(make_temp_dir)"
  local private_dir="$tmp_dir/repo/dot-config/zsh/scripts/private_zsh_modules/scripts/ahold/pi"
  local legacy_dir="$tmp_dir/repo/dot-config/varlock/pi"
  mkdir -p "$private_dir" "$legacy_dir" "$tmp_dir/home/.config"
  : > "$private_dir/.env.schema"
  : > "$legacy_dir/.env.schema"
  ln -s "$tmp_dir/repo/dot-config/zsh" "$tmp_dir/home/.config/zsh"
  export HOME="$tmp_dir/home"
  export XDG_CONFIG_HOME="$tmp_dir/home/.config"
  export DOTFILES="$tmp_dir/home/.config/zsh"
  unset PI_VARLOCK_CONFIG_DIR

  local actual="$(zsh_pi_varlock_config_dir)"

  assert_eq "${private_dir:A}/" "$actual" "DOTFILES should prefer the encrypted Ahold-specific varlock config"
}

test_config_dir_uses_legacy_repo_path_when_private_module_is_missing() {
  emulate -L zsh
  source "$HELPER"
  local tmp_dir="$(make_temp_dir)"
  local legacy_dir="$tmp_dir/repo/dot-config/varlock/pi"
  mkdir -p "$tmp_dir/repo/dot-config/zsh" "$legacy_dir" "$tmp_dir/home/.config"
  : > "$legacy_dir/.env.schema"
  ln -s "$tmp_dir/repo/dot-config/zsh" "$tmp_dir/home/.config/zsh"
  export HOME="$tmp_dir/home"
  export XDG_CONFIG_HOME="$tmp_dir/home/.config"
  export DOTFILES="$tmp_dir/home/.config/zsh"
  unset PI_VARLOCK_CONFIG_DIR

  local actual="$(zsh_pi_varlock_config_dir)"

  assert_eq "${legacy_dir:A}/" "$actual" "DOTFILES should fall back to the legacy repo path when the private module is unavailable"
}

test_config_dir_uses_xdg_config_home_when_available() {
  emulate -L zsh
  source "$HELPER"
  export HOME=/tmp/pi-home
  export XDG_CONFIG_HOME=/tmp/pi-xdg
  unset DOTFILES PI_VARLOCK_CONFIG_DIR

  local actual="$(zsh_pi_varlock_config_dir)"

  assert_eq "/tmp/pi-xdg/varlock/pi/" "$actual" "XDG config home should be used when no override or repo-managed config is available"
}

test_config_dir_falls_back_to_home_config() {
  emulate -L zsh
  source "$HELPER"
  export HOME=/tmp/pi-home
  unset DOTFILES XDG_CONFIG_HOME PI_VARLOCK_CONFIG_DIR

  local actual="$(zsh_pi_varlock_config_dir)"

  assert_eq "/tmp/pi-home/.config/varlock/pi/" "$actual" "HOME should back the default varlock config path when no better location is available"
}

test_aliases_script_sources_the_pi_varlock_helper() {
  emulate -L zsh
  export DOTFILES=$ROOT_DIR/dot-config/zsh
  bd() {
    [[ "$1" == "completion" && "$2" == "zsh" ]] || return 1
  }

  source "$ALIASES_SCRIPT"

  (( $+functions[pi] )) || fail "aliases script should define the pi function"
  (( $+functions[pi-with-azure] )) || fail "aliases script should define the pi-with-azure function"
  (( $+aliases[pi] == 0 )) || fail "pi should no longer be defined as an alias"
  (( $+aliases[pi-with-azure] == 0 )) || fail "pi-with-azure should not be defined as an alias"
}

test_pi_runs_bun_directly_with_expected_arguments() {
  emulate -L zsh
  source "$HELPER"
  export PI_VARLOCK_CONFIG_DIR=/tmp/pi-varlock/
  local -a bun_args=()
  local -a varlock_args=()
  bun() {
    bun_args=("$@")
  }
  varlock() {
    varlock_args=("$@")
  }

  pi --model sonnet:high "start pi"

  assert_eq "0" "${#varlock_args[@]}" "pi should not invoke varlock"
  assert_eq "5" "${#bun_args[@]}" "pi should invoke bun directly"
  assert_eq "x" "$bun_args[1]" "pi should execute the npm package via bun x"
  assert_eq "@mariozechner/pi-coding-agent@latest" "$bun_args[2]" "pi should run the pi coding agent package"
  assert_eq "--model" "$bun_args[3]" "pi should forward the first pi CLI argument"
  assert_eq "sonnet:high" "$bun_args[4]" "pi should preserve the pi model argument value"
  assert_eq "start pi" "$bun_args[5]" "pi should preserve message arguments"
}

test_pi_handles_empty_argument_lists() {
  emulate -L zsh
  source "$HELPER"
  export PI_VARLOCK_CONFIG_DIR=/tmp/pi-varlock/
  local -a bun_args=()
  local -a varlock_args=()
  bun() {
    bun_args=("$@")
  }
  varlock() {
    varlock_args=("$@")
  }

  pi

  assert_eq "0" "${#varlock_args[@]}" "pi should not invoke varlock when no arguments are provided"
  assert_eq "2" "${#bun_args[@]}" "pi should not add empty arguments when none are provided"
  assert_eq "x" "$bun_args[1]" "pi should still execute via bun x without CLI arguments"
  assert_eq "@mariozechner/pi-coding-agent@latest" "$bun_args[2]" "pi should still invoke the pi package without CLI arguments"
}

test_pi_with_azure_runs_varlock_with_expected_arguments() {
  emulate -L zsh
  source "$HELPER"
  export PI_VARLOCK_CONFIG_DIR=/tmp/pi-varlock/
  local -a bun_args=()
  local -a varlock_args=()
  bun() {
    bun_args=("$@")
  }
  varlock() {
    varlock_args=("$@")
  }

  pi-with-azure --model sonnet:high "start pi"

  assert_eq "0" "${#bun_args[@]}" "pi-with-azure should launch through varlock"
  assert_eq "11" "${#varlock_args[@]}" "pi-with-azure should forward the complete varlock command"
  assert_eq "run" "$varlock_args[1]" "pi-with-azure should invoke varlock run"
  assert_eq "--no-redact-stdout" "$varlock_args[2]" "pi-with-azure should preserve TTY behavior"
  assert_eq "--path" "$varlock_args[3]" "pi-with-azure should pass the varlock config path flag"
  assert_eq "/tmp/pi-varlock/" "$varlock_args[4]" "pi-with-azure should point varlock at the pi config directory"
  assert_eq "--" "$varlock_args[5]" "pi-with-azure should separate varlock args from the pi command"
  assert_eq "bun" "$varlock_args[6]" "pi-with-azure should launch via bun"
  assert_eq "x" "$varlock_args[7]" "pi-with-azure should execute the npm package via bun x"
  assert_eq "@mariozechner/pi-coding-agent@latest" "$varlock_args[8]" "pi-with-azure should run the pi coding agent package"
  assert_eq "--model" "$varlock_args[9]" "pi-with-azure should forward the first pi CLI argument"
  assert_eq "sonnet:high" "$varlock_args[10]" "pi-with-azure should preserve the pi model argument value"
  assert_eq "start pi" "$varlock_args[11]" "pi-with-azure should preserve message arguments"
}

test_pi_with_azure_handles_empty_argument_lists() {
  emulate -L zsh
  source "$HELPER"
  export PI_VARLOCK_CONFIG_DIR=/tmp/pi-varlock/
  local -a bun_args=()
  local -a varlock_args=()
  bun() {
    bun_args=("$@")
  }
  varlock() {
    varlock_args=("$@")
  }

  pi-with-azure

  assert_eq "0" "${#bun_args[@]}" "pi-with-azure should not bypass varlock when no arguments are provided"
  assert_eq "8" "${#varlock_args[@]}" "pi-with-azure should not add empty arguments when none are provided"
  assert_eq "x" "$varlock_args[7]" "pi-with-azure should still execute via bun x without CLI arguments"
  assert_eq "@mariozechner/pi-coding-agent@latest" "$varlock_args[8]" "pi-with-azure should still invoke the pi package without CLI arguments"
}

test_schema_was_moved_out_of_the_public_repo() {
  emulate -L zsh

  assert_file_missing "$LEGACY_SCHEMA" "the public varlock schema should be removed after moving it into the private Ahold module"
}

test_private_schema_exists_in_the_ahold_module() {
  emulate -L zsh

  assert_file_exists "$SCHEMA" "the private Ahold module should carry the pi varlock schema"
}

for test_fn in ${(ok)functions[(I)test_*]}; do
  $test_fn
  print -- "ok $test_fn"
done
