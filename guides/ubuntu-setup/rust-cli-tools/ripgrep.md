# Ripgrep - Modern grep Alternative

Ripgrep is a line-oriented search tool that recursively searches directories for a regex pattern.

## Installation

```bash
cargo install ripgrep
```

## Basic Setup

### Shell Aliases

```bash
# Add alias for shorter command
echo 'alias rg="ripgrep"' >> ~/.bashrc
```

### Configuration

```bash
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

## Usage Examples

```bash
# Basic search
rg "pattern" .

# Case insensitive search
rg -i "pattern" .

# Search only Python files
rg -t py "pattern" .

# Search with line numbers
rg -n "pattern" .

# Search with context lines
rg -A 3 -B 3 "pattern" .

# Search for whole words only
rg -w "pattern" .

# Search and replace (preview)
rg "old_pattern" -r "new_pattern" --passthru

# Search with file types
rg -t rust "fn main"

# Search excluding certain directories
rg "pattern" --glob='!target/*'

# Search for multiple patterns
rg "pattern1|pattern2" .

# Search for exact string (not regex)
rg -F "exact string" .

# Search in specific files
rg "pattern" -g "*.rs"

# Search with statistics
rg "pattern" --stats
```

## Key Features

- Extremely fast search
- Respects .gitignore and .ignore files
- Supports many file types
- Regex and literal search
- Colored output
- Multi-line search
- Unicode support

## File Types

Common file types supported:
- `rust` - Rust files
- `py` - Python files
- `js` - JavaScript files
- `html` - HTML files
- `css` - CSS files
- `md` - Markdown files
- `json` - JSON files
- `xml` - XML files
- `yaml` - YAML files

## Advanced Usage

```bash
# Search with JSON output
rg "pattern" --json

# Search with replacement
rg "old" -r "new" --passthru file.txt

# Search with multiline patterns
rg -U "start.*end" .

# Search with custom type
rg --type-add 'mytype:*.{foo,bar}' -t mytype "pattern"

# Search with pre-processor
rg "pattern" --pre /path/to/preprocessor

# Search with path display
rg "pattern" --path-separator=/
```

## Configuration Options

Key options for ~/.ripgreprc:
- `--smart-case` - Case insensitive if all lowercase
- `--follow` - Follow symlinks
- `--max-depth=N` - Limit search depth
- `--max-count=N` - Stop after N matches
- `--colors` - Customize colors

## Troubleshooting

- **Slow performance**: Check if searching too many files
- **Not finding files**: Check .gitignore and .ignore files
- **Pattern not matching**: Verify regex syntax
- **Permission errors**: Run with appropriate permissions

## Alternative Installation

```bash
# Via package manager
sudo apt install ripgrep

# Via snap
sudo snap install ripgrep --classic
```