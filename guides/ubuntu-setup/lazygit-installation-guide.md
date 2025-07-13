# Lazygit Installation Guide for Ubuntu

This guide explains how to install and configure lazygit, a simple terminal UI for git commands. Lazygit provides an intuitive interface for common git operations and integrates well with modern CLI workflows.

## What is Lazygit?

Lazygit is a simple terminal UI for git commands written in Go. It provides:
- Visual git interface in the terminal
- Easy staging, committing, and pushing
- Branch management and visualization
- Interactive rebase and merge conflict resolution
- Stash management
- Diff viewing with syntax highlighting
- Keyboard-driven workflow

## Why Use Lazygit?

### Benefits
- **Visual git workflow** - See status, branches, and commits at a glance
- **Faster operations** - Common git tasks with simple keystrokes
- **Interactive rebasing** - Easy commit squashing and reordering
- **Conflict resolution** - Built-in merge conflict resolution interface
- **Branch visualization** - Clear branch history and relationships
- **Keyboard focused** - Efficient navigation without mouse
- **Cross-platform** - Works on Linux, macOS, and Windows

### Perfect for
- Developers who prefer terminal interfaces
- Users of modern CLI tools (pairs well with delta, bat, etc.)
- Anyone wanting a faster git workflow
- Learning git concepts visually

## Installation Methods

### Method 1: Using apt (Ubuntu 20.04+)

```bash
# Update package list
sudo apt update

# Install lazygit
sudo apt install lazygit

# Verify installation
lazygit --version
```

### Method 2: Using Snap (Recommended)

```bash
# Install via snap
sudo snap install lazygit

# Verify installation
lazygit --version
```

### Method 3: Download Binary (Latest Version)

This method ensures you get the latest version:

```bash
# Create temporary directory
mkdir -p ~/tmp/lazygit
cd ~/tmp/lazygit

# Get latest version URL
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')

# Download latest release
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"

# Extract and install
tar xf lazygit.tar.gz lazygit

# Install to user bin directory
mkdir -p ~/.local/bin
mv lazygit ~/.local/bin/

# Ensure ~/.local/bin is in PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Clean up
cd ~
rm -rf ~/tmp/lazygit

# Verify installation
lazygit --version
```

### Method 4: Using Package Manager (Alternative Repositories)

#### Using PPA (Personal Package Archive)
```bash
# Add PPA (if available)
sudo add-apt-repository ppa:lazygit-team/release
sudo apt update
sudo apt install lazygit
```

#### Using Homebrew on Linux
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install lazygit
brew install lazygit
```

### Method 5: Build from Source (Advanced)

```bash
# Install Go if not already installed
sudo apt update
sudo apt install golang-go

# Clone repository
git clone https://github.com/jesseduffield/lazygit.git
cd lazygit

# Build and install
go install

# Move to appropriate directory
mv ~/go/bin/lazygit ~/.local/bin/

# Clean up
cd ..
rm -rf lazygit
```

## Basic Setup and Configuration

### Initial Configuration

Lazygit works out of the box, but you can customize it:

```bash
# Create config directory
mkdir -p ~/.config/lazygit

# Generate default config file
lazygit --print-config-dir
```

### Basic Configuration File

Create `~/.config/lazygit/config.yml`:

```yaml
# Basic lazygit configuration
gui:
  # UI settings
  theme:
    activeBorderColor:
      - white
      - bold
    inactiveBorderColor:
      - default
    optionsTextColor:
      - blue
    selectedLineBgColor:
      - blue
    selectedRangeBgColor:
      - blue
  
  # Window settings
  windowSize: normal
  scrollHeight: 2
  scrollPastBottom: true
  sidePanelWidth: 0.3333
  expandFocusedSidePanel: false
  mainPanelSplitMode: flexible
  
  # Language
  language: auto

