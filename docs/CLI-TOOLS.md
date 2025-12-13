# CLI Tools Configuration

## Atuin - Shell History

Location: `dot-config/atuin/config.toml` → `~/.config/atuin/config.toml`

### Overview

Atuin replaces shell history with a SQLite database, sync support, and fuzzy search.

### Key Settings

```toml
# Shell up-key behavior
filter_mode_shell_up_key_binding = "session"
search_mode_shell_up_key_binding = "prefix"

# Don't auto-execute on enter
enter_accept = false
invert = false

# Space exits with command
[keys]
exit_with_space = true

# Sync enabled
[sync]
records = true
```

### Feature Flag

Atuin is opt-in. Enable in your environment:
```zsh
export ZSH_ATUIN_ENABLED=true
```

### Key Bindings

| Binding | Action |
|---------|--------|
| `Ctrl+R` | Search history (all modes) |
| `Up/Down` | Navigate results |
| `Enter` | Select (returns to shell for editing) |
| `Tab` | Accept and edit |
| `Space` | Accept with trailing space |

## Starship - Prompt

Location: `dot-config/starship.toml` → `~/.config/starship.toml`

### Format

Multi-line prompt showing:
1. Language info (Java, Node, Python)
2. Azure and Kubernetes context
3. Directory, git branch, git status
4. Command duration and status (if applicable)
5. OS icon, sudo status, prompt character

### Key Modules

```toml
# Kubernetes with context highlighting
[kubernetes]
disabled = false
format = '[$context/$namespace]($style) '

[[kubernetes.contexts]]
context_pattern = ".*prod.*"
style = "bold red"
context_alias = "prod"

[[kubernetes.contexts]]
context_pattern = ".*acc.*"
style = "bold yellow"
context_alias = "accept"

# Directory shortcuts
[directory.substitutions]
'~/projects/ahold/' = ''
'.worktrees' = '🌳'
```

### Prompt Characters

- Success: `➜` (green)
- Error: `✗` (red)

## FZF - Fuzzy Finder

Configuration in: `dot-config/zsh/scripts/10_fzf.zsh`

### Key Bindings

| Binding | Action |
|---------|--------|
| `Alt+T` | File search (moved from Ctrl+T for Zellij compat) |
| `Alt+C` | Directory search |
| `Ctrl+R` | History search (when Atuin disabled) |

### Preview Settings

```zsh
# File preview with bat
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target,.idea
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# Directory preview with tree
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {}'"
```

### fzf-tab Integration

FZF is integrated into ZSH completion via fzf-tab:
- Tab completion uses FZF
- Directory completion shows `eza` preview
- Git checkout completion disabled sorting

## Zoxide - Smart CD

Initialized in `dot-zshrc`:
```zsh
eval "$(zoxide init zsh)"
```

### Commands

| Command | Action |
|---------|--------|
| `z <dir>` | Jump to directory |
| `zi` | Interactive selection with fzf |
| `zf` | Full list with fzf preview |

### Custom Widget

`Alt+F` triggers interactive zoxide selection (zi-widget).

## Required Homebrew Packages

```shell
brew install fzf zoxide bat eza fd starship atuin
```

## Optional Tools

- `delta` - Better git diffs
- `jq` - JSON processor
- `yh` - YAML highlighter
- `fx` - JSON viewer
