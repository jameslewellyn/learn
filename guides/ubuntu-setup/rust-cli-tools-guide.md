# Rust CLI Tools Installation Guide

This guide covers installing popular Rust-based command-line tools from source using `cargo`. These tools are modern, fast alternatives to traditional Unix utilities.

## Prerequisites

- Rust toolchain installed (see [Rust Installation Guide](./rust-installation-guide.md))
- Basic development dependencies
- Internet connection

## Install Development Dependencies

First, install system dependencies that some tools may require:

```bash
sudo apt update
sudo apt install -y build-essential cmake pkg-config libfontconfig1-dev libfreetype6-dev libxcb-xfixes0-dev libxkbcommon-dev python3 libssl-dev libpcap-dev
```

## Tool Installation and Setup

### 1. Alacritty (Modern Terminal Emulator)

**Installation:**
```bash
cargo install alacritty
```

**Basic Setup:**
```bash
# Create config directory
mkdir -p ~/.config/alacritty

# Create basic configuration file
cat > ~/.config/alacritty/alacritty.yml << 'EOF'
window:
  padding:
    x: 10
    y: 10
  decorations: full
  startup_mode: Windowed

font:
  normal:
    family: "DejaVu Sans Mono"
    style: Regular
  size: 12.0

colors:
  primary:
    background: '0x1e1e1e'
    foreground: '0xd4d4d4'
  cursor:
    text: '0x1e1e1e'
    cursor: '0xd4d4d4'

scrolling:
  history: 10000

shell:
  program: /bin/bash
  args:
    - --login
EOF
```

**Desktop Integration:**
```bash
# Create desktop entry
cat > ~/.local/share/applications/alacritty.desktop << 'EOF'
[Desktop Entry]
Type=Application
TryExec=alacritty
Exec=alacritty
Icon=Alacritty
Terminal=false
Categories=System;TerminalEmulator;
Name=Alacritty
GenericName=Terminal
Comment=A cross-platform, GPU-accelerated terminal emulator
StartupWMClass=Alacritty
EOF
```

### 2. LSD (Modern ls Alternative)

**Installation:**
```bash
cargo install lsd
```

**Basic Setup:**
```bash
# Add aliases to your shell configuration
echo 'alias ls="lsd"' >> ~/.bashrc
echo 'alias ll="lsd -l"' >> ~/.bashrc
echo 'alias la="lsd -la"' >> ~/.bashrc
echo 'alias tree="lsd --tree"' >> ~/.bashrc

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

### 3. Ripgrep (Modern grep Alternative)

**Installation:**
```bash
cargo install ripgrep
```

**Basic Setup:**
```bash
# Add alias for shorter command
echo 'alias rg="ripgrep"' >> ~/.bashrc

# Create configuration file
cat > ~/.ripgreprc << 'EOF'
# Don't let ripgrep vomit really long lines to my terminal
--max-columns=150

# Add my 'web' type.
--type-add=web:*.{html,css,js}*

# Search hidden files and directories
--hidden

