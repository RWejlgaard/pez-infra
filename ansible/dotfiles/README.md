# Dotfiles

Shell configuration, editor setup, and terminal config — consolidated from the standalone [dotfiles](https://github.com/RWejlgaard/dotfiles) repo.

## What's here

```
dotfiles/
├── config/
│   ├── fish/              # Fish shell config
│   │   ├── config.fish    # Main config (greeting, editor, TERM)
│   │   └── conf.d/        # Auto-sourced by fish
│   │       ├── aliases.fish    # OS-aware package manager aliases, k8s shortcuts
│   │       ├── envvars.fish    # PATH and env vars
│   │       └── functions.fish  # !! expansion, cheat, gitissue
│   ├── tmux/
│   │   └── tmux.conf      # Prefix C-a, Alt keybindings, mouse, TPM plugins
│   ├── nvim/
│   │   └── init.lua        # Lazy.nvim, LSP (Mason), Copilot, Neo-tree, Treesitter
│   ├── kitty/
│   │   └── kitty.conf      # Color scheme, TERM fix
│   └── git/
│       └── gitconfig        # user.name/email, gh credential helper
├── install-scripts/        # Numbered install scripts (from upstream dotfiles repo)
│   ├── 01-install-packages.sh   # OS-aware package install
│   ├── 02-move-files.sh         # Legacy copy-based deploy (use install.sh instead)
│   ├── 03-fisher-install.fish   # Fisher plugin manager
│   ├── 04-fish-plugins.fish     # Tide prompt
│   ├── 05-tmux-plugins.fish     # TPM + plugins
│   ├── 06-vim-setup.fish        # Lazy.nvim bootstrap
│   └── 07-last-touches.sh       # Set fish as default shell, ~/bin
├── scripts/                # Utility scripts (Gentoo kernel upgrade helpers)
├── install.sh              # Main install: symlinks + packages + plugins
└── Makefile                # Legacy `make` target (calls install-scripts directly)
```

## Quick start

### Symlinks only (no package install)

```bash
./install.sh --link
```

This creates symlinks from the config files in this directory to their expected locations (`~/.config/fish/`, `~/.tmux.conf`, etc.). Existing files are backed up to `~/.dotfiles-backup/<timestamp>/`.

### Full install (packages + plugins + shell change)

```bash
./install.sh
```

Runs package installation (OS-aware), symlinks configs, installs Fish/Tmux/Neovim plugins, and sets Fish as the default shell.

## Fleet notes

Most servers run Fish as root shell. Current state captured from live fleet (2026-03-22):

| Host | Shell | Git configured | Dotfiles deployed |
|------|-------|----------------|-------------------|
| helsinki-a | fish | Yes (pez@pez.sh) | Yes (full) |
| london-b | fish | Yes (pez@pez.sh) | Partial (fish default, tmux custom) |
| nuremberg-a | fish | No | No |
| london-a | sh (FreeBSD) | No | No |
| copenhagen-a | bash (fresh PVE install) | No | No |

## Relationship to upstream

This is a copy of [RWejlgaard/dotfiles](https://github.com/RWejlgaard/dotfiles) consolidated into the monorepo. The upstream repo can be archived once this is verified working. Key difference: `install.sh` here uses **symlinks** instead of copies, so editing configs in the repo takes effect immediately.
