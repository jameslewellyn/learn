# LSD - Modern ls Alternative

LSD (LSDeluxe) is a modern `ls` command alternative with colors, icons, and tree view.

## Installation

```bash
cargo install lsd
```

## Basic Setup

### Shell Aliases

```bash
# Add aliases to your shell configuration
echo 'alias ls="lsd"' >> ~/.bashrc
echo 'alias ll="lsd -l"' >> ~/.bashrc
echo 'alias la="lsd -la"' >> ~/.bashrc
echo 'alias tree="lsd --tree"' >> ~/.bashrc
```

### Configuration

```bash
# Create configuration directory and file
mkdir -p ~/.config/lsd
cat > ~/.config/lsd/config.yaml << 'EOF'
classic: false
blocks:
  - permission
  - user
  - group
  - size
  - date
  - name
color:
  when: auto
date: relative
dereference: false
display: all
icons:
  when: auto
  theme: fancy
  separator: " "
indicators: false
layout: grid
recursion:
  enabled: false
  depth: 5
size: default
permission: rwx
sorting:
  column: name
  reverse: false
  dir-grouping: first
no-symlink: false
total-size: false
EOF
```

## Basic Usage

### Essential Commands

```bash
# Basic directory listing
lsd                              # List current directory
lsd /path/to/directory           # List specific directory

# Common listing formats
lsd -l                           # Long format (detailed info)
lsd -la                          # Long format with hidden files
lsd -a                           # Show hidden files

# Tree view
lsd --tree                       # Tree view of current directory
lsd --tree /path/to/directory    # Tree view of specific directory
```

### Quick Navigation

```bash
# List only directories
lsd -d */                        # Directories in current path
lsd -ld */                       # Directories with details

# List specific file types
lsd *.txt                        # All text files
lsd *.rs                         # All Rust files
lsd *.{jpg,png,gif}             # Image files

# Basic sorting
lsd -t                           # Sort by modification time (newest first)
lsd -S                           # Sort by size (largest first)
lsd -r                           # Reverse sort order
```

## Advanced Usage

### Tree Navigation and Structure

```bash
# Tree with depth control
lsd --tree --depth 2             # 2 levels deep
lsd --tree --depth 3 /usr/local  # 3 levels deep in specific path

# Tree with additional info
lsd --tree -l                    # Tree with long format
lsd --tree -a                    # Tree including hidden files
lsd --tree --size                # Tree with sizes

# Large directory handling
lsd --tree --depth 1             # Just one level for overview
lsd --tree | head -50            # Limit output for large trees
```

### Advanced Sorting and Filtering

```bash
# Multiple sorting criteria
lsd -lt                          # Long format, sorted by time
lsd -lS                          # Long format, sorted by size
lsd -lSr                         # Long format, sorted by size (reversed)

# Sort by different criteria
lsd --sort=size                  # Sort by size
lsd --sort=time                  # Sort by modification time
lsd --sort=name                  # Sort by name (default)
lsd --sort=version               # Sort by version numbers

# Directory grouping
lsd --group-dirs=first           # Directories first
lsd --group-dirs=last            # Directories last
lsd --group-dirs=none            # No grouping
```

### Display Control and Formatting

```bash
# Icon control
lsd --icon=always                # Always show icons
lsd --icon=never                 # Never show icons
lsd --icon=auto                  # Auto-detect terminal support

# Color control
lsd --color=always               # Force colors
lsd --color=never                # No colors
lsd --color=auto                 # Auto-detect

# Size display
lsd --size=default               # Default size format
lsd --size=short                 # Shorter size format
lsd --size=bytes                 # Show exact bytes

# Date format
lsd --date=relative              # Relative dates (2 hours ago)
lsd --date=iso                   # ISO format dates
lsd --date=+%Y-%m-%d             # Custom date format
```

### Advanced File Information

```bash
# Detailed information
lsd -l --blocks=all              # Show all information blocks
lsd -l --header                  # Show column headers

# Specific information blocks
lsd -l --blocks=permission,user,group,size,date,name
lsd -l --blocks=size,name        # Just size and name

# Permission details
lsd -l --permission=rwx          # Symbolic permissions
lsd -l --permission=octal        # Octal permissions

# File types and indicators
lsd -F                           # Add file type indicators
lsd --classify                   # Add classification symbols
```

### Integration with Other Tools