# Don't search in .git directories
--glob=!.git/*

# Using glob patterns to include/exclude files or folders
--glob=!node_modules/*
--glob=!target/*
--glob=!dist/*
--glob=!build/*
EOF

# Set environment variable to use config file
echo 'export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"' >> ~/.bashrc
```

### 4. FD (Modern find Alternative)

**Installation:**
```bash
cargo install fd-find
```

**Basic Setup:**
```bash
# Add aliases
echo 'alias find="fd"' >> ~/.bashrc

# Create configuration file
mkdir -p ~/.config/fd
cat > ~/.config/fd/ignore << 'EOF'
.git/
node_modules/
target/
dist/
build/
*.tmp
*.log
.DS_Store
EOF
```

### 5. SD (Modern sed Alternative)

**Installation:**
```bash
cargo install sd
```

**Basic Setup:**
```bash
# Add alias (optional, as sd is short enough)
echo 'alias sed="sd"' >> ~/.bashrc

# Example usage patterns (add to ~/.bashrc for quick reference)
cat >> ~/.bashrc << 'EOF'
# SD usage examples (commented out)
# sd 'old_text' 'new_text' file.txt              # Replace in file
# sd 'old_text' 'new_text' $(find . -name "*.txt")  # Replace in multiple files
# echo 'hello world' | sd 'world' 'universe'     # Pipe usage
EOF
```

### 6. Bandwhich (Network Utilization Monitor)

**Installation:**
```bash
cargo install bandwhich
```

**Basic Setup:**
```bash
# Bandwhich requires root privileges to monitor network traffic
# Create a simple wrapper script
sudo tee /usr/local/bin/bandwhich-monitor << 'EOF'
#!/bin/bash
sudo -E bandwhich "$@"
EOF

sudo chmod +x /usr/local/bin/bandwhich-monitor

# Add alias
echo 'alias bw="bandwhich-monitor"' >> ~/.bashrc
```

**Usage:**
```bash
# Monitor network usage
sudo bandwhich

# Monitor specific interface
sudo bandwhich -i eth0

# Raw mode (no TUI)
sudo bandwhich --raw
```

### 7. Dust (Modern du Alternative)

**Installation:**
```bash
cargo install du-dust
```

**Basic Setup:**
```bash
# Add aliases
echo 'alias du="dust"' >> ~/.bashrc
echo 'alias dust="dust -r"' >> ~/.bashrc  # Reverse order by default

# Create configuration file
mkdir -p ~/.config/dust
cat > ~/.config/dust/config.toml << 'EOF'
reverse = true
number_of_lines = 20
min_size = "1M"
EOF
```

### 8. Tealdeer (tldr Client)

**Installation:**
```bash
cargo install tealdeer
```

**Basic Setup:**
```bash
# Add alias
echo 'alias tldr="tldr"' >> ~/.bashrc

# Initialize the cache
tldr --update

# Set up configuration
mkdir -p ~/.config/tealdeer
cat > ~/.config/tealdeer/config.toml << 'EOF'
[display]
compact = false
use_pager = false

[updates]
auto_update = true
auto_update_interval_hours = 24

[style]
description.foreground = "white"
code.foreground = "green"
example_text.foreground = "blue"
EOF
```

### 9. Starship (Cross-shell Prompt)

**Installation:**
```bash
cargo install starship --locked
```

**Basic Setup:**
```bash
# Add to shell configuration
echo 'eval "$(starship init bash)"' >> ~/.bashrc

# Create configuration directory
mkdir -p ~/.config

# Create basic configuration
cat > ~/.config/starship.toml << 'EOF'
format = """
$username\
$hostname\
$directory\
$git_branch\
$git_state\
$git_status\
$cmd_duration\
$line_break\
$python\
$character"""

[directory]
style = "blue"
read_only = " "
truncation_length = 4
truncate_to_repo = true

[character]
success_symbol = "[❯](purple)"
error_symbol = "[❯](red)"
vicmd_symbol = "[❮](green)"

[git_branch]
format = "[$branch]($style)"
style = "bright-black"

[git_status]
format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)"
style = "cyan"
conflicted = "​"
untracked = "​"
modified = "​"
staged = "​"
renamed = "​"
deleted = "​"
stashed = "≡"

[git_state]
format = '\([$state( $progress_current/$progress_total)]($style)\) '
style = "bright-black"

[cmd_duration]
format = "[$duration]($style) "
style = "yellow"

[python]
format = "[$virtualenv]($style) "
style = "bright-black"
EOF
```

### 10. Bat (Modern cat Alternative)

**Installation:**
```bash
cargo install bat
```

**Basic Setup:**
```bash
# Add aliases
echo 'alias cat="bat"' >> ~/.bashrc
echo 'alias less="bat"' >> ~/.bashrc

# Create configuration directory
mkdir -p ~/.config/bat

# Create configuration file
cat > ~/.config/bat/config << 'EOF'
--theme="OneHalfDark"
--style="numbers,changes,header"
--italic-text=always
--paging=auto
--wrap=never
--tabs=2
EOF

# Set environment variable
echo 'export BAT_THEME="OneHalfDark"' >> ~/.bashrc
```

### 11. Delta (Git Diff Viewer)

**Installation:**
```bash
cargo install git-delta
```

**Basic Setup:**
```bash
# Configure git to use delta
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global delta.light false
git config --global delta.side-by-side true
git config --global merge.conflictstyle diff3
git config --global diff.colorMoved default

# Create delta configuration
cat >> ~/.gitconfig << 'EOF'
[delta]
    features = decorations
    whitespace-error-style = 22 reverse
    
[delta "decorations"]
    commit-decoration-style = bold yellow box ul
    file-style = bold yellow ul
    file-decoration-style = none
    hunk-header-decoration-style = yellow box
EOF
```

### 12. Zoxide (Smart cd)

**Installation:**
```bash
cargo install zoxide
```

**Basic Setup:**
```bash
# Add to shell configuration
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc

# Add aliases
echo 'alias cd="z"' >> ~/.bashrc
echo 'alias cdi="zi"' >> ~/.bashrc  # Interactive mode

# Create configuration directory
mkdir -p ~/.config/zoxide

# Note: zoxide learns from your usage patterns automatically
```

### 13. Broot (Interactive Tree Navigation)

**Installation:**
```bash
cargo install broot
```

**Basic Setup:**
```bash
# Initialize broot (creates config and shell integration)
broot --install

# Add alias
echo 'alias tree="broot"' >> ~/.bashrc
echo 'alias br="broot"' >> ~/.bashrc

# Configuration is automatically created at ~/.config/broot/conf.hjson
# You can customize it after first run
```

### 14. Ouch (Archive Tool)

**Installation:**
```bash
cargo install ouch
```

**Basic Setup:**
```bash
# Add convenient aliases
echo 'alias extract="ouch decompress"' >> ~/.bashrc
echo 'alias compress="ouch compress"' >> ~/.bashrc

# Example usage functions
cat >> ~/.bashrc << 'EOF'
# Quick archive extraction
function unpack() {
    if [ -f "$1" ]; then
        ouch decompress "$1"
    else
        echo "File not found: $1"
    fi
}

# Quick archive creation
function pack() {
    if [ -z "$2" ]; then
        echo "Usage: pack <source> <archive_name>"
    else
        ouch compress "$1" "$2"
    fi
}
EOF
```

### 15. Bottom (System Monitor)

**Installation:**
```bash
cargo install bottom
```

**Basic Setup:**
```bash
# Add aliases
echo 'alias top="btm"' >> ~/.bashrc
echo 'alias htop="btm"' >> ~/.bashrc

# Create configuration directory
mkdir -p ~/.config/bottom

# Create basic configuration
cat > ~/.config/bottom/bottom.toml << 'EOF'
[flags]
dot_marker = false
temperature_type = "celsius"
rate = 1000
left_legend = false
current_usage = false
group_processes = false
case_sensitive = false
whole_word = false
regex = false
basic = false
default_time_value = 60000
time_delta = 15000
hide_time = false
autohide_time = false
default_widget_type = "proc"
default_widget_count = 1
disable_click = false
color = "default"
mem_as_value = false
tree = false
show_table_scroll_position = false
process_command = false
disable_advanced_kill = false
network_use_binary_prefix = false
network_use_bytes = false
network_use_log = false
enable_gpu_memory = false
retain_for_current_network = false
EOF
```

### 16. Procs (Modern ps)

**Installation:**
```bash
cargo install procs
```

**Basic Setup:**
```bash
# Add alias
echo 'alias ps="procs"' >> ~/.bashrc

# Create configuration directory
mkdir -p ~/.config/procs

# Create configuration file
cat > ~/.config/procs/config.toml << 'EOF'
[[columns]]
kind = "Pid"
style = "BrightYellow"
numeric_search = true
nonnumeric_search = false

[[columns]]
kind = "User"
style = "BrightGreen"
numeric_search = false
nonnumeric_search = true

[[columns]]
kind = "Separator"
style = "White"
numeric_search = false
nonnumeric_search = false

[[columns]]
kind = "Tty"
style = "BrightWhite"
numeric_search = false
nonnumeric_search = false

[[columns]]
kind = "UsageCpu"
style = "BrightMagenta"
numeric_search = false
nonnumeric_search = false

[[columns]]
kind = "UsageMemory"
style = "BrightCyan"
numeric_search = false
nonnumeric_search = false

[[columns]]
kind = "CpuTime"
style = "White"
numeric_search = false
nonnumeric_search = false

[[columns]]
kind = "Command"
style = "BrightWhite"
numeric_search = false
nonnumeric_search = true

[style]
header = "BrightWhite"
EOF
```

### 17. Hyperfine (Benchmarking Tool)

**Installation:**
```bash
cargo install hyperfine
```

**Basic Setup:**
```bash
# Add convenient function for quick benchmarking
cat >> ~/.bashrc << 'EOF'
# Quick benchmark function
function benchmark() {
    if [ -z "$1" ]; then
        echo "Usage: benchmark <command>"
        echo "Example: benchmark 'ls -la'"
    else
        hyperfine --warmup 3 --min-runs 5 "$1"
    fi
}

# Compare two commands
function compare() {
    if [ -z "$2" ]; then
        echo "Usage: compare <command1> <command2>"
        echo "Example: compare 'ls -la' 'lsd -la'"
    else
        hyperfine --warmup 3 --min-runs 5 "$1" "$2"
    fi
}
EOF
```

### 18. Tokei (Code Statistics)

**Installation:**
```bash
cargo install tokei
```

**Basic Setup:**
```bash
# Add aliases for common usage
echo 'alias count="tokei"' >> ~/.bashrc
echo 'alias loc="tokei"' >> ~/.bashrc

# Create configuration directory
mkdir -p ~/.config/tokei

# Helpful functions
cat >> ~/.bashrc << 'EOF'
# Quick code stats for current directory
function codestats() {
    echo "Code statistics for $(pwd):"
    tokei --sort code
}

# Code stats with specific language
function langstats() {
    if [ -z "$1" ]; then
        echo "Usage: langstats <language>"
        echo "Example: langstats rust"
    else
        tokei --type "$1"
    fi
}
EOF
```

### 19. Bacon (Background Code Checker)

**Installation:**
```bash
cargo install bacon
```

**Basic Setup:**
```bash
# Bacon is primarily used within Rust projects
# Add convenient aliases
echo 'alias check="bacon check"' >> ~/.bashrc
echo 'alias test="bacon test"' >> ~/.bashrc
echo 'alias clippy="bacon clippy"' >> ~/.bashrc

# Create default configuration (run in Rust project root)
cat >> ~/.bashrc << 'EOF'
# Initialize bacon in a Rust project
function bacon_init() {
    if [ -f "Cargo.toml" ]; then
        bacon --init
        echo "Bacon initialized in $(pwd)"
    else
        echo "Not a Rust project (no Cargo.toml found)"
    fi
}
EOF
```

### 20. Cargo-nextest (Advanced Test Runner)

**Installation:**
```bash
cargo install cargo-nextest --locked
```

**Basic Setup:**
```bash
# Add aliases for testing
echo 'alias test="cargo nextest run"' >> ~/.bashrc
echo 'alias testall="cargo nextest run --all-features"' >> ~/.bashrc

# Create configuration directory
mkdir -p ~/.config/nextest

# Create basic configuration
cat > ~/.config/nextest/config.toml << 'EOF'
[profile.default]
retries = 2
fail-fast = false
test-threads = "num-cpus"

[profile.ci]
retries = 0
fail-fast = true
test-threads = 1

[profile.default.junit]
path = "target/nextest/ci/junit.xml"
EOF
```

### 21. Zellij (Terminal Multiplexer)

**Installation:**
```bash
cargo install zellij
```

**Basic Setup:**
```bash
# Add aliases
echo 'alias tmux="zellij"' >> ~/.bashrc
echo 'alias zj="zellij"' >> ~/.bashrc

# Create configuration directory
mkdir -p ~/.config/zellij

# Create basic configuration
cat > ~/.config/zellij/config.kdl << 'EOF'
theme "default"
default_shell "bash"
pane_frames false
mouse_mode true
scroll_buffer_size 10000
copy_command "wl-copy"
copy_clipboard "system"
copy_on_select false
scrollback_editor "vim"

keybinds {
    normal {
        bind "Alt h" { MoveFocus "Left"; }
        bind "Alt l" { MoveFocus "Right"; }
        bind "Alt j" { MoveFocus "Down"; }
        bind "Alt k" { MoveFocus "Up"; }
        bind "Alt n" { NewPane; }
        bind "Alt x" { CloseFocus; }
        bind "Alt t" { NewTab; }
        bind "Alt 1" { GoToTab 1; }
        bind "Alt 2" { GoToTab 2; }
        bind "Alt 3" { GoToTab 3; }
        bind "Alt 4" { GoToTab 4; }
        bind "Alt 5" { GoToTab 5; }
    }
}
EOF
```

### 22. Jaq (JSON Processor)

**Installation:**
```bash
cargo install jaq
```

**Basic Setup:**
```bash
# Add alias as jq alternative
echo 'alias jq="jaq"' >> ~/.bashrc

# Helpful functions for JSON processing
cat >> ~/.bashrc << 'EOF'
# Pretty print JSON
function jsonpp() {
    if [ -z "$1" ]; then
        jaq '.'
    else
        jaq '.' "$1"
    fi
}

# Extract specific field from JSON
function jsonget() {
    if [ -z "$1" ]; then
        echo "Usage: jsonget <field> [file]"
        echo "Example: jsonget '.name' data.json"
        echo "Example: echo '{\"name\":\"test\"}' | jsonget '.name'"
    else
        if [ -z "$2" ]; then
            jaq "$1"
        else
            jaq "$1" "$2"
        fi
    fi
}
EOF
```

### 23. Watchexec (File Watcher)

**Installation:**
```bash
cargo install watchexec-cli
```

**Basic Setup:**
```bash
# Add alias
echo 'alias watch="watchexec"' >> ~/.bashrc

# Helpful functions
cat >> ~/.bashrc << 'EOF'
# Watch and run command on file changes
function watchrun() {
    if [ -z "$1" ]; then
        echo "Usage: watchrun <command>"
        echo "Example: watchrun 'cargo test'"
    else
        watchexec --clear "$1"
    fi
}

# Watch specific file types
function watchext() {
    if [ -z "$2" ]; then
        echo "Usage: watchext <extension> <command>"
        echo "Example: watchext rs 'cargo check'"
    else
        watchexec --exts "$1" --clear "$2"
    fi
}

# Watch and restart command
function watchrestart() {
    if [ -z "$1" ]; then
        echo "Usage: watchrestart <command>"
        echo "Example: watchrestart 'cargo run'"
    else
        watchexec --restart --clear "$1"
    fi
}
EOF
```

### 24. Choose (Field Selector)

**Installation:**
```bash
cargo install choose
```

**Basic Setup:**
```bash
# Add helpful functions
cat >> ~/.bashrc << 'EOF'
# Choose specific fields (alternative to cut/awk)
function field() {
    if [ -z "$1" ]; then
        echo "Usage: field <field_number> [delimiter]"
        echo "Example: echo 'a,b,c' | field 1"
        echo "Example: echo 'a:b:c' | field 1 ':'"
    else
        if [ -z "$2" ]; then
            choose "$1"
        else
            choose -f "$2" "$1"
        fi
    fi
}

# Choose range of fields
function fields() {
    if [ -z "$1" ]; then
        echo "Usage: fields <start:end> [delimiter]"
        echo "Example: echo 'a,b,c,d' | fields 1:2"
    else
        if [ -z "$2" ]; then
            choose "$1"
        else
            choose -f "$2" "$1"
        fi
    fi
}
EOF
```

### 25. Huniq (Unique Lines)

**Installation:**
```bash
cargo install huniq
```

**Basic Setup:**
```bash
# Add alias
echo 'alias uniq="huniq"' >> ~/.bashrc

# Helpful functions
cat >> ~/.bashrc << 'EOF'
# Remove duplicate lines (preserving order)
function unique() {
    if [ -z "$1" ]; then
        huniq
    else
        huniq < "$1"
    fi
}

# Count unique lines
function uniquecount() {
    if [ -z "$1" ]; then
        huniq --count
    else
        huniq --count < "$1"
    fi
}
EOF
```

## Tool Usage Examples

### Quick Reference

```bash
# File listing with LSD
lsd -la                    # Detailed list
lsd --tree                 # Tree view

# Searching with Ripgrep
rg "pattern" .             # Search in current directory
rg -i "pattern" .          # Case insensitive search
rg -t py "pattern" .       # Search only Python files

# Finding files with FD
fd filename                # Find by name
fd -e txt                  # Find by extension
fd -t f pattern            # Find files matching pattern

# Text replacement with SD
sd 'old' 'new' file.txt    # Replace in file
sd 'old' 'new' **/*.txt    # Replace in all txt files

