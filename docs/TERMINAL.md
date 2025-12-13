# Terminal Emulator Configuration

## Overview

Multiple terminal emulators are configured:
- **Ghostty** - Primary terminal (recommended)
- **WezTerm** - Cross-platform alternative
- **Tmux** - Terminal multiplexer
- **Zellij** - Modern terminal multiplexer

## Ghostty

Location: `dot-config/ghostty/config` → `~/.config/ghostty/config`

### Key Settings

```ini
macos-option-as-alt = left    # Fix Option key behavior
font-size = 18.0
theme = Catppuccin Macchiato

# Key bindings
keybind = cmd+shift+n=prompt_surface_title
keybind = shift+enter=text:\x1b\r
```

### Notes

- The `TERM=xterm-ghostty` is converted to `xterm-256color` in `.zshrc` for compatibility
- Uses native macOS rendering

## WezTerm

Location: `dot-wezterm.lua` → `~/.wezterm.lua`

### Configuration

```lua
local config = wezterm.config_builder()
config.color_scheme = 'Catppuccin Macchiato'
config.font_size = 18.0
return config
```

### Notes

- Minimal configuration
- Matches Ghostty theme for consistency

## Tmux

Files:
- `dot-tmux.conf` → `~/.tmux.conf`
- `dot-config/tmux/tmux.colors.conf` → `~/.config/tmux/tmux.colors.conf`

### Key Settings

```bash
# Prefix changed to Ctrl+A
unbind C-b
set-option -g prefix C-a

# Vi mode
set-window-option -g mode-keys vi

# Mouse support
set -g mouse on

# Split panes
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
```

### Key Bindings

| Binding | Action |
|---------|--------|
| `Ctrl+A` | Prefix key |
| `Prefix + \|` | Split horizontal |
| `Prefix + -` | Split vertical |
| `Prefix + r` | Reload config |
| `Prefix + h/j/k/l` | Navigate panes (vim-style) |
| `Alt + Arrow` | Navigate panes |
| `Ctrl+Shift+H/L` | Move window left/right |
| `Ctrl+K` | Clear screen and history |

### Color Scheme

Uses Gruvbox dark theme (defined in `tmux.colors.conf`).

## Zellij

Location: `dot-config/zellij/config.kdl` → `~/.config/zellij/config.kdl`

### Key Features

- Custom keybinds (clears defaults)
- Super key (Cmd) based shortcuts
- Vim-style navigation
- Session management

### Key Bindings

| Binding | Action |
|---------|--------|
| `Super+G` | Lock mode |
| `Super+P` | Pane mode |
| `Super+T` | Tab mode |
| `Super+N` | Resize mode |
| `Super+H` | Move mode |
| `Super+S` | Scroll mode |
| `Super+O` | Session mode |
| `Super+Q` | Quit |

### Modes

Zellij uses modal navigation:
- **Normal** - Default, typing goes to terminal
- **Locked** - Passes all keys to terminal
- **Pane** - Pane management (split, navigate, close)
- **Tab** - Tab management
- **Resize** - Pane resizing
- **Move** - Move panes
- **Scroll** - Scroll buffer, search

### Settings

```kdl
default_mode "normal"
show_startup_tips false
scrollback_editor "/opt/homebrew/bin/nvim"
```

## Theme Consistency

All terminals use Catppuccin Macchiato color scheme for consistency:
- Ghostty: `theme = Catppuccin Macchiato`
- WezTerm: `color_scheme = 'Catppuccin Macchiato'`
- Tmux: Gruvbox (different, could be unified)
