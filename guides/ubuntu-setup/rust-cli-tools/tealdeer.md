# Tealdeer - Fast tldr Client

Tealdeer is a fast implementation of tldr (simplified man pages) written in Rust.

## Installation

```bash
cargo install tealdeer
```

## Basic Setup

### Shell Aliases

```bash
# Add alias
echo 'alias tldr="tldr"' >> ~/.bashrc
```

### Initial Setup

```bash
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

## Usage Examples

```bash
# Get help for a command
tldr ls

# Get help for a specific platform
tldr --platform linux ls

# Search for commands
tldr --search "compress"

# List all available commands
tldr --list

# Update cache
tldr --update

# Show version
tldr --version

# Clear cache
tldr --clear-cache

# Show cache location
tldr --print-cache-dir

# Show random example
tldr --random

# Show raw markdown
tldr --raw tar

# Show specific language
tldr --language es ls
```

## Key Features

- Fast Rust implementation
- Offline cache
- Colored output
- Multiple platforms support
- Search functionality
- Auto-update cache
- Configurable styling

## Configuration

The configuration file at `~/.config/tealdeer/config.toml` supports:

### Display Options
- `compact` - Compact output format
- `use_pager` - Use pager for long output

### Update Options
- `auto_update` - Automatically update cache
- `auto_update_interval_hours` - Update interval

### Style Options
- `description.foreground` - Description text color
- `code.foreground` - Code example color
- `example_text.foreground` - Example text color

## Color Options

Available colors:
- `black`, `red`, `green`, `yellow`
- `blue`, `magenta`, `cyan`, `white`
- `bright_black`, `bright_red`, etc.

## Platforms

Supported platforms:
- `linux`
- `macos`
- `windows`
- `sunos`
- `osx`
- `android`

## Languages

Tealdeer supports multiple languages:
- `en` (English, default)
- `es` (Spanish)
- `pt` (Portuguese)
- `de` (German)
- `fr` (French)
- `it` (Italian)
- `ja` (Japanese)
- `ko` (Korean)
- `zh` (Chinese)

## Cache Management

```bash
# Update cache manually
tldr --update

# Check cache status
tldr --print-cache-dir

# Clear cache
tldr --clear-cache

# Show cache statistics
tldr --version  # Shows cache info
```

## Search Functionality

```bash
# Search for commands containing keyword
tldr --search "file"

# Search for specific functionality
tldr --search "compress"

# Search with regex
tldr --search "git.*branch"
```

## Common Use Cases

### Learning New Commands
```bash
# Learn basic usage
tldr git
tldr docker
tldr curl

# Learn specific functionality
tldr tar
tldr grep
tldr find
```

### Quick Reference
```bash
# Quick syntax reminder
tldr awk
tldr sed
tldr rsync

# Platform-specific usage
tldr --platform linux systemctl
tldr --platform macos brew
```

## Integration with Other Tools

### Shell Functions
```bash
# Add to ~/.bashrc
function man() {
    if tldr "$1" 2>/dev/null; then
        echo "Press 'q' to continue to full man page..."
        read -n 1
        command man "$1"
    else
        command man "$1"
    fi
}
```

### Alias Combinations
```bash
# Quick help function
function help() {
    tldr "$1" || man "$1"
}
```

## Troubleshooting

- **No pages found**: Update cache with `tldr --update`
- **Network errors**: Check internet connection
- **Outdated examples**: Update cache regularly
- **Missing commands**: Some commands may not have tldr pages

## Comparison with man

Tealdeer advantages:
- Practical examples
- Faster lookup
- Simplified explanations
- Colored output
- Cross-platform

Traditional man advantages:
- Complete documentation
- Detailed explanations
- Always available
- Authoritative source

## Alternative Installation

```bash
# Via package manager (if available)
sudo apt install tealdeer

# Via snap
sudo snap install tealdeer
```

## Contributing

tldr pages are community-driven. You can contribute at:
- GitHub: https://github.com/tldr-pages/tldr
- Guidelines: https://github.com/tldr-pages/tldr/blob/main/CONTRIBUTING.md