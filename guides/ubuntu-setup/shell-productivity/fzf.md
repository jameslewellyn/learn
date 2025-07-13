# FZF - Fuzzy Finder Installation and Setup Guide

A command-line fuzzy finder that provides interactive filtering for any list of items.

## What is FZF?

**FZF** (Fuzzy Finder) is a general-purpose command-line fuzzy finder that can be used with any list: files, command history, processes, hostnames, bookmarks, git commits, etc. It's written in Go and provides an interactive interface for selecting items from lists.

## Key Features

- **Universal**: Works with any list of items
- **Interactive**: Real-time filtering with fuzzy matching
- **Customizable**: Extensive configuration options
- **Fast**: Efficient fuzzy matching algorithm
- **Integrations**: Works with many tools and editors
- **Cross-platform**: Available on Linux, macOS, and Windows

## Installation

### Method 1: APT (Recommended)
```bash
sudo apt update
sudo apt install fzf
```

### Method 2: Git Installation (Latest Version)
```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### Method 3: Manual Binary Download
```bash
# Download latest release
curl -LO "https://github.com/junegunn/fzf/releases/download/0.44.1/fzf-0.44.1-linux_amd64.tar.gz"
tar -xzf fzf-0.44.1-linux_amd64.tar.gz
sudo mv fzf /usr/local/bin/
rm fzf-0.44.1-linux_amd64.tar.gz
```

## Basic Configuration

### Shell Integration
Add to `~/.bashrc` or `~/.zshrc`:

```bash
# Enable fzf key bindings and fuzzy completion
source /usr/share/doc/fzf/examples/key-bindings.bash
source /usr/share/doc/fzf/examples/completion.bash

# If installed via git:
# source ~/.fzf.bash
```

### Default Options
Set environment variables in your shell config:

```bash
# Basic options
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# Use ripgrep for file search (if installed)
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'

# Use fd for file search (alternative)
# export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

# Ctrl+T options (file search)
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"

# Alt+C options (directory search)
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
```

## Basic Usage

### Command Line Interface
```bash
# Basic fuzzy finder
fzf

# Pipe input to fzf
ls | fzf

# Find files and open with editor
fzf | xargs -r $EDITOR

# Multi-select mode
fzf --multi

# Preview mode
fzf --preview 'cat {}'
```

### Key Bindings (after shell integration)
- **Ctrl+T**: Paste the selected files and directories onto the command-line
- **Ctrl+R**: Paste the selected command from history onto the command-line
- **Alt+C**: cd into the selected directory

### Interactive Usage
While in fzf interface:
- **Enter**: Select item
- **Ctrl+C** or **Esc**: Cancel
- **Tab**: Select multiple items (in multi-select mode)
- **Shift+Tab**: Deselect items
- **Ctrl+A**: Select all
- **Ctrl+D**: Deselect all
- **Ctrl+J/K**: Navigate up/down

## Advanced Usage

### Search Syntax
```bash
# Exact match
fzf -e

# Case sensitive
fzf +i

# Inverse match (exclude)
fzf --query "!pattern"

# Multiple patterns (AND)
fzf --query "pattern1 pattern2"

# OR patterns
fzf --query "pattern1 | pattern2"
```

### Custom Commands

#### File Search with Preview
```bash
# Advanced file finder
ff() {
  local file
  file=$(find . -type f -not -path '*/\.*' | fzf --preview 'bat --style=numbers --color=always --line-range :500 {}')
  [[ -n "$file" ]] && $EDITOR "$file"
}
```

#### Directory Navigation
```bash
# Enhanced directory navigation
fd() {
  local dir
  dir=$(find ${1:-.} -type d 2>/dev/null | fzf +m) && cd "$dir"
}
```

#### Git Integration
```bash
# Git branch selector
fgb() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" | fzf -d '/' --nth=3 +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# Git commit browser
fgc() {
  local commits commit
  commits=$(git log --pretty=format:'%C(yellow)%h%C(reset) - %C(green)(%cr)%C(reset) %s %C(blue)<%an>%C(reset)' --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --ansi +s +m -e) &&
  git show $(echo "$commit" | sed "s/ .*//")
}
```

#### Process Management
```bash
# Kill processes interactively
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  [[ -n "$pid" ]] && kill -${1:-9} $pid
}
```

### Configuration File
Create `~/.fzf.bash` or `~/.fzf.zsh`:

```bash
# FZF configuration
export FZF_DEFAULT_OPTS='
  --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9
  --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9
  --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6
  --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4
  --height=50%
  --layout=reverse
  --border
  --margin=1
  --padding=1
'

# Custom key bindings
export FZF_CTRL_T_OPTS="
  --preview 'bat --style=numbers --color=always --line-range :500 {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'
"

export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'
"

export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
```

## Integration with Other Tools

### Vim/Neovim
Install fzf.vim plugin:
```vim
" Add to .vimrc
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
```

### Zsh Integration
```bash
# Add to .zshrc
plugins=(... fzf)