# Git settings
git:
  paging:
    colorArg: always
    pager: delta --dark --paging=never
  commit:
    signOff: false
  merging:
    manualCommit: false
    args: ''
  log:
    order: topo-order
    showGraph: when-maximised
  skipHookPrefix: WIP
  autoFetch: true
  autoRefresh: true
  branchLogCmd: git log --graph --color=always --abbrev-commit --decorate --date=relative --pretty=medium {{branchName}} --

# OS settings
os:
  editCommand: ''
  editCommandTemplate: ''
  openCommand: ''

# Update checking
update:
  method: prompt
  days: 14

# Confirmation settings
confirmOnQuit: false
quitOnTopLevelReturn: false

# Key bindings (can be customized)
keybinding:
  universal:
    quit: 'q'
    quit-alt1: '<c-c>'
    return: '<esc>'
    quitWithoutChangingDirectory: 'Q'
    togglePanel: '<tab>'
    prevItem: '<up>'
    nextItem: '<down>'
    prevItem-alt: 'k'
    nextItem-alt: 'j'
    prevPage: ','
    nextPage: '.'
    gotoTop: '<'
    gotoBottom: '>'
    prevBlock: '<left>'
    nextBlock: '<right>'
    prevBlock-alt: 'h'
    nextBlock-alt: 'l'
    jumpToBlock: ['1', '2', '3', '4', '5']
    nextMatch: 'n'
    prevMatch: 'N'
    optionMenu: 'x'
    optionMenu-alt1: '?'
    select: '<space>'
    goInto: '<enter>'
    openRecentRepos: '<c-r>'
    confirm: '<enter>'
    confirmAlt1: 'y'
    remove: 'd'
    new: 'n'
    edit: 'e'
    openFile: 'o'
    scrollUpMain: '<pgup>'
    scrollDownMain: '<pgdn>'
    scrollUpMain-alt1: 'K'
    scrollDownMain-alt1: 'J'
    scrollUpMain-alt2: '<c-u>'
    scrollDownMain-alt2: '<c-d>'
    executeCustomCommand: ':'
    createRebaseOptionsMenu: 'm'
    pushFiles: 'P'
    pullFiles: 'p'
    refresh: 'R'
    createPatchOptionsMenu: '<c-p>'
    nextTab: ']'
    prevTab: '['
    nextScreenMode: '+'
    prevScreenMode: '_'
    undo: 'z'
    redo: '<c-z>'
    filteringMenu: '<c-s>'
    diffingMenu: 'W'
    diffingMenu-alt: '<c-e>'
    copyToClipboard: '<c-o>'
    submitEditorText: '<enter>'
    appendNewline: '<a-enter>'
    extrasMenu: '@'
```

## Basic Usage

### Essential Navigation

```bash
# Launch lazygit in any git repository
lazygit

# Launch in specific directory
lazygit -p /path/to/repo

