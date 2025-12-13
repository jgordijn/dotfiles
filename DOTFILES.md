# Dotfiles Structure

This repository manages configuration files using GNU Stow with a `dot-` prefix convention.

## How It Works

### Stow Setup

[GNU Stow](https://www.gnu.org/software/stow/) is a symlink farm manager. When run with `--dotfiles`, it translates `dot-` prefixed files/directories to `.` prefixed targets in the home directory.

**Installation:**
```shell
# From ~/dotfiles (this repo must be cloned here)
stow --dotfiles -v .
```

This creates symlinks:
- `~/dotfiles/dot-zshrc` → `~/.zshrc`
- `~/dotfiles/dot-config/zsh/` → `~/.config/zsh/`
- `~/dotfiles/dot-gitconfig` → `~/.gitconfig`
- etc.

### Directory Structure

```
dotfiles/
├── dot-config/              → ~/.config/
│   ├── atuin/              # Shell history enhancement
│   ├── ghostty/            # Ghostty terminal config
│   ├── nvim/               # Neovim configuration
│   ├── starship.toml       # Starship prompt
│   ├── tmux/               # Tmux colors
│   ├── zellij/             # Zellij terminal multiplexer
│   └── zsh/                # ZSH configuration
│       ├── plugin_manager.zsh
│       ├── p10k.zsh        # Powerlevel10k config (if used)
│       └── scripts/        # Numbered scripts sourced in order
│           ├── 00_functions.zsh
│           ├── 01_vim_mode.zsh
│           ├── 10_fzf.zsh
│           ├── 10_history.zsh
│           ├── 11_docker.zsh
│           ├── 15_atuin.zsh
│           ├── 20_git.zsh
│           ├── 30_kubernetes.zsh
│           └── private_zsh_modules/  # Git submodule (encrypted)
├── dot-gitconfig           → ~/.gitconfig
├── dot-gitignore_global    → ~/.gitignore_global
├── dot-oh-my-zsh/          → ~/.oh-my-zsh/ (legacy)
├── dot-tmux.conf           → ~/.tmux.conf
├── dot-wezterm.lua         → ~/.wezterm.lua
├── dot-zshrc               → ~/.zshrc (main entry point)
└── dot-zshrc-oh-my-zsh     → Backup of old oh-my-zsh config
```

### Root-Level Configurations

| File(s) | Description |
|---------|-------------|
| `dot-zshrc` | Main ZSH entry point |
| `dot-gitconfig`, `dot-gitignore_global` | Git configuration |
| `dot-tmux.conf` | Tmux configuration |
| `dot-wezterm.lua` | WezTerm terminal config |

### Submodules

Private/encrypted configurations are stored in a git submodule:
```shell
git submodule init
git submodule update
```

The private modules in `dot-config/zsh/scripts/private_zsh_modules/` contain encrypted scripts (see README in submodule for decryption).

## Documentation by Component

See the `docs/` directory for detailed configuration documentation:

- [docs/ZSH.md](docs/ZSH.md) - ZSH shell configuration and custom plugin manager
- [docs/GIT.md](docs/GIT.md) - Git configuration and aliases
- [docs/NVIM.md](docs/NVIM.md) - Neovim setup with lazy.nvim
- [docs/TERMINAL.md](docs/TERMINAL.md) - Terminal emulators (Ghostty, WezTerm, Tmux, Zellij)
- [docs/CLI-TOOLS.md](docs/CLI-TOOLS.md) - CLI tools (Atuin, Starship, fzf, zoxide)

## Quick Commands

```shell
# Apply dotfiles
stow --dotfiles -v .

# Remove dotfiles (dry run)
stow --dotfiles -nv -D .

# Remove dotfiles
stow --dotfiles -v -D .

# Update submodules
git submodule update --remote
```
