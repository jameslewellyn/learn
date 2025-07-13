# McFly - Intelligent Command History Installation and Setup Guide

An intelligent command history search tool that replaces `Ctrl+R` with contextual results powered by machine learning.

## What is McFly?

**McFly** is a command history search tool that prioritizes results based on your current directory and the commands you typically run. It uses machine learning to provide more relevant search results compared to traditional history search. Named after Marty McFly from Back to the Future, it helps you navigate through your command history more efficiently.

## Key Features

- **Contextual results**: Prioritizes commands based on current directory and command frequency
- **Machine learning**: Neural network-based ranking for better relevance
- **Fast search**: Instant results as you type
- **Smart suggestions**: Learns from your usage patterns
- **Directory-aware**: Commands are weighted by directory context
- **Multi-shell support**: Works with bash, zsh, fish, and PowerShell
- **Privacy-focused**: All data stored locally

## Installation

### Method 1: Cargo (Recommended)
```bash
cargo install mcfly
```

### Method 2: Homebrew (if available)
```bash
brew install mcfly
```

### Method 3: Manual Binary Installation
```bash
# Download latest release
curl -LO "https://github.com/cantino/mcfly/releases/latest/download/mcfly-v0.8.4-x86_64-unknown-linux-musl.tar.gz"
tar -xzf mcfly-v0.8.4-x86_64-unknown-linux-musl.tar.gz
sudo mv mcfly /usr/local/bin/
rm mcfly-v0.8.4-x86_64-unknown-linux-musl.tar.gz
```

### Method 4: From Source
```bash
git clone https://github.com/cantino/mcfly.git
cd mcfly
cargo build --release
sudo cp target/release/mcfly /usr/local/bin/
```

## Basic Setup

### Shell Integration

#### Bash
Add to `~/.bashrc`:
```bash
# Initialize McFly
eval "$(mcfly init bash)"
```

#### Zsh
Add to `~/.zshrc`:
```bash
# Initialize McFly
eval "$(mcfly init zsh)"
```

#### Fish
Add to `~/.config/fish/config.fish`:
```bash
# Initialize McFly
mcfly init fish | source
```

### Environment Variables
Configure McFly behavior by adding to your shell config:

```bash
# Basic configuration
export MCFLY_KEY_SCHEME=vim          # Use vim key bindings
export MCFLY_FUZZY=true              # Enable fuzzy matching
export MCFLY_RESULTS=50              # Number of results to show
export MCFLY_INTERFACE_VIEW=BOTTOM   # Show results at bottom
export MCFLY_RESULTS_SORT=LAST_RUN   # Sort by last run time
```

### Database Location
By default, McFly stores data in:
- Linux: `~/.local/share/mcfly/history.db`
- macOS: `~/Library/Application Support/mcfly/history.db`

## Basic Usage

### Interactive Search
- **Ctrl+R**: Open McFly search interface
- **Type**: Start typing to search command history
- **Enter**: Execute selected command
- **Ctrl+C** or **Esc**: Cancel search
- **Tab**: Accept suggestion without executing

### Key Bindings (Default)
- **Up/Down arrows**: Navigate through results
- **Ctrl+N/Ctrl+P**: Navigate through results (alternative)
- **Ctrl+E**: Edit command before executing
- **Ctrl+D**: Delete command from history
- **F1**: Toggle between different result views

### Search Modes
McFly automatically provides:
- **Exact matches**: Commands that exactly match your input
- **Fuzzy matches**: Commands that approximately match
- **Contextual suggestions**: Commands relevant to current directory

## Advanced Configuration

### Key Scheme Options
```bash
# Vim-style key bindings
export MCFLY_KEY_SCHEME=vim

# Emacs-style key bindings (default)
export MCFLY_KEY_SCHEME=emacs
```

### Interface Views
```bash
# Show results at bottom (default)
export MCFLY_INTERFACE_VIEW=BOTTOM

# Show results at top
export MCFLY_INTERFACE_VIEW=TOP
```

