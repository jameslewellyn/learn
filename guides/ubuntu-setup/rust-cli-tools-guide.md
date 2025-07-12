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
sudo apt install -y build-essential cmake pkg-config libfontconfig1-dev libfreetype6-dev libxcb-xfixes0-dev libxkbcommon-dev python3
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

echo "All tools updated!"
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

---

**Enjoy your supercharged command-line experience!** 🚀