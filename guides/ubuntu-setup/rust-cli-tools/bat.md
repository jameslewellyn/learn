# Bat - Modern cat Alternative

Bat is a cat clone with syntax highlighting and Git integration.

## Installation

```bash
cargo install bat
```

## Basic Setup

### Shell Aliases

```bash
# Add aliases
echo 'alias cat="bat"' >> ~/.bashrc
echo 'alias less="bat"' >> ~/.bashrc
```

### Configuration

```bash
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

## Basic Usage

### Essential Commands

```bash
# View files with syntax highlighting
bat file.txt
bat script.py
bat config.json

# View multiple files
bat file1.txt file2.txt file3.py

# View with line numbers (default in most configs)
bat -n file.txt

# View without decorations (plain cat behavior)
bat -p file.txt

# Page through large files
bat large_file.log               # Automatically uses pager
```

### Common File Types

```bash
# Programming languages
bat main.rs                      # Rust code
bat app.py                       # Python script
bat script.js                    # JavaScript
bat styles.css                   # CSS stylesheet
bat index.html                   # HTML file

# Configuration files
bat config.yaml
bat docker-compose.yml
bat Cargo.toml
bat package.json

# Documentation
bat README.md
bat CHANGELOG.md
bat docs.txt
```

## Advanced Usage

### Display Control

```bash
# Show specific line ranges
bat -r 1:10 file.txt             # Lines 1-10
bat -r 50:100 file.txt           # Lines 50-100
bat -r :50 file.txt              # First 50 lines
bat -r 50: file.txt              # From line 50 to end

# Control line numbers
bat -n file.txt                  # Show line numbers
bat --line-range=1:10 file.txt   # Range with line numbers

# Show all characters (including invisible)
bat -A file.txt                  # Show tabs, spaces, newlines

# Control paging
bat --paging=never file.txt      # No paging
bat --paging=always file.txt     # Always use pager
bat --paging=auto file.txt       # Auto-detect (default)
```

### Themes and Styling

```bash
# List available themes
bat --list-themes

# Use specific themes
bat --theme="GitHub" file.txt
bat --theme="Dracula" file.txt
bat --theme="Nord" file.txt
bat --theme="Solarized (dark)" file.txt

# Style options
bat --style="plain" file.txt                    # No decorations
bat --style="numbers" file.txt                  # Line numbers only
bat --style="changes" file.txt                  # Git changes only
bat --style="header" file.txt                   # Header only
bat --style="grid" file.txt                     # Grid lines
bat --style="numbers,changes" file.txt          # Combine styles
bat --style="full" file.txt                     # All decorations

# Color control
bat --color=always file.txt      # Force colors
bat --color=never file.txt       # No colors
bat --color=auto file.txt        # Auto-detect
```

### Language Detection and Forcing

```bash
# Force specific language syntax
bat -l python file_without_extension
bat -l rust main
bat -l json data
bat -l yaml config
bat -l dockerfile Dockerfile

# List supported languages
bat --list-languages

# Map file extensions
bat --map-syntax "*.conf:INI" config.conf
bat --map-syntax "*.log:Syslog" application.log
```

### Integration with Other Tools

```bash
# Use as pager
export PAGER="bat"
man git                          # Use bat for man pages
git log | bat -l gitlog

# Pipe content to bat
curl -s https://api.github.com/users/octocat | bat -l json
echo "SELECT * FROM users;" | bat -l sql
ps aux | bat -l ps

# With find and fd
find . -name "*.rs" -exec bat {} \;
fd -e rs -x bat {}

# With git
git show HEAD:file.rs | bat -l rust
git diff | bat -l diff

# With ripgrep
rg "pattern" --color=always | bat -l grep
```

### File Operations and Comparisons

```bash
# Compare files side by side (using diff)
diff -u file1.txt file2.txt | bat -l diff

# Show git differences
git diff | bat -l diff
git show | bat -l gitlog

# View archives
tar -tf archive.tar | bat -l text
unzip -l archive.zip | bat -l text

# Process substitution
bat <(echo "Some text")
bat <(ls -la)
bat <(ps aux)
```

### Advanced Configuration

```bash
# Custom tab width
bat --tabs=2 file.txt
bat --tabs=8 file.txt

# Wrap lines
bat --wrap=auto file.txt         # Auto wrap
bat --wrap=never file.txt        # No wrapping
bat --wrap=character file.txt    # Character wrap

# Control italic text
bat --italic-text=always file.txt
bat --italic-text=never file.txt

# Show file header
bat --decorations=always file.txt
bat --decorations=never file.txt
```

### Batch Processing

```bash
# Process multiple files with different languages
bat -l rust *.rs
bat -l python *.py
bat -l json *.json

# Combine multiple files
bat *.md > combined_docs.txt

# Process all files in directory
for file in *.txt; do
    echo "=== $file ===" >> combined.txt
    bat "$file" >> combined.txt
done

# Use with parallel
ls *.rs | parallel "bat {}"
```

### Environment Variables and Config

```bash
# Set default theme
export BAT_THEME="Dracula"

# Set default style
export BAT_STYLE="numbers,changes,header"

# Set default paging
export BAT_PAGING="auto"

# Disable config file
bat --no-config file.txt

