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

## Usage Examples

```bash
# Find by name
fd filename

# Find by extension
fd -e txt

# Find files only
fd -t f pattern

# Find directories only
fd -t d pattern

# Find with case insensitive
fd -i pattern

# Find in specific directory
fd pattern /path/to/search

# Find with maximum depth
fd -d 3 pattern

# Find hidden files
fd -H pattern

# Find and execute command
fd -t f -x grep "pattern" {}

# Find with full path
fd -p "full/path/pattern"

# Find by size
fd -S +1M

# Find by modification time
fd -t f --changed-within 1day

# Find excluding patterns
fd pattern --exclude "*.tmp"

# Find with regex
fd ".*\.rs$"
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