```bash
# Pipe to other commands
lsd -la | grep "^d"              # Find directories only
lsd -t | head -10                # 10 most recent files
lsd -S | tail -10                # 10 smallest files

# Use with find and fd
find . -name "*.rs" | while read f; do lsd -l "$f"; done
fd -e rs -x lsd -l {}

# Combine with grep
lsd -la | grep "$(date +%b)"     # Files modified this month
lsd -la | grep "^-.*x"           # Executable files

# With xargs
lsd -d */ | xargs -I {} lsd -la {}  # Detailed listing of each subdirectory
```

### Recursive Operations

```bash
# Recursive listing
lsd -R                           # Recursive listing
lsd -Ra                          # Recursive with hidden files
lsd -Rl                          # Recursive with details

# Recursive tree
lsd --tree                       # Tree view (recursive by nature)
lsd --tree --depth 3             # Limited depth tree

# Large directory handling
lsd -R | head -100               # Limit recursive output
lsd -R --color=never | wc -l     # Count all files recursively
```

### System Administration

```bash
# Permission analysis
lsd -la /etc | grep "^-.*r--"    # Read-only files
lsd -la /usr/bin | grep "^-.*s"  # SUID files
lsd -la /var/log                 # Log file analysis

# Disk usage overview
lsd -lS /var/log                 # Largest log files
lsd -lS /tmp                     # Largest temp files
lsd -lt /home/user               # Recently modified user files

# Security checks
lsd -la ~ | grep "^-.*w.*w"      # World-writable files
lsd -la /etc/ssh                 # SSH configuration
```

### Development Workflows

```bash
# Project overview
lsd --tree --depth 2             # Project structure overview
lsd -la | grep "^-.*x"           # Executable files/scripts

# Git repository analysis
lsd -la .git                     # Git internals
lsd --tree .git/refs             # Git references structure

# Build artifacts
lsd -lS target/                  # Rust build artifacts
lsd -lS node_modules/            # Node.js dependencies
lsd -lt build/                   # Recent build outputs

# Source code organization
lsd --tree src/                  # Source code structure
lsd -la tests/                   # Test files
lsd -la docs/                    # Documentation
```

### Performance and Output Control

```bash
# Fast listing for large directories
lsd --color=never                # Disable colors for speed
lsd --icon=never                 # Disable icons for speed
lsd -1                           # Single column output

# Scripting-friendly output
lsd -1 --color=never             # Machine-readable format
lsd -la --color=never | awk '{print $9}'  # Just filenames

# Memory considerations
lsd --depth 2                    # Limit depth for large directories
lsd | head -20                   # Limit output lines
```

### Custom Aliases and Functions

```bash
# Useful aliases to add to ~/.bashrc
alias ll='lsd -l'
alias la='lsd -la'
alias lt='lsd -lt'              # Sort by time
alias ls='lsd -lS'              # Sort by size
alias tree='lsd --tree'

# Useful functions
function lst() {
    lsd -lt "$@" | head -20      # 20 most recent files
}

function lss() {
    lsd -lS "$@" | head -20      # 20 largest files
}

function treelim() {
    lsd --tree --depth "${1:-3}" "${2:-.}"  # Limited depth tree
}
```

### Use Case Examples

```bash
# Clean up downloads
lsd -lt ~/Downloads | head -20   # Recent downloads
lsd -lS ~/Downloads | head -10   # Largest downloads

# System monitoring
lsd -lt /var/log | head -10      # Recent log activity
lsd -lS /tmp                     # Large temporary files

# Development cleanup
lsd -lS target/ | head -10       # Largest build artifacts
lsd -lt src/ | head -20          # Recently modified source

# Configuration management
lsd -la ~/.config                # User configurations
lsd --tree ~/.config/nvim        # Neovim configuration structure
```

## Key Features

- Colorful output with icons
- Tree view support
- Configurable display blocks
- Git status integration
- Size formatting
- Date formatting options

## Icon Themes

LSD supports different icon themes:
- `fancy` (default) - Colorful icons
- `unicode` - Unicode symbols
- `none` - No icons

## Sorting Options

- `name` (default)
- `size`
- `time`
- `version`
- `extension`

## Troubleshooting

- **Icons not showing**: Install a Nerd Font
- **Colors not working**: Check terminal color support
- **Performance**: Disable icons for large directories

## Alternative Installation

```bash
# Via package manager
sudo apt install lsd

# Via snap
sudo snap install lsd
```