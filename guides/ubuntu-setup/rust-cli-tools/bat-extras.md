# Bat-Extras - Extended Tools for Bat Installation and Setup Guide

## Overview

**Bat-extras** is a collection of additional tools that extend the functionality of `bat` (a modern replacement for `cat`). These tools provide enhanced utilities for viewing, comparing, and searching through files with syntax highlighting and Git integration.

### Key Features
- **batdiff**: Enhanced diff viewer with syntax highlighting
- **batgrep**: Grep with context and syntax highlighting
- **batwatch**: Watch files and display changes with bat
- **batman**: View man pages with bat's syntax highlighting
- **batpipe**: Use bat as a pager for various commands

### Why Use Bat-Extras?
- Seamless integration with bat's syntax highlighting
- Enhanced diff viewing with side-by-side comparisons
- Better grep output with context and colors
- Improved man page reading experience
- Consistent interface across all tools

## Installation

### Prerequisites
- `bat` must be installed first
- `git` for batdiff functionality
- `ripgrep` for enhanced grep features

### Via Mise (Recommended)
```bash
# Install bat-extras via mise
mise use -g bat-extras

# Verify installation
batdiff --version
batgrep --version
batman --version
```

### Manual Installation
```bash
# Clone the repository
git clone https://github.com/eth-p/bat-extras.git
cd bat-extras

# Build and install
./build.sh --install

# Or install to custom location
./build.sh --install --prefix ~/.local
```

### Verify Installation
```bash
# Check available tools
ls -la ~/.local/share/mise/installs/bat-extras/*/bin/

# Test basic functionality
echo "Hello, World!" | batgrep "Hello"
```

## Configuration

### Shell Integration
```bash
# Add to ~/.bashrc or ~/.zshrc
export BAT_EXTRAS_CONFIG_DIR="$HOME/.config/bat-extras"
mkdir -p "$BAT_EXTRAS_CONFIG_DIR"

# Create global config
cat > "$BAT_EXTRAS_CONFIG_DIR/config" << 'EOF'
# Global bat-extras configuration
BAT_STYLE="numbers,changes,header"
BAT_THEME="base16"
EOF
```

### Individual Tool Configuration
```bash
# Configure batdiff
cat > ~/.config/bat-extras/batdiff.conf << 'EOF'
# Batdiff configuration
--delta-features="+line-numbers +decorations"
--delta-syntax-theme="base16"
EOF

# Configure batgrep
cat > ~/.config/bat-extras/batgrep.conf << 'EOF'
# Batgrep configuration
--context=3
--color=always
--smart-case
EOF
```

## Basic Usage

### batdiff - Enhanced Diff Viewer
```bash
# Compare two files
batdiff file1.txt file2.txt

# Compare with Git
batdiff HEAD~1 HEAD
git diff | batdiff

# Show only changes (no context)
batdiff --context=0 file1.txt file2.txt
```

### batgrep - Enhanced Grep
```bash
# Search with context
batgrep "function" *.js

# Search with line numbers
batgrep --line-number "TODO" src/

# Case-insensitive search
batgrep --ignore-case "error" logs/
```

### batman - Enhanced Man Pages
```bash
# View man page with syntax highlighting
batman ls
batman grep
batman bash

# Use as default pager for man
export MANPAGER="batman"
```

### batwatch - File Watcher
```bash
# Watch file for changes
batwatch config.log

# Watch with custom delay
batwatch --delay 2 server.log

# Watch multiple files
batwatch file1.txt file2.txt
```

### batpipe - Enhanced Pager
```bash
# Use as pager for various commands
export PAGER="batpipe"

# View JSON with highlighting
curl -s https://api.github.com/users/octocat | batpipe

# View logs with highlighting
tail -f /var/log/syslog | batpipe
```

## Advanced Usage

### Custom Diff Configurations
```bash
# Create advanced batdiff wrapper
cat > ~/.local/bin/mydiff << 'EOF'
#!/bin/bash
batdiff \
  --delta-features="+line-numbers +decorations +side-by-side" \
  --delta-syntax-theme="Monokai Extended" \
  --delta-line-numbers-left-format="{nm:>4}│" \
  --delta-line-numbers-right-format="{np:>4}│" \
  "$@"
EOF
chmod +x ~/.local/bin/mydiff
```

### Advanced Grep Patterns
```bash
# Search with complex patterns
batgrep -e "function\s+\w+" --type js src/

# Search with file type filtering
batgrep "error" --type-add 'log:*.log' --type log .

# Search with exclusions
batgrep "TODO" --glob '!node_modules' --glob '!*.min.js' .
```

### Integration with Git
```bash
# Configure git to use batdiff
git config --global core.pager "batpipe"
git config --global diff.tool batdiff
git config --global difftool.batdiff.cmd 'batdiff "$LOCAL" "$REMOTE"'

# Use in git aliases
git config --global alias.d "difftool --no-prompt"
```

