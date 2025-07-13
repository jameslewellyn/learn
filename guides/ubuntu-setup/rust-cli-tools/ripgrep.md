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

## Basic Usage

### Essential Commands

```bash
# Search for text in current directory
rg "search_term"

# Search with case insensitive
rg -i "search_term"

# Search in specific file types
rg -t py "search_term"           # Python files only
rg -t rust "search_term"         # Rust files only
rg -t js "search_term"           # JavaScript files only

# Search with line numbers
rg -n "search_term"

# Search for whole words only
rg -w "search_term"

# Search and show context (3 lines before/after)
rg -C 3 "search_term"
```

### Common Patterns

```bash
# Find function definitions
rg "fn \w+"                      # Rust functions
rg "def \w+"                     # Python functions
rg "function \w+"                # JavaScript functions

# Find imports/includes
rg "^import"                     # Python imports
rg "^use "                       # Rust use statements
rg "#include"                    # C/C++ includes

# Find TODO/FIXME comments
rg -i "todo|fixme"

# Search for email addresses
rg "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b"

# Search for IP addresses
rg "\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b"
```

## Advanced Usage

### Complex Search Patterns

```bash
# Multiline search
rg -U "start.*\n.*end"

# Search with regex
rg "fn\s+\w+\s*\([^)]*\)"       # Function signatures

# Search and replace (preview)
rg "old_pattern" -r "new_pattern" --passthru

# Search excluding patterns
rg "pattern" --glob='!target/*' --glob='!node_modules/*'

# Search with multiple file types
rg -t rust -t python "search_term"

# Search hidden files
rg -H "pattern"

# Search binary files
rg -a "pattern"

# Search with fixed strings (no regex)
rg -F "exact string with special chars []{}()"
```

### Advanced Context and Output

```bash
# Different context options
rg -A 5 "pattern"                # 5 lines after
rg -B 5 "pattern"                # 5 lines before
rg -C 5 "pattern"                # 5 lines before and after

# Only show filenames
rg -l "pattern"

# Count matches
rg -c "pattern"

# Show only matches (no line content)
rg -o "pattern"

# Invert match (show non-matching lines)
rg -v "pattern"

# Search with null byte separator (for piping)
rg -0 "pattern"
```

### File and Directory Control

```bash
# Search specific files
rg "pattern" -g "*.{rs,toml}"
rg "pattern" -g "Cargo.*"

# Search with depth limit
rg "pattern" --max-depth 3

# Follow symlinks
rg "pattern" -L

# Custom file types
rg --type-add 'mytype:*.{foo,bar}' -t mytype "pattern"

# Search compressed files
rg "pattern" -z

# Search with size limits
rg "pattern" --max-filesize 1M
```

### Output Formatting

```bash
# JSON output
rg "pattern" --json

# No heading (filename)
rg "pattern" --no-heading

# No line numbers
rg "pattern" --no-line-number

# Replace output format
rg "pattern" --replace "replacement"

# Color options
rg "pattern" --color=always
rg "pattern" --color=never
rg "pattern" --color=auto

# Custom colors
rg "pattern" --colors 'match:fg:red' --colors 'match:bg:yellow'
```

### Integration with Other Tools

```bash
# Pipe to other tools
rg "pattern" | sort
rg "pattern" | uniq -c
rg "pattern" -l | xargs wc -l

# Use with find
find . -name "*.rs" | xargs rg "pattern"

# Use with git
git ls-files | rg "pattern"

# Use with parallel processing
rg "pattern" --threads 8

# Search git history
git log -p | rg "pattern"

# Search in archives
unzip -p archive.zip | rg "pattern"
```

### Performance Optimization

```bash
# Memory map files (faster for large files)
rg "pattern" --mmap

# Use single thread for better memory usage
rg "pattern" --threads 1

# Disable all smart filtering
rg "pattern" -u

# Disable gitignore and hidden file filtering
rg "pattern" -uu

# Search specific file types only
rg "pattern" -t rust -t python

# Use pre-filter for better performance
rg "pattern" --pre /path/to/preprocessor

# Search with statistics
rg "pattern" --stats
```

### Complex Use Cases

```bash
# Search for security patterns
rg -i "password|secret|key|token" --type-add 'config:*.{json,yaml,yml,toml,ini}' -t config

# Find large functions (more than 50 lines)
rg -A 50 "^fn " | rg -B 50 "^}"

# Search for patterns across multiple repositories
find ~/projects -name ".git" -type d | sed 's/\/.git$//' | xargs -I {} rg "pattern" {}

# Find files with specific import patterns
rg "^use std::" -t rust -l | xargs -I {} rg "fn main" {}

# Search with conditional logic
rg "if.*{" -A 10 | rg "error|panic"

# Find configuration mismatches
rg "port.*=.*\d+" --type-add 'config:*.{conf,cfg,ini}' -t config
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