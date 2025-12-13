# Git Configuration

## Files

- `dot-gitconfig` → `~/.gitconfig`
- `dot-gitignore_global` → `~/.gitignore_global`

## Key Settings

### User Configuration

```ini
[user]
    name = Jeroen Gordijn
    email = jeroen.gordijn@gmail.com
    signingkey = ssh-ed25519 ...
```

### Conditional Includes

Different configurations for different project directories:

```ini
[includeIf "gitdir:/Users/jgordijn/projects/dhl/"]
    path = /Users/jgordijn/projects/dhl/dhl-gitconfig

[includeIf "gitdir:/Users/jgordijn/projects/ahold/"]
    path = /Users/jgordijn/projects/ahold/ahold-gitconfig
```

### Commit Signing

Uses SSH keys via 1Password:

```ini
[gpg]
    format = ssh

[gpg "ssh"]
    program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"

[commit]
    gpgsign = true
```

### Delta Pager

Uses `delta` for pretty diffs:

```ini
[core]
    pager = delta --diff-so-fancy --color-only

[delta]
    navigate = true
    light = false

[merge]
    conflictstyle = diff3
```

### Beads Integration

Custom merge driver for beads issue tracking:

```ini
[merge "beads"]
    driver = bd merge %A %O %A %B
    name = bd JSONL merge driver
```

## Aliases

| Alias | Command |
|-------|---------|
| `st` | `status` |
| `ci` | `commit` |
| `br` | `branch` |
| `co` | `checkout` |
| `df` | `diff` |
| `lg` | `log -p` |
| `glog` | `log --graph` |
| `ls` | Pretty one-line log with colors |
| `ll` | One-line log with numstat |
| `ld` | Log with relative dates |

## ZSH Git Aliases

From `dot-config/zsh/scripts/20_git.zsh`:

| Alias | Command |
|-------|---------|
| `gf` | `git fetch` |
| `ga` | `git add` |
| `gl` | `git pull` |
| `gp` | `git push` |
| `gst` | `git status` |
| `gmom` | `git merge origin/<main-branch>` |
| `gcm` | `git checkout <main-branch>` |
| `gco` | `git checkout` |
| `gcb` | `git checkout -b` |
| `glog` | `git log --oneline --decorate --graph` |
| `grt` | cd to git root |
| `gpf` | `git push --force-with-lease --force-if-includes` |
| `gd` | `git diff` |
| `gwl` | `git worktree list` |
| `gwr` | `git worktree remove` |
| `gwa` | `git worktree add` |

## Functions

### `git_main_branch`

Detects the main branch (main, master, trunk, etc.):

```zsh
git_main_branch  # Returns: main (or detected branch)
```

### `grob` - Open branch in browser

Opens current branch in GitHub/GitLab:

```zsh
grob           # Opens current branch on origin
grob upstream  # Opens current branch on upstream
```

### `grm` - Open repo main page

```zsh
grm           # Opens repo root on origin
```

### `grps` - Open pull requests

```zsh
grps          # Opens /pulls page
```

### `gro` - Open current PR

```zsh
gro           # Uses gh pr view --web
```

## Global Gitignore

`dot-gitignore_global` ignores:

- IDE files: `.idea/`, `*.iml`, `.vscode/`
- Build artifacts: `target/`, `build/`, `dist/`
- OS files: `.DS_Store`, `Thumbs.db`
- Environment: `.env`, `.env-*`
- Package locks: `*lock.json`
- Tool files: `.bloop/`, `.metals/`, `.gradle/`
- Claude Code: `.claude/settings.local.json`, `.beads/`
