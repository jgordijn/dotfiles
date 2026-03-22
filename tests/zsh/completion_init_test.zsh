#!/usr/bin/env zsh
emulate -L zsh
setopt errreturn nounset pipefail

SCRIPT_DIR=${0:A:h}
ROOT_DIR=${SCRIPT_DIR:h:h}
HELPER=$ROOT_DIR/dot-config/zsh/lib/completion_init.zsh

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

assert_true() {
  local message="$1"
  shift
  "$@" || fail "$message"
}

assert_false() {
  local message="$1"
  shift
  if "$@"; then
    fail "$message"
  fi
}

make_temp_dir() {
  mktemp -d 2>/dev/null || mktemp -d -t completion-init-test
}

test_add_fpath_front_skips_missing_directory() {
  emulate -L zsh
  source "$HELPER"
  local missing_dir=$(make_temp_dir)/missing
  local -a fpath=(/tmp/existing)

  zsh_add_fpath_front "$missing_dir"

  assert_eq "/tmp/existing" "$fpath[1]" "missing directories should not be added"
  assert_eq "1" "${#fpath[@]}" "missing directories should leave fpath unchanged"
}

test_add_fpath_front_prepends_existing_directory_once() {
  emulate -L zsh
  source "$HELPER"
  local existing_dir=$(make_temp_dir)
  local -a fpath=(/tmp/existing)

  zsh_add_fpath_front "$existing_dir"
  zsh_add_fpath_front "$existing_dir"

  assert_eq "$existing_dir" "$fpath[1]" "existing directory should be prepended"
  assert_eq "/tmp/existing" "$fpath[2]" "existing entries should remain after prepend"
  assert_eq "2" "${#fpath[@]}" "directory should not be duplicated"
}

test_add_default_homebrew_completion_path_prefers_opt_homebrew() {
  emulate -L zsh
  source "$HELPER"
  local tmp_dir=$(make_temp_dir)
  local opt_homebrew="$tmp_dir/opt/homebrew/share/zsh-completions"
  local usr_local="$tmp_dir/usr/local/share/zsh-completions"
  mkdir -p "$opt_homebrew" "$usr_local"
  local -a fpath=(/tmp/existing)

  zsh_add_default_homebrew_completion_path "$tmp_dir"

  assert_eq "$opt_homebrew" "$fpath[1]" "Apple Silicon Homebrew completions should be preferred"
  assert_eq "/tmp/existing" "$fpath[2]" "existing completion paths should be preserved"
}

test_add_default_homebrew_completion_path_falls_back_to_usr_local() {
  emulate -L zsh
  source "$HELPER"
  local tmp_dir=$(make_temp_dir)
  local usr_local="$tmp_dir/usr/local/share/zsh-completions"
  mkdir -p "$usr_local"
  local -a fpath=(/tmp/existing)

  zsh_add_default_homebrew_completion_path "$tmp_dir"

  assert_eq "$usr_local" "$fpath[1]" "Intel Homebrew completions should be used as fallback"
}

test_add_default_homebrew_completion_path_skips_missing_directories() {
  emulate -L zsh
  source "$HELPER"
  local tmp_dir=$(make_temp_dir)
  local -a fpath=(/tmp/existing)

  zsh_add_default_homebrew_completion_path "$tmp_dir"

  assert_eq "/tmp/existing" "$fpath[1]" "missing Homebrew completion directories should be ignored"
  assert_eq "1" "${#fpath[@]}" "fpath should remain unchanged when no Homebrew completions exist"
}

test_compdump_is_stale_for_missing_file() {
  emulate -L zsh
  source "$HELPER"
  local missing_file=$(make_temp_dir)/.zcompdump

  assert_true "missing compdump should be treated as stale" zsh_compdump_is_stale "$missing_file"
}

test_compdump_is_stale_for_old_file() {
  emulate -L zsh
  source "$HELPER"
  local tmp_dir=$(make_temp_dir)
  local compdump="$tmp_dir/.zcompdump"
  print -- cached > "$compdump"
  touch -t 202001010000 "$compdump"

  assert_true "old compdump should be treated as stale" zsh_compdump_is_stale "$compdump"
}

test_compdump_is_not_stale_for_fresh_file() {
  emulate -L zsh
  source "$HELPER"
  local tmp_dir=$(make_temp_dir)
  local compdump="$tmp_dir/.zcompdump"
  print -- cached > "$compdump"

  assert_false "fresh compdump should reuse cache" zsh_compdump_is_stale "$compdump"
}

test_run_compinit_once_uses_full_compinit_for_stale_dump() {
  emulate -L zsh
  source "$HELPER"
  local tmp_dir=$(make_temp_dir)
  local compdump="$tmp_dir/.zcompdump"
  local cache_dir="$tmp_dir/cache"
  print -- cached > "$compdump"
  touch -t 202001010000 "$compdump"
  local -a compinit_calls=()
  compinit() { compinit_calls+=("$*"); }
  unset _ZSH_COMPINIT_DONE

  zsh_run_compinit_once "$compdump" "$cache_dir"

  assert_eq "1" "${#compinit_calls[@]}" "stale compdump should initialize completions once"
  assert_eq "-d $compdump" "$compinit_calls[1]" "stale compdump should run full compinit"
  [[ -d "$cache_dir" ]] || fail "compinit cache directory should be created"
}

test_run_compinit_once_uses_cached_mode_for_fresh_dump() {
  emulate -L zsh
  source "$HELPER"
  local tmp_dir=$(make_temp_dir)
  local compdump="$tmp_dir/.zcompdump"
  print -- cached > "$compdump"
  local -a compinit_calls=()
  compinit() { compinit_calls+=("$*"); }
  unset _ZSH_COMPINIT_DONE

  zsh_run_compinit_once "$compdump" "$tmp_dir/cache"

  assert_eq "1" "${#compinit_calls[@]}" "fresh compdump should initialize completions once"
  assert_eq "-C -d $compdump" "$compinit_calls[1]" "fresh compdump should reuse cached compinit"
}

test_run_compinit_once_is_idempotent() {
  emulate -L zsh
  source "$HELPER"
  local tmp_dir=$(make_temp_dir)
  local compdump="$tmp_dir/.zcompdump"
  print -- cached > "$compdump"
  local -a compinit_calls=()
  compinit() { compinit_calls+=("$*"); }
  unset _ZSH_COMPINIT_DONE

  zsh_run_compinit_once "$compdump" "$tmp_dir/cache"
  zsh_run_compinit_once "$compdump" "$tmp_dir/cache"

  assert_eq "1" "${#compinit_calls[@]}" "compinit should only run once per shell"
}

for test_fn in ${(ok)functions[(I)test_*]}; do
  $test_fn
  print -- "ok $test_fn"
done