### Fuzzy Matching
```bash
# Enable fuzzy matching (default: false)
export MCFLY_FUZZY=true

# Adjust fuzzy matching threshold (0-1)
export MCFLY_FUZZY_THRESHOLD=0.5
```

### Result Sorting
```bash
# Sort by last run time (default)
export MCFLY_RESULTS_SORT=LAST_RUN

# Sort by frequency
export MCFLY_RESULTS_SORT=FREQUENCY

# Sort by relevance
export MCFLY_RESULTS_SORT=RELEVANCE
```

### Light Mode
```bash
# Enable light mode for terminal compatibility
export MCFLY_LIGHT=true
```

## Advanced Usage

### Custom Configuration File
Create `~/.mcfly/config.toml`:

```toml
[settings]
key_scheme = "vim"
fuzzy = true
results = 100
interface_view = "BOTTOM"
results_sort = "LAST_RUN"
light = false

[colors]
menu_bg = "#2d2d2d"
menu_fg = "#cccccc"
selection_bg = "#4d4d4d"
selection_fg = "#ffffff"
query_bg = "#2d2d2d"
query_fg = "#cccccc"
```

### Training McFly
McFly learns from your usage patterns automatically, but you can help it learn faster:

```bash
# Use commands in different directories
cd ~/projects/work
ls -la
git status
npm test

cd ~/projects/personal
ls -la
git status
python script.py

# McFly will learn that these commands are contextually relevant
```

### Importing Existing History
```bash
# Import bash history
mcfly import bash

# Import zsh history
mcfly import zsh

# Import fish history
mcfly import fish
```

### Database Management
```bash
# Show database statistics
mcfly stats

# Vacuum database (optimize storage)
mcfly vacuum

# Export history to JSON
mcfly export > history_backup.json
```

## Integration with Other Tools

### Starship Integration
McFly can influence starship prompt indicators:

```toml
# Add to ~/.config/starship.toml
[custom.mcfly]
command = "mcfly status"
when = "mcfly status"
style = "bold green"
```

### Tmux Integration
```bash
# Add to .tmux.conf for better compatibility
set-option -g default-terminal "screen-256color"
```

### Zoxide Integration
McFly works well with zoxide for enhanced directory navigation:

```bash
# Both tools complement each other
eval "$(mcfly init zsh)"
eval "$(zoxide init zsh)"
```

## Customization

### Custom Key Bindings
Create custom key bindings in your shell:

```bash
# Bash/Zsh custom bindings
bindkey '^[[A' mcfly-history-widget  # Up arrow
bindkey '^[[B' mcfly-history-widget  # Down arrow
```

### Themes and Colors
```bash
# Dark theme (default)
export MCFLY_LIGHT=false

# Light theme
export MCFLY_LIGHT=true

# Custom colors via environment variables
export MCFLY_PROMPT="❯ "
export MCFLY_RESULTS_SORT=LAST_RUN
```

### Filtering Commands
```bash
# Exclude certain commands from history
export MCFLY_HISTIGNORE="ls:cd:pwd:exit:clear"
```

## Performance Tuning

### Database Optimization
```bash
# Regular maintenance
mcfly vacuum

# Limit database size
export MCFLY_HISTORY_LIMIT=10000

# Optimize for speed
export MCFLY_DISABLE_MENU=true  # Disable menu for faster results
```

### Memory Usage
```bash
# Reduce memory usage
export MCFLY_RESULTS=25          # Fewer results
export MCFLY_DISABLE_MENU=true   # Disable visual menu
```

## Troubleshooting

### Common Issues

#### McFly not working after installation
```bash
# Verify installation
which mcfly
mcfly --version

# Check shell integration
echo $MCFLY_FUZZY
```

#### Key bindings not working
```bash
# Re-source shell configuration
source ~/.bashrc  # or ~/.zshrc

# Check if Ctrl+R is bound
bind -p | grep mcfly
```

#### Database corruption
```bash
# Backup current database
cp ~/.local/share/mcfly/history.db ~/.local/share/mcfly/history.db.backup

# Rebuild database
mcfly vacuum
```