# Custom functions
autoload -U select-word-style
select-word-style bash
```

### Tmux Integration
```bash
# Add to .tmux.conf
bind-key -T copy-mode-vi 'v' send -X begin-selection
bind-key -T copy-mode-vi 'y' send -X copy-selection
bind-key -T copy-mode-vi 'r' send -X rectangle-toggle
bind-key -T copy-mode-vi 'Escape' send -X cancel
bind-key -T copy-mode-vi 'H' send -X start-of-line
bind-key -T copy-mode-vi 'L' send -X end-of-line
```

### Ripgrep + FZF
```bash
# Live grep with fzf
rg_fzf() {
  rg --color=always --line-number --no-heading --smart-case "${*:-}" |
    fzf --ansi \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --delimiter : \
        --preview 'bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(vim {1} +{2})'
}
```

## Performance Tuning

### Large File Systems
```bash
# Limit search depth
export FZF_DEFAULT_COMMAND='find . -maxdepth 5 -type f'

# Use parallel processing
export FZF_DEFAULT_COMMAND='find . -type f -print0 | xargs -0 -P 4 ls -la'

# Exclude large directories
export FZF_DEFAULT_COMMAND='find . -type f -not -path "*/node_modules/*" -not -path "*/.git/*"'
```

### Memory Optimization
```bash
# Limit number of items
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --no-sort --tac"

# Use streaming mode for large inputs
some_command | fzf --no-sort --tac
```

## Troubleshooting

### Common Issues

#### FZF not found after installation
```bash
# Check if fzf is in PATH
which fzf

# Add to PATH if needed
export PATH="$PATH:$HOME/.fzf/bin"
```

#### Key bindings not working
```bash
# Ensure proper sourcing
source /usr/share/doc/fzf/examples/key-bindings.bash

# Check if shell integration is loaded
set | grep -i fzf
```

#### Preview not working
```bash
# Install required tools
sudo apt install bat tree

# Check preview command
fzf --preview 'echo {}' <<< "test"
```

#### Slow performance
```bash
# Use simpler commands
export FZF_DEFAULT_COMMAND='find . -type f'

# Reduce preview size
export FZF_DEFAULT_OPTS="--preview-window=right:50%"
```

## Scripts and Aliases

### Useful Aliases
```bash
# Add to .bashrc/.zshrc
alias fzp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
alias fzd="find . -type d | fzf"
alias fzh="history | fzf"
alias fzk="ps aux | fzf | awk '{print \$2}' | xargs kill"
```

### Custom Scripts

#### Enhanced File Search
```bash
#!/bin/bash
# ~/.local/bin/fzf-files
fd --type f --hidden --follow --exclude .git \
  | fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' \
        --bind 'enter:become(vim {})' \
        --bind 'ctrl-o:execute(xdg-open {})' \
        --header 'Enter: edit, Ctrl-O: open'
```

#### Project Selector
```bash
#!/bin/bash
# ~/.local/bin/fzf-projects
project=$(find ~/projects -maxdepth 2 -type d -name .git -exec dirname {} \; | fzf)
[[ -n "$project" ]] && cd "$project"
```

## Best Practices

1. **Use with other tools**: Combine with ripgrep, fd, bat for enhanced functionality
2. **Customize key bindings**: Set up personal key bindings for common workflows
3. **Use preview**: Always use preview for file operations
4. **Optimize for your workflow**: Create custom functions for repeated tasks
5. **Shell integration**: Enable shell integration for maximum productivity

## Security Considerations

- FZF doesn't execute commands by default, only provides selection
- Be careful with custom scripts that auto-execute selected items
- Preview commands run in shell context - validate preview commands
- Use appropriate file permissions for custom scripts

## Integration with Your Toolkit

FZF pairs excellently with:
- **ripgrep**: Fast text search with fuzzy selection
- **fd**: File finding with fuzzy filtering
- **bat**: Syntax highlighting in previews
- **zoxide**: Enhanced directory jumping
- **git**: Interactive git operations
- **tmux**: Session and window management
- **vim/nvim**: File and buffer selection

## Updates and Maintenance

### Update FZF
```bash
# If installed via apt
sudo apt update && sudo apt upgrade fzf

# If installed via git
cd ~/.fzf && git pull && ./install

# If installed manually
curl -LO "https://github.com/junegunn/fzf/releases/latest/download/fzf-linux_amd64.tar.gz"
tar -xzf fzf-linux_amd64.tar.gz
sudo mv fzf /usr/local/bin/
```

### Configuration Backup
```bash
# Backup FZF configuration
cp ~/.fzf.bash ~/.fzf.bash.backup
cp ~/.bashrc ~/.bashrc.backup
```

FZF is an essential productivity tool that transforms command-line interaction from linear to interactive, making file navigation, command selection, and data filtering much more efficient and enjoyable.

---

For more information:
- [FZF GitHub Repository](https://github.com/junegunn/fzf)
- [FZF Wiki](https://github.com/junegunn/fzf/wiki)
- [Advanced FZF Examples](https://github.com/junegunn/fzf/wiki/examples)