### Custom Themes and Styles
```bash
# Create custom theme configuration
mkdir -p ~/.config/bat-extras/themes
cat > ~/.config/bat-extras/themes/custom.conf << 'EOF'
# Custom theme for bat-extras
BAT_THEME="ansi"
BAT_STYLE="numbers,changes,header,grid"
BATDIFF_DELTA_THEME="GitHub"
BATGREP_CONTEXT_LINES=5
EOF

# Use custom theme
export BAT_EXTRAS_THEME_CONFIG="$HOME/.config/bat-extras/themes/custom.conf"
```

### Performance Optimization
```bash
# Optimize for large files
export BAT_EXTRAS_LARGE_FILE_THRESHOLD="10MB"
export BAT_EXTRAS_USE_LESS_FOR_LARGE_FILES=true

# Configure caching
export BAT_EXTRAS_CACHE_DIR="$HOME/.cache/bat-extras"
mkdir -p "$BAT_EXTRAS_CACHE_DIR"
```

### Advanced Batwatch Usage
```bash
# Watch with custom command
batwatch --command "echo 'File changed at $(date)'" config.txt

# Watch directory recursively
batwatch --recursive --pattern "*.log" /var/log/

# Watch with filtering
batwatch --filter "error\|warning" server.log
```

### Scripting Integration
```bash
#!/bin/bash
# Advanced log analysis script
LOG_FILE="$1"
PATTERN="$2"

# Use batgrep for initial search
echo "=== Searching for '$PATTERN' in $LOG_FILE ==="
batgrep --context=2 --line-number "$PATTERN" "$LOG_FILE"

# Use batwatch for real-time monitoring
echo "=== Monitoring for new occurrences ==="
batwatch --filter "$PATTERN" "$LOG_FILE"
```

### Custom Aliases and Functions
```bash
# Add to ~/.bashrc or ~/.zshrc
alias bcat='bat --paging=never'
alias bdiff='batdiff --delta-features="+side-by-side"'
alias bgrep='batgrep --context=3 --line-number'
alias bman='batman'

# Custom function for quick file comparison
compare() {
    if [ $# -eq 2 ]; then
        batdiff "$1" "$2"
    else
        echo "Usage: compare <file1> <file2>"
    fi
}

# Function to search and view files
search_view() {
    local pattern="$1"
    local files=$(batgrep -l "$pattern" . 2>/dev/null)
    if [ -n "$files" ]; then
        echo "Files containing '$pattern':"
        echo "$files"
        echo
        echo "Content preview:"
        echo "$files" | head -5 | xargs -I {} sh -c 'echo "=== {} ===" && batgrep --context=1 "$1" "{}"' _ "$pattern"
    else
        echo "No files found containing '$pattern'"
    fi
}
```

## Troubleshooting

### Common Issues

**Issue**: `batdiff` not showing colors
```bash
# Solution: Check delta configuration
batdiff --help | grep -A 10 "DELTA"
export BAT_EXTRAS_DELTA_FEATURES="+decorations +line-numbers"
```

**Issue**: `batgrep` too slow on large directories
```bash
# Solution: Use file type filtering
batgrep --type-add 'source:*.{js,py,go}' --type source "pattern" .
```

**Issue**: `batman` not working as MANPAGER
```bash
# Solution: Check man configuration
export MANPAGER="batman"
export MANROFFOPT="-c"
```

### Performance Tips
```bash
# Limit context for better performance
export BATGREP_DEFAULT_CONTEXT=1

# Use ripgrep backend for better performance
export BATGREP_RIPGREP_OPTS="--hidden --follow"

# Cache theme compilation
export BAT_CACHE_PATH="$HOME/.cache/bat"
```

## Integration Examples

### With Development Workflow
```bash
# Code review helper
review() {
    local branch="${1:-main}"
    git diff "$branch"...HEAD | batdiff
}

# Quick documentation lookup
doc() {
    local cmd="$1"
    if man -w "$cmd" >/dev/null 2>&1; then
        batman "$cmd"
    else
        echo "No manual entry for $cmd"
    fi
}
```

### With System Administration
```bash
# Enhanced log monitoring
monitor_logs() {
    local logfile="${1:-/var/log/syslog}"
    local pattern="${2:-error}"
    
    echo "Monitoring $logfile for '$pattern'"
    batwatch --filter "$pattern" "$logfile"
}

# System diff checker
check_config() {
    local config="$1"
    local backup="${config}.backup"
    
    if [ -f "$backup" ]; then
        batdiff "$backup" "$config"
    else
        echo "No backup found for $config"
    fi
}
```

## Resources and References

- [Bat-extras GitHub Repository](https://github.com/eth-p/bat-extras)
- [Bat Documentation](https://github.com/sharkdp/bat)
- [Delta Configuration](https://github.com/dandavison/delta)
- [Ripgrep Documentation](https://github.com/BurntSushi/ripgrep)

This guide provides comprehensive coverage of bat-extras installation, configuration, and usage patterns for enhanced file viewing and comparison workflows.