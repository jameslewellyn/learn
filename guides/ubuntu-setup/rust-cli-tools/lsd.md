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

## Usage Examples

```bash
# Basic listing
lsd

# Detailed list with permissions
lsd -l

# List all files including hidden
lsd -la

# Tree view
lsd --tree

# Sort by size
lsd -S

# Sort by modification time
lsd -t

# Show only directories
lsd -d */

# Recursive listing with depth limit
lsd --tree --depth 2
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