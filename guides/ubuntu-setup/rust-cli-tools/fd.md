# FD - Modern find Alternative

FD is a simple, fast, and user-friendly alternative to `find`.

## Installation

```bash
cargo install fd-find
```

## Basic Setup

### Shell Aliases

```bash
# Add aliases
echo 'alias find="fd"' >> ~/.bashrc
```

### Configuration

```bash
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

## Basic Usage

### Essential Commands

```bash
# Find files by name
fd filename

# Find files by extension
fd -e txt                        # All .txt files
fd -e py                         # All .py files
fd -e rs                         # All .rs files

# Case insensitive search
fd -i readme                     # Finds README, readme, Readme, etc.

# Find files vs directories
fd -t f pattern                  # Files only
fd -t d pattern                  # Directories only

# Limit search depth
fd -d 2 pattern                  # Search max 2 levels deep
```

### Common Patterns

```bash
# Find configuration files
fd config
fd -e conf
fd -e cfg

# Find specific file types
fd -e js -e ts                   # JavaScript/TypeScript files
fd -e jpg -e png -e gif          # Image files
fd -e md -e txt                  # Documentation files

# Find in current directory only
fd -d 1 pattern

# Find with wildcards
fd "test*"
fd "*config*"
```

## Advanced Usage

### Search Options

```bash
# Include hidden files
fd -H pattern

# Follow symlinks
fd -L pattern

# Search absolute paths
fd -a pattern

# Full path search
fd -p "path/to/file"

# Exclude patterns
fd pattern --exclude "*.tmp" --exclude "node_modules"

# Multiple extensions
fd -e rs -e toml -e md

# Regex patterns
fd "^test.*\.rs$"                # Files starting with "test" and ending with ".rs"
fd "\d{4}-\d{2}-\d{2}"          # Date patterns like 2023-12-01
```

### Size and Time Filters

```bash
# Size filters
fd -S +1M                        # Files larger than 1MB
fd -S -100k                      # Files smaller than 100KB
fd -S +1G                        # Files larger than 1GB

# Time filters
fd --changed-within 1day         # Modified in last day
fd --changed-within 1week        # Modified in last week
fd --changed-within 1month       # Modified in last month
fd --changed-before 2023-01-01   # Modified before specific date

# Combine filters
fd -t f -S +10M --changed-within 1week  # Large files modified recently
```

### Output Control

```bash
# Print absolute paths
fd -a pattern

# Print relative paths (default)
fd pattern

# Print null-separated (for xargs -0)
fd -0 pattern

# Print with details
fd -l pattern                    # Long format (like ls -l)

# No ignore (search everything)
fd -u pattern                    # Ignore .gitignore
fd -I pattern                    # Ignore .fdignore and .gitignore
```

### Execution and Processing

```bash
# Execute commands on found files
fd -t f -e txt -x cat {}         # Cat all .txt files
fd -t f -e rs -x wc -l {}        # Count lines in Rust files
fd -e jpg -x convert {} {.}.png  # Convert jpg to png

# Parallel execution
fd -t f -e txt -X grep "pattern" # Batch process files

# With xargs
fd -t f -e txt -0 | xargs -0 grep "pattern"

# Process with shell commands
fd -t f -e log -x sh -c 'echo "Processing: $1"; gzip "$1"' _
```

### Complex Search Patterns

```bash
# Combine multiple criteria
fd -t f -e rs -S +1k --changed-within 1week

# Search in specific directories
fd pattern src/ tests/ docs/

# Exclude multiple patterns
fd pattern --exclude "target" --exclude "node_modules" --exclude ".git"

# Custom ignore files
fd pattern --ignore-file .myignore

# Search with depth and type
fd -t d -d 3 src                 # Find directories named "src" up to 3 levels deep

# Find empty files/directories
fd -t f -S 0                     # Empty files
fd -t d --max-depth 1 | while read dir; do [ -z "$(ls -A "$dir")" ] && echo "$dir"; done
```

### Integration with Other Tools

```bash
# With ripgrep
fd -e rs -x rg "pattern" {}

# With bat
fd -e md -x bat {}

# With git
fd -e rs | xargs git add

# With parallel
fd -e txt | parallel "wc -l {}"

# With find and replace
fd -e rs -x sd "old_pattern" "new_pattern" {}

# Backup before modify
fd -e conf -x cp {} {}.backup \; -x sed -i 's/old/new/g' {}
```

### Performance Optimization

```bash
# Limit threads
fd -j 1 pattern                  # Single threaded

# Ignore VCS directories
fd --no-ignore-vcs pattern

# Skip gitignore
fd --no-ignore pattern

# Set custom ignore file
fd --ignore-file /path/to/ignore pattern

# Search specific file systems only
fd --one-file-system pattern
```

### Use Case Examples

```bash
# Clean up temporary files
fd -e tmp -e temp -X rm

# Find recently modified code files
fd -e rs -e py -e js --changed-within 1day

# Find large log files
fd -e log -S +100M

# Find configuration files in home directory
fd -t f -e conf -e cfg -e ini ~/.

# Find broken symlinks
fd -t l | while read link; do [ ! -e "$link" ] && echo "$link"; done

# Find duplicate filenames (different directories)
fd -t f | sort | uniq -d

# Find files with spaces in names
fd " "

# Find files without extensions
fd -t f "^[^.]*$"

# Find recently created Git repositories
fd -t d -d 2 ".git" --changed-within 1week
```

## Key Features

- Fast and intuitive
- Respects .gitignore by default
- Colored output
- Regular expressions
- Smart case sensitivity
- Parallel execution
- Cross-platform

## File Types

- `f` - Regular files
- `d` - Directories
- `l` - Symbolic links
- `x` - Executable files
- `e` - Empty files/directories
- `s` - Sockets
- `p` - Named pipes

## Advanced Usage

```bash
# Find with multiple extensions
fd -e rs -e toml

# Find with glob patterns
fd -g "*.{rs,toml}"

# Find with custom search path
fd pattern path1 path2

# Find with null separator (for xargs)
fd -0 pattern

# Find with absolute paths
fd -a pattern

# Find following symlinks
fd -L pattern

# Find with custom threads
fd -j 4 pattern

# Find with statistics
fd --stats pattern
```

## Ignore Files

FD respects several ignore files:
- `.gitignore`
- `.ignore`
- `.fdignore`
- Global ignore file

## Time Filters

```bash
# Files modified within last day
fd -t f --changed-within 1day

# Files modified before date
fd -t f --changed-before 2023-01-01

# Files newer than specific file
fd -t f --newer reference_file
```

## Size Filters

```bash
# Files larger than 1MB
fd -S +1M

# Files smaller than 1KB
fd -S -1k

# Files exactly 100 bytes
fd -S 100b
```

## Troubleshooting

- **Permission denied**: Use `-u` flag for unrestricted search
- **Files not found**: Check .gitignore and .ignore files
- **Slow performance**: Reduce search depth with `-d`
- **Pattern not matching**: Verify regex syntax

## Alternative Installation

```bash
# Via package manager
sudo apt install fd-find

# Via snap
sudo snap install fd
```