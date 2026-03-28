# Launch pi directly by default. Use pi-with-azure when Anthropic Azure
# credentials should be loaded from 1Password via varlock.

zsh_pi_varlock_repo_config_dir() {
  [[ -n "${DOTFILES:-}" ]] || return 1

  local dotfiles_dir="${DOTFILES:A}"
  local -a config_dirs=(
    "$dotfiles_dir/scripts/private_zsh_modules/scripts/ahold/pi"
    "${dotfiles_dir:h}/varlock/pi"
  )
  local config_dir

  for config_dir in $config_dirs; do
    if [[ -f "$config_dir/.env.schema" ]]; then
      print -r -- "${config_dir:A}/"
      return 0
    fi
  done

  return 1
}

zsh_pi_varlock_config_dir() {
  if [[ -n "${PI_VARLOCK_CONFIG_DIR:-}" ]]; then
    print -r -- "$PI_VARLOCK_CONFIG_DIR"
    return 0
  fi

  local repo_config_dir
  repo_config_dir="$(zsh_pi_varlock_repo_config_dir)" || repo_config_dir=""
  if [[ -n "$repo_config_dir" ]]; then
    print -r -- "$repo_config_dir"
  elif [[ -n "${XDG_CONFIG_HOME:-}" ]]; then
    print -r -- "${XDG_CONFIG_HOME}/varlock/pi/"
  else
    print -r -- "${HOME}/.config/varlock/pi/"
  fi
}

pi() {
  emulate -L zsh

  bun x @mariozechner/pi-coding-agent@latest "$@"
}

pi-with-azure() {
  emulate -L zsh

  local config_dir
  config_dir="$(zsh_pi_varlock_config_dir)"

  varlock run --no-redact-stdout --path "$config_dir" -- bun x @mariozechner/pi-coding-agent@latest "$@"
}

