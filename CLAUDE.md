## Project Structure

This is a dotfiles repository managed with GNU Stow. See [DOTFILES.md](DOTFILES.md) for the complete structure overview.

### Documentation References

Read the relevant documentation before making changes:

| When working on... | Read... |
|-------------------|---------|
| ZSH config, plugins, scripts, aliases | [docs/ZSH.md](docs/ZSH.md) |
| Git config, aliases, signing | [docs/GIT.md](docs/GIT.md) |
| Neovim config, plugins, LSP | [docs/NVIM.md](docs/NVIM.md) |
| Ghostty, WezTerm, Tmux, Zellij | [docs/TERMINAL.md](docs/TERMINAL.md) |
| Atuin, Starship, fzf, zoxide | [docs/CLI-TOOLS.md](docs/CLI-TOOLS.md) |

### Key Conventions

- Files prefixed with `dot-` become `.` files via stow (`dot-zshrc` → `~/.zshrc`)
- ZSH scripts in `dot-config/zsh/scripts/` are numbered and sourced in order
- Private configs are in a git submodule (encrypted)
- All terminals use Catppuccin Macchiato theme