# Directory usage with Dust
dust                       # Show disk usage
dust -d 2                  # Limit depth to 2
dust -r                    # Reverse order

# Help with Tealdeer
tldr ls                    # Show examples for ls command
tldr -u                    # Update cache

# Network monitoring with Bandwhich
sudo bandwhich             # Monitor network usage
sudo bandwhich -i wlan0    # Monitor specific interface

# File viewing with Bat
bat file.txt               # View file with syntax highlighting
bat -n file.txt            # Show line numbers
bat -A file.txt            # Show all characters

# Git diffs with Delta
git diff                   # View diff with Delta
git log -p                 # View commit history with diffs
git show                   # Show commit details

# Smart navigation with Zoxide
z project                  # Jump to project directory
zi                         # Interactive directory selection
z -                        # Go to previous directory

# Interactive tree with Broot
br                         # Launch broot
broot -h                   # Show hidden files
broot -s                   # Show sizes

# Archive handling with Ouch
ouch compress file.txt archive.tar.gz    # Create archive
ouch decompress archive.tar.gz           # Extract archive
ouch list archive.tar.gz                 # List archive contents

# System monitoring with Bottom
btm                        # Launch bottom
btm -b                     # Basic mode
btm -t                     # Show tree view

# Process monitoring with Procs
procs                      # Show all processes
procs firefox              # Search for firefox processes
procs --tree               # Show process tree