# Use custom config
bat --config-file ~/.config/bat/custom_config file.txt
```

### Advanced Use Cases

```bash
# Debug configuration files
bat -l yaml docker-compose.yml
bat -l toml Cargo.toml
bat -l ini config.ini

# View logs with syntax highlighting
tail -f /var/log/nginx/access.log | bat -l log --paging=never
journalctl -f | bat -l syslog --paging=never

# Code review workflow
git diff HEAD~1 | bat -l diff
git show --name-only HEAD | xargs bat

# Documentation workflow
bat README.md CONTRIBUTING.md CHANGELOG.md

# Security analysis
bat /etc/passwd | grep -v "^#"
bat ~/.ssh/config

# System administration
bat /etc/nginx/nginx.conf
bat /etc/hosts
bat /var/log/auth.log

# Development debugging
bat error.log | grep -i error
bat package.json | jq .dependencies
```

### Performance Optimization

```bash
# Disable expensive features for large files
bat --style=plain --paging=never large_file.txt

# Use specific themes for performance
bat --theme="base16" file.txt     # Simpler theme

# Disable git integration for speed
bat --decorations=never file.txt

# Force no paging for scripts
BAT_PAGING=never bat file.txt
```

### Scripting and Automation

```bash
#!/bin/bash
# Script to view all project files
for ext in rs py js html css; do
    echo "=== $ext files ==="
    find . -name "*.$ext" | head -5 | while read file; do
        bat "$file"
        read -p "Press enter to continue..."
    done
done

# One-liner to view all config files
find /etc -name "*.conf" 2>/dev/null | head -10 | xargs bat

# View recent log entries
bat <(tail -50 /var/log/syslog)

# Quick project overview
bat README.md Cargo.toml src/main.rs
```

## Key Features

- Syntax highlighting for 200+ languages
- Git integration (shows changes)
- Line numbers
- Automatic paging
- File concatenation
- Themes support
- Plain text fallback

## Themes

Popular themes:
- `OneHalfDark` (default)
- `GitHub`
- `Monokai Extended`
- `Solarized (dark)`
- `Solarized (light)`
- `Nord`
- `Dracula`

```bash
# List available themes
bat --list-themes

# Test theme
bat --theme="GitHub" file.txt
```

## Style Options

Available styles:
- `auto` - Automatic based on terminal
- `full` - All decorations
- `plain` - No decorations
- `numbers` - Line numbers
- `changes` - Git changes
- `header` - File header
- `grid` - Grid lines
- `rule` - Horizontal rules
- `snip` - Snip marker

```bash
# Custom style combinations
bat --style="numbers,changes" file.txt
bat --style="header,grid" file.txt
bat --style="plain" file.txt
```

## Language Detection

```bash
# Force specific language
bat -l rust main.rs
bat -l json data.json
bat -l yaml config.yml

# List supported languages
bat --list-languages
```

## Git Integration

Bat shows Git changes in the margins:
- `+` - Added lines
- `-` - Removed lines
- `~` - Modified lines

## Configuration File

The config file at `~/.config/bat/config` supports:
- `--theme` - Default theme
- `--style` - Default style
- `--paging` - Paging behavior
- `--wrap` - Line wrapping
- `--tabs` - Tab width
- `--italic-text` - Italic text support

## Advanced Usage

### Custom Themes

```bash
# Create custom theme directory
mkdir -p ~/.config/bat/themes

# Add custom theme file (example.tmTheme)
# Then rebuild cache
bat cache --build
```

### Syntax Definitions

```bash
# Add custom syntax definitions
mkdir -p ~/.config/bat/syntaxes

# Add .sublime-syntax files
# Then rebuild cache
bat cache --build
```

### Environment Variables

- `BAT_THEME` - Default theme
- `BAT_STYLE` - Default style
- `BAT_PAGING` - Paging behavior
- `BAT_CONFIG_PATH` - Config file path

## Integration with Other Tools

### With Less
```bash
# Use bat as pager
export PAGER="bat"
```

### With Git
```bash
# Use bat for git diff
git config --global core.pager "bat"
```

### With Find
```bash
# Use with find
find . -name "*.rs" -exec bat {} \;
```

### With Grep
```bash
# Highlight search results
grep -n "pattern" file.txt | bat -l grep
```

## Performance Tips

- Use `--paging=never` for small files
- Use `--style=plain` for faster rendering
- Use `--color=never` for plain output
- Use `-p` for plain cat behavior

## Troubleshooting

- **Slow startup**: Check theme and style settings
- **No colors**: Check terminal color support
- **Wrong language**: Use `-l` to force language
- **Paging issues**: Adjust `--paging` setting

## Comparison with cat

Bat advantages:
- Syntax highlighting
- Git integration
- Line numbers
- Automatic paging
- Themes support

Traditional cat advantages:
- Faster for large files
- No dependencies
- Universal availability
- Simpler output

## Alternative Installation

```bash
# Via package manager
sudo apt install bat

# Via snap
sudo snap install bat

# Note: On Ubuntu, the command might be 'batcat'
# Add alias: alias bat='batcat'
```

## Plugins and Extensions

### Bat Extras
Additional utilities that work with bat:
- `batgrep` - Search with bat
- `batman` - Man pages with bat
- `batwatch` - Watch files with bat
- `batdiff` - Diff with bat

```bash
# Install bat extras
git clone https://github.com/eth-p/bat-extras.git
cd bat-extras
./build.sh --install
```
