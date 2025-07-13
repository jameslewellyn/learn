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

## Usage Examples

```bash
# Basic file viewing
bat file.txt

# View with line numbers
bat -n file.txt

# View specific line range
bat -r 1:10 file.txt

# View multiple files
bat file1.txt file2.txt

# View with specific language
bat -l python script.py

# View with plain style (no decorations)
bat -p file.txt

# View with all characters visible
bat -A file.txt

# View with specific theme
bat --theme="GitHub" file.txt

# View with paging disabled
bat --paging=never file.txt

# View with custom style
bat --style="plain" file.txt

# View with highlighting disabled
bat --color=never file.txt
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