# Launch with work tree
lazygit -w /path/to/worktree -g /path/to/git-dir
```

### Key Interface Elements

When you launch lazygit, you'll see several panels:

1. **Status Panel** (top-left) - Shows files with changes
2. **Branches Panel** (bottom-left) - Shows local and remote branches
3. **Commits Panel** (top-right) - Shows commit history
4. **Stash Panel** (bottom-right) - Shows stashed changes
5. **Main Panel** (center) - Shows diffs, commit details, etc.

### Essential Keyboard Shortcuts

#### Navigation
- `Tab` - Switch between panels
- `j/k` or `↑/↓` - Move up/down in lists
- `h/l` or `←/→` - Switch between panels
- `q` - Quit lazygit
- `?` - Show help

#### File Operations
- `Space` - Stage/unstage files
- `a` - Stage all files
- `A` - Unstage all files
- `c` - Commit staged changes
- `C` - Commit with editor
- `d` - View diff
- `o` - Open file in editor
- `e` - Edit file

#### Branch Operations
- `n` - Create new branch
- `Space` - Checkout branch
- `d` - Delete branch
- `r` - Rename branch
- `M` - Merge branch
- `R` - Rebase branch

#### Commit Operations
- `Space` - Checkout commit
- `d` - Delete commit
- `e` - Edit commit
- `p` - Pick commit (during rebase)
- `s` - Squash commit
- `r` - Reword commit

## Advanced Usage

### Interactive Rebasing

```bash
# In commits panel:
# 1. Navigate to the commit you want to rebase from
# 2. Press 'r' to start interactive rebase
# 3. Use these operations:
#    - 'p' or Space: pick commit
#    - 's': squash commit into previous
#    - 'r': reword commit message
#    - 'e': edit commit
#    - 'd': drop commit
#    - 'f': fixup commit
# 4. Press Enter to start rebase
```

### Conflict Resolution

When merge conflicts occur:

```bash
# 1. Conflicts will be highlighted in status panel
# 2. Select conflicted file and press Enter
# 3. Use the conflict resolution interface:
#    - 'h': select left side (HEAD)
#    - 'l': select right side (incoming)
#    - 'b': select both sides
#    - 'a': select all hunks
# 4. Save and stage the resolved file
# 5. Continue the merge/rebase
```

### Stash Management

```bash
# In stash panel:
# - Space: apply stash
# - g: pop stash (apply and delete)
# - d: delete stash
# - r: rename stash
# - n: create new stash

# Creating stashes from status panel:
# - s: stash all changes
# - S: stash staged changes only
```

### Custom Commands

Add to your config file:

```yaml
customCommands:
  - key: 'C'
    command: 'git commit --amend --no-edit'
    description: 'amend last commit'
    context: 'files'
    loadingText: 'amending last commit'
  - key: 'P'
    command: 'git push --force-with-lease origin {{.CheckedOutBranch.Name}}'
    description: 'force push with lease'
    context: 'localBranches'
    loadingText: 'force pushing...'
  - key: '<c-r>'
    command: 'git revert {{.SelectedLocalCommit.Sha}}'
    description: 'revert commit'
    context: 'localBranches'
    loadingText: 'reverting commit...'
```

### Integration with Delta (Enhanced Diffs)

If you have delta installed (from our Rust CLI tools):

```yaml
git:
  paging:
    colorArg: always
    pager: delta --dark --paging=never --24-bit-color=never
  commit:
    signOff: false
  merging:
    manualCommit: false
    args: ''
```

### Theme Customization

Create a custom theme:

```yaml
gui:
  theme:
    activeBorderColor:
      - '#ff9500'
      - bold
    inactiveBorderColor:
      - '#444444'
    optionsTextColor:
      - '#0099ff'
    selectedLineBgColor:
      - '#2d2d2d'
    selectedRangeBgColor:
      - '#2d2d2d'
    cherryPickedCommitBgColor:
      - '#ff9500'
    cherryPickedCommitFgColor:
      - '#000000'
    unstagedChangesColor:
      - '#ff0000'
    defaultFgColor:
      - '#ffffff'
```

## Integration with Other Tools

### With Starship Prompt

Lazygit works seamlessly with Starship's git indicators:

```bash
# Your prompt will show git status
# Launch lazygit for interactive operations
lazygit
```

### With Delta for Better Diffs

```yaml
# In lazygit config
git:
  paging:
    pager: delta --dark --paging=never
```

### With Your Editor

Configure your preferred editor:

```yaml
os:
  editCommand: 'nvim'
  editCommandTemplate: '{{editor}} {{filename}}'
  openCommand: 'code {{filename}}'
```

### With Terminal Multiplexers

Create aliases for easy access:

```bash
# Add to ~/.bashrc
alias lg='lazygit'
alias lgs='lazygit status'

# For tmux users
alias tlg='tmux new-window -n "lazygit" "lazygit"'
```

## Workflows and Use Cases

### Daily Development Workflow

```bash
# 1. Check status and stage files
lazygit
# Navigate to files, use Space to stage

