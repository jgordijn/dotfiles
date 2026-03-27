#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
  cat <<EOF
Usage: $(basename "$0") [options]

Install dotfiles using GNU Stow with --dotfiles translation.

Options:
  -n, --dry-run    Simulate only, don't modify filesystem
  -D, --delete     Remove symlinks instead of creating them
  -R, --restow     Remove then recreate symlinks (useful after changes)
  -v, --verbose    Show what stow is doing (default: on)
  -q, --quiet      Suppress stow output
  -h, --help       Show this help message
EOF
}

main() {
  local action="install"
  local verbose="-v"
  local dry_run=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -n|--dry-run) dry_run="-n"; shift ;;
      -D|--delete)  action="delete"; shift ;;
      -R|--restow)  action="restow"; shift ;;
      -v|--verbose) verbose="-v"; shift ;;
      -q|--quiet)   verbose=""; shift ;;
      -h|--help)    usage; exit 0 ;;
      *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
    esac
  done

  if ! command -v stow &>/dev/null; then
    echo "Error: GNU Stow is not installed." >&2
    echo "  brew install stow" >&2
    exit 1
  fi

  cd "$DOTFILES_DIR"

  if [[ ! -f .stow-local-ignore ]]; then
    echo "Error: .stow-local-ignore not found in $DOTFILES_DIR" >&2
    exit 1
  fi

  local stow_args=(--dotfiles $verbose $dry_run)

  case "$action" in
    install) stow_args+=(".") ;;
    delete)  stow_args+=(-D ".") ;;
    restow)  stow_args+=(-R ".") ;;
  esac

  if [[ -n "$dry_run" ]]; then
    echo "Dry run — no changes will be made."
  fi

  echo "Stow: $action (target: $HOME)"
  stow "${stow_args[@]}"
  echo "Done."
}

main "$@"