# Benchmarking with Hyperfine
hyperfine 'command1' 'command2'          # Compare commands
hyperfine --warmup 3 'command'           # Warmup runs
hyperfine --export-json results.json 'cmd' # Export results

# Code statistics with Tokei
tokei                      # Show code stats
tokei --sort code          # Sort by lines of code
tokei --languages          # Show supported languages

# Background checking with Bacon
bacon check                # Run continuous cargo check
bacon test                 # Run continuous tests
bacon clippy               # Run continuous clippy

# Testing with Nextest
cargo nextest run          # Run tests with nextest
cargo nextest run --all-features  # Run with all features
cargo nextest list         # List available tests

# Terminal multiplexing with Zellij
zellij                     # Launch zellij
zellij attach session     # Attach to session
zellij ls                  # List sessions

# JSON processing with Jaq
echo '{"name": "test"}' | jaq '.name'     # Extract field
jaq '.[] | .name' data.json               # Process array
jaq 'keys' data.json                      # Get object keys

# File watching with Watchexec
watchexec 'cargo test'     # Run tests on file changes
watchexec -e rs 'cargo check'  # Watch only .rs files
watchexec --restart 'cargo run'  # Restart on changes

# Field selection with Choose
echo 'a,b,c' | choose 1    # Select second field
echo 'a:b:c' | choose -f ':' 1  # Custom delimiter
echo 'a,b,c,d' | choose 1:2     # Select range