# 2. Review changes before commit
# Select staged files, press Enter to view diff

# 3. Commit changes
# Press 'c', enter commit message

# 4. Push changes
# Press 'P' to push

# 5. Branch management
# Switch to branches panel, create/switch branches
```

### Feature Branch Workflow

```bash
# 1. Create feature branch
# In branches panel: 'n' for new branch

# 2. Make commits on feature branch
# Regular commit workflow

# 3. Interactive rebase to clean up commits
# In commits panel: 'r' on base commit

# 4. Merge or rebase onto main
# Switch to main, then 'M' to merge or 'R' to rebase
```

### Hotfix Workflow

```bash
# 1. Stash current work
# In status panel: 's' to stash

# 2. Switch to main/production branch
# In branches panel: checkout main

# 3. Create hotfix branch
# 'n' for new branch from main

# 4. Make hotfix and commit
# Regular commit workflow

# 5. Merge hotfix
# Switch to main, merge hotfix branch

# 6. Return to previous work
# Switch back to feature branch
# In stash panel: apply previous stash
```

## Troubleshooting

### Common Issues

#### Lazygit not found after installation
```bash
# Check if it's in PATH
which lazygit

# If using ~/.local/bin, ensure it's in PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Config file not loading
```bash
# Check config location
lazygit --print-config-dir

# Verify config file syntax
cat ~/.config/lazygit/config.yml
```

#### Delta not working with lazygit
```bash
# Ensure delta is installed and in PATH
which delta

# Check pager configuration in lazygit config
# Make sure path is correct
```

#### Performance issues with large repositories
```yaml
# Add to config.yml
git:
  log:
    showGraph: never
  autoFetch: false
  autoRefresh: false
```

### Advanced Troubleshooting

#### Debug mode
```bash
# Run with debug information
lazygit --debug

# Check logs
lazygit --logs
```

#### Reset configuration
```bash
# Backup current config
cp ~/.config/lazygit/config.yml ~/.config/lazygit/config.yml.backup

# Remove config to use defaults
rm ~/.config/lazygit/config.yml
```

## Tips and Best Practices

### Keyboard Efficiency

1. **Learn the essential shortcuts**: `Tab`, `Space`, `Enter`, `q`
2. **Use vim-style navigation**: `hjkl` for movement
3. **Remember context-specific actions**: Different panels have different shortcuts
4. **Use the help**: Press `?` to see available shortcuts

### Git Workflow Integration

1. **Stage selectively**: Use `Space` on individual hunks, not just files
2. **Review before committing**: Always check the diff before committing
3. **Use interactive rebase**: Clean up commit history before merging
4. **Stash frequently**: Use stashes for quick context switching

### Configuration Tips

1. **Start with defaults**: Don't over-customize initially
2. **Add custom commands gradually**: As you identify repetitive tasks
3. **Use delta integration**: Much better diff viewing
4. **Configure editor integration**: For seamless file editing

## Quick Reference

### Installation One-liner
```bash
# Latest binary installation
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && tar xf lazygit.tar.gz lazygit && mkdir -p ~/.local/bin && mv lazygit ~/.local/bin/ && rm lazygit.tar.gz
```

### Essential Shortcuts
```bash
Tab     # Switch panels
Space   # Stage/unstage/checkout
Enter   # Open/edit/view
c       # Commit
P       # Push
p       # Pull
n       # New (branch/stash/etc)
d       # Delete/view diff
r       # Rename/rebase
q       # Quit
?       # Help
```

### Quick Actions
```bash
lazygit              # Launch in current directory
lazygit -p ~/project # Launch in specific project
lg                   # Alias (if configured)
```

---

**Happy git management with lazygit!** 🎯

For related guides, see:
- [Delta Git Diff Viewer](./rust-cli-tools/delta.md)
- [Starship Prompt Configuration](./rust-cli-tools/starship.md)
- [NerdFont Installation](./nerdfont-installation-guide.md)