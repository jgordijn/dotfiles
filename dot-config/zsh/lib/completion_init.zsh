# Shared helpers for fast, single-pass completion initialization.

zsh_add_fpath_front() {
  local completion_dir="$1"

  [[ -d "$completion_dir" ]] || return 0
  (( ${fpath[(Ie)$completion_dir]} == 0 )) || return 0

  fpath=("$completion_dir" $fpath)
}

zsh_add_default_homebrew_completion_path() {
  local homebrew_root="${1:-}"
  local -a completion_dirs=(
    "${homebrew_root}/opt/homebrew/share/zsh-completions"
    "${homebrew_root}/usr/local/share/zsh-completions"
  )
  local completion_dir

  if [[ -z "$homebrew_root" ]]; then
    completion_dirs=(
      "/opt/homebrew/share/zsh-completions"
      "/usr/local/share/zsh-completions"
    )
  fi

  for completion_dir in $completion_dirs; do
    if [[ -d "$completion_dir" ]]; then
      zsh_add_fpath_front "$completion_dir"
      return 0
    fi
  done
}


zsh_compdump_is_stale() {
  local compdump_path="$1"
  local -a stat_result

  [[ -s "$compdump_path" ]] || return 0

  zmodload zsh/datetime 2>/dev/null || return 0
  zmodload -F zsh/stat b:zstat 2>/dev/null || return 0
  zstat -A stat_result +mtime -- "$compdump_path" 2>/dev/null || return 0

  (( EPOCHSECONDS - stat_result[1] >= 86400 ))
}

zsh_run_compinit_once() {
  emulate -L zsh

  local compdump_path="${1:-${ZDOTDIR:-$HOME}/.zcompdump}"
  local cache_path="${2:-$HOME/.zcompcache}"

  [[ -d "$cache_path" ]] || mkdir -p "$cache_path"
  [[ -n ${_ZSH_COMPINIT_DONE:-} ]] && return 0

  (( $+functions[compinit] )) || autoload -Uz compinit

  if zsh_compdump_is_stale "$compdump_path"; then
    compinit -d "$compdump_path"
  else
    compinit -C -d "$compdump_path"
  fi

  typeset -g _ZSH_COMPINIT_DONE=1
}
