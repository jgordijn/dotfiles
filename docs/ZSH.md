# ZSH Configuration

## Overview

This setup uses a custom lightweight plugin manager instead of oh-my-zsh or other frameworks. Configuration is split into numbered scripts that are sourced in order.

## File Locations

- Entry point: `dot-zshrc` → `~/.zshrc`
- Configuration: `dot-config/zsh/` → `~/.config/zsh/`
- Plugin manager: `dot-config/zsh/plugin_manager.zsh`
- Scripts: `dot-config/zsh/scripts/*.zsh`

## Plugin Manager

Location: `dot-config/zsh/plugin_manager.zsh`

A minimal plugin manager that:
1. Clones plugins from GitHub on first use
2. Auto-updates plugins daily
3. Sources plugin files automatically

### Usage

In `dot-zshrc`:
```zsh
source $DOTFILES/plugin_manager.zsh

# Add plugins (GitHub format: user/repo)
zsh_add_plugin "Aloxaf/fzf-tab"
zsh_add_plugin "zsh-users/zsh-autosuggestions"
zsh_add_plugin "zsh-users/zsh-syntax-highlighting"
zsh_add_plugin "jeffreytse/zsh-vi-mode"
```

### Plugin Storage

Plugins are stored in `~/.local/share/zsh/managed-plugins/`

### Manual Update

```zsh
update_plugins  # Force update all plugins
```

## Script Loading Order

Scripts in `dot-config/zsh/scripts/` are sourced in numerical order:

| Order | File | Purpose |
|-------|------|---------|
| 00 | `00_functions.zsh` | Utility functions (cache_command, reset_cache) |
| 01 | `01_vim_mode.zsh` | Vi mode cursor configuration |
| 10 | `10_fzf.zsh` | FZF integration and fzf-tab configuration |
| 10 | `10_history.zsh` | History settings (5M lines, dedup, share between sessions) |
| 11 | `11_docker.zsh` | Docker/Podman aliases and completion |
| 12 | `12_asdf.zsh` | asdf version manager |
| 15 | `15_atuin.zsh` | Atuin shell history (feature-flagged) |
| 20 | `20_git.zsh` | Git aliases and functions |
| 30 | `30_kubernetes.zsh` | Kubernetes aliases (extensive) |
| 31 | `31_kubernetes_custom.zsh` | Custom k8s extensions |
| 40 | `40_dotenv.zsh` | Auto-load .env files (feature-flagged) |
| 90 | `90_keymaps.zsh` | Key bindings |
| 91 | `91_aliases.zsh` | General aliases |

Private modules: `scripts/private_zsh_modules/` (git submodule, encrypted)

## Environment Variables

Key variables set in `dot-zshrc`:

```zsh
export DOTFILES=$HOME/.config/zsh
export PLUGINS_DIR=$HOME/.config/zsh/plugins
export ZSH_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh"
export CUSTOM_ZSH_FUNCTIONS=$DOTFILES/scripts
```

## Feature Flags

Some features are opt-in via environment variables:

```zsh
# Enable Atuin shell history
export ZSH_ATUIN_ENABLED=true

# Enable auto-loading .env files
export ZSH_DOTENV_ENABLED=true
```

## Prompt Configuration

The prompt is configurable via `PROMPTER` variable in `dot-zshrc`:

```zsh
PROMPTER="starship"     # Default - Starship prompt
PROMPTER="oh-my-posh"   # Oh My Posh
PROMPTER="powerlevel10k" # Powerlevel10k (p10k.zsh in zsh dir)
```

## Key Bindings

| Binding | Action |
|---------|--------|
| `F5` | Reload ZSH config |
| `Alt+F` | Zoxide interactive (zi-widget) |
| `Alt+T` | FZF file search |
| `Ctrl+R` | History search (Atuin if enabled) |
| `1-9` | Jump to directory in stack |

## Completion System

- Uses `compinit` with daily regeneration
- fzf-tab for fuzzy completion
- Custom completion cache in `~/.zcompcache`
- Docker compose completion (works with podman)

## Dependencies (via Homebrew)

Required:
- `fzf` - Fuzzy finder
- `zoxide` - Smart cd
- `bat` - Cat with syntax highlighting
- `eza` - Modern ls
- `fd` - Modern find
- `starship` - Prompt (if using)
