# Neovim Configuration

## Files

- `dot-config/nvim/` → `~/.config/nvim/`
  - `init.lua` - Entry point
  - `lua/config/config.lua` - Core settings
  - `lua/config/lazy.lua` - Plugin manager setup
  - `lua/plugins/*.lua` - Individual plugin configs
  - `lazy-lock.json` - Locked plugin versions

## Plugin Manager

Uses [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.

Bootstrap in `lua/config/lazy.lua`:
- Auto-clones lazy.nvim if missing
- Loads plugins from `lua/plugins/` directory
- Disables automatic update checks

## Installed Plugins

| Plugin | File | Purpose |
|--------|------|---------|
| Catppuccin | `catppucin.lua` | Color scheme |
| Copilot | `copilot.lua` | GitHub Copilot integration |
| Git plugins | `gitstuff.lua` | Git integration |
| Harpoon 2 | `harpoon2.lua` | Quick file navigation |
| LSP Config | `lsp-config.lua` | Language server configuration |
| LuaSnip | `luasnip.lua` | Snippet engine |
| mini.nvim | `mini.lua` | Collection of small plugins |
| nvim-cmp | `nvim-cmp.lua` | Completion engine |
| nvim-surround | `nvim-surround.lua` | Surround operations |
| Oil | `oil.lua` | File explorer |
| Prettier | `prettier.lua` | Code formatting |
| Scala Metals | `scala-metals.lua` | Scala LSP |
| Telescope | `telescope.lua` | Fuzzy finder |
| Todo Comments | `todo-comments.lua` | Highlight TODO comments |
| Treesitter | `treesitter.lua` | Syntax highlighting/parsing |
| Which-key | `which-key.lua` | Key binding hints |

## Configuration Structure

Entry point (`init.lua`):
```lua
require("config.config")  -- Core settings
require("config.lazy")    -- Plugin manager
```

## Adding New Plugins

Create a new file in `lua/plugins/`:

```lua
-- lua/plugins/myplugin.lua
return {
  "author/plugin-name",
  config = function()
    require("plugin-name").setup({
      -- options
    })
  end,
}
```

## Color Scheme

Uses Catppuccin Macchiato theme (matching terminal emulators).

## LSP Configuration

`lsp-config.lua` contains extensive LSP setup. Check file for:
- Language server installations
- Key bindings for LSP actions
- Diagnostic settings