#### Performance issues
```bash
# Check database size
ls -lh ~/.local/share/mcfly/history.db

# Reduce results
export MCFLY_RESULTS=25

# Disable fuzzy matching
export MCFLY_FUZZY=false
```

### Debugging
```bash
# Enable debug mode
export MCFLY_DEBUG=true

# Check logs
tail -f ~/.local/share/mcfly/mcfly.log
```

## Migration

### From Other Tools
```bash
# From standard bash/zsh history
mcfly import bash

# From fish history
mcfly import fish

# From fzf history setup
# McFly will automatically use existing history
```

### Backup and Restore
```bash
# Backup McFly database
cp ~/.local/share/mcfly/history.db ~/mcfly_backup.db

# Restore database
cp ~/mcfly_backup.db ~/.local/share/mcfly/history.db
```

## Scripts and Automation

### Useful Aliases
```bash
# Add to .bashrc/.zshrc
alias mcfly-stats="mcfly stats"
alias mcfly-clean="mcfly vacuum"
alias mcfly-backup="cp ~/.local/share/mcfly/history.db ~/mcfly_$(date +%Y%m%d).db"
```

### Maintenance Script
```bash
#!/bin/bash
# ~/.local/bin/mcfly-maintenance
set -e

echo "McFly Maintenance Script"
echo "======================="

# Show current stats
echo "Current database stats:"
mcfly stats

# Vacuum database
echo "Optimizing database..."
mcfly vacuum

# Show updated stats
echo "Updated database stats:"
mcfly stats

echo "Maintenance complete!"
```

### Auto-backup Script
```bash
#!/bin/bash
# ~/.local/bin/mcfly-auto-backup
BACKUP_DIR="$HOME/.mcfly-backups"
mkdir -p "$BACKUP_DIR"

# Keep last 7 days of backups
DATE=$(date +%Y%m%d)
cp ~/.local/share/mcfly/history.db "$BACKUP_DIR/history_$DATE.db"

# Clean old backups
find "$BACKUP_DIR" -name "history_*.db" -mtime +7 -delete
```

## Best Practices

1. **Use consistently**: The more you use McFly, the better it learns your patterns
2. **Import existing history**: Start with your existing command history
3. **Customize for your workflow**: Adjust settings to match your preferences
4. **Regular maintenance**: Periodically vacuum the database
5. **Backup important data**: Keep backups of your command history database

## Security and Privacy

- **Local storage**: All data is stored locally, never transmitted
- **No tracking**: McFly doesn't collect or transmit usage data
- **Database encryption**: Consider encrypting the database file if needed
- **History filtering**: Use MCFLY_HISTIGNORE to exclude sensitive commands

## Integration with Your Toolkit

McFly pairs excellently with:
- **starship**: Enhanced prompt with command context
- **fzf**: Complementary fuzzy finding for files
- **zoxide**: Smart directory navigation
- **ripgrep**: Fast text search
- **tmux**: Session management
- **git**: Version control workflows

## Updates and Maintenance

### Update McFly
```bash
# If installed via cargo
cargo install mcfly

# If installed via homebrew
brew upgrade mcfly

# If installed manually
curl -LO "https://github.com/cantino/mcfly/releases/latest/download/mcfly-v0.8.4-x86_64-unknown-linux-musl.tar.gz"
tar -xzf mcfly-v0.8.4-x86_64-unknown-linux-musl.tar.gz
sudo mv mcfly /usr/local/bin/
```

### Configuration Backup
```bash
# Backup McFly configuration
tar -czf mcfly-config-backup.tar.gz ~/.mcfly ~/.local/share/mcfly/
```

McFly transforms command history search from a basic text match into an intelligent, context-aware experience that learns from your usage patterns and provides more relevant results over time.

---

For more information:
- [McFly GitHub Repository](https://github.com/cantino/mcfly)
- [McFly Documentation](https://github.com/cantino/mcfly/blob/master/README.md)
- [Configuration Examples](https://github.com/cantino/mcfly/wiki/Configuration)