# Unique lines with Huniq
cat file.txt | huniq       # Remove duplicates
cat file.txt | huniq --count  # Count unique lines
```

## Additional Configuration Tips

### 1. Create a Tools Update Script

Create a script to update all cargo-installed tools:

```bash
cat > ~/update-rust-tools.sh << 'EOF'
#!/bin/bash
echo "Updating Rust toolchain..."
rustup update

echo "Updating cargo-installed tools..."
cargo install-update -a

echo "Updating tealdeer cache..."
tldr --update

echo "Updating broot if configuration changed..."
broot --install

echo "All tools updated!"
echo ""
echo "Installed tools:"
cargo install --list | grep -E "(alacritty|lsd|ripgrep|fd-find|sd|bandwhich|du-dust|tealdeer|starship|bat|git-delta|zoxide|broot|ouch|bottom|procs|hyperfine|tokei|bacon|cargo-nextest|zellij|jaq|watchexec-cli|choose|huniq)"
EOF

chmod +x ~/update-rust-tools.sh
```

### 2. Shell Integration

Add these helpful functions to your `~/.bashrc`:

```bash
# Add to ~/.bashrc
cat >> ~/.bashrc << 'EOF'
# Rust tools integration
function fzf-rg() {
    rg --color=always --line-number --no-heading --smart-case "${*:-}" |
        fzf --ansi \
            --color "hl:-1:underline,hl+:-1:underline:reverse" \
            --delimiter : \
            --preview 'bat --color=always {1} --highlight-line {2}' \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'
}

function fzf-fd() {
    fd --type f --hidden --follow --exclude .git |
        fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'
}
EOF
```

### 3. Performance Optimization

For better performance, consider these settings:

```bash
# Add to ~/.bashrc
echo 'export RUST_BACKTRACE=1' >> ~/.bashrc  # Better error messages
echo 'export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"' >> ~/.bashrc
```

## Troubleshooting

### Common Issues

1. **Compilation errors**: Ensure all development dependencies are installed
2. **Permission issues**: Don't use `sudo` with cargo install
3. **PATH issues**: Make sure `~/.cargo/bin` is in your PATH
4. **Missing dependencies**: Install system packages as needed

### Useful Commands

```bash
# Check installed cargo packages
cargo install --list

# Update all cargo packages
cargo install-update -a  # requires cargo-update

# Uninstall a package
cargo uninstall package_name

# Check tool versions
alacritty --version
lsd --version
rg --version
fd --version
sd --version
dust --version
tldr --version
starship --version
bat --version
delta --version
zoxide --version
broot --version
ouch --version
btm --version
procs --version
hyperfine --version
tokei --version
bacon --version
cargo nextest --version
zellij --version
jaq --version
watchexec --version
choose --version
huniq --version
```

## Alternative Installation Methods

While this guide uses `cargo install`, you can also install these tools via:

1. **System package manager** (may have older versions):
```bash
sudo apt install ripgrep fd-find
```

2. **Precompiled binaries** from GitHub releases
3. **Snap packages**:
```bash
sudo snap install ripgrep
sudo snap install starship
```

The `cargo install` method ensures you get the latest version and all features compiled for your system.

## Quick Install All Tools

If you want to install all the tools at once, you can run:

```bash
# Install all tools in one command (this will take a while)
cargo install alacritty lsd ripgrep fd-find sd bandwhich du-dust tealdeer starship bat git-delta zoxide broot ouch bottom procs hyperfine tokei bacon cargo-nextest zellij jaq watchexec-cli choose huniq

# Initialize tools that need setup
broot --install
tldr --update
```

**Note:** This will take significant time to compile all tools. Consider installing them individually or in smaller batches for better control over the process.

---

**Enjoy your supercharged command-line experience!** 🚀