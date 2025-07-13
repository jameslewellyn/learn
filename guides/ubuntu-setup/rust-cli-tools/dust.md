# Dust - Modern du Alternative

Dust is a more intuitive version of `du` written in Rust, showing disk usage in a tree format.

## Installation

```bash
cargo install du-dust
```

## Basic Setup

### Shell Aliases

```bash
# Add aliases
echo 'alias du="dust"' >> ~/.bashrc
echo 'alias dust="dust -r"' >> ~/.bashrc  # Reverse order by default
```

### Configuration

```bash
# Create configuration directory
mkdir -p ~/.config/dust

# Create configuration file
cat > ~/.config/dust/config.toml << 'EOF'
reverse = true
number_of_lines = 20
min_size = "1M"
EOF
```

## Usage Examples

```bash
# Show disk usage for current directory
dust

# Show disk usage in reverse order (largest first)
dust -r

# Limit output to specific number of entries
dust -n 10

# Show only directories above certain size
dust -m 1M

# Show disk usage for specific directory
dust /path/to/directory

# Show all files and directories
dust -a

# Show disk usage with specific depth
dust -d 2

# Show exact sizes (no human-readable format)
dust -b

# Show directories only
dust -D

# Show files only
dust -f

# Show hidden files
dust -H

# Ignore specific patterns
dust -i "*.log"

# Show output in tree format
dust -t

# Show with full paths
dust -p

# Show with percentage
dust -P

# Sort by name instead of size
dust -S name

# Show with inodes
dust -I
```

## Key Features

- Tree-like output format
- Colored output for easy reading
- Fast directory traversal
- Configurable size thresholds
- Multiple sorting options
- Human-readable sizes
- Cross-platform support

## Size Formats

Dust supports various size units:
- `B` - Bytes
- `K` - Kilobytes
- `M` - Megabytes
- `G` - Gigabytes
- `T` - Terabytes
- `P` - Petabytes

## Sorting Options

- `size` (default) - Sort by size
- `name` - Sort by name
- `count` - Sort by file count

## Output Modes

### Default Mode
Shows directories in a tree-like format with sizes and percentages.

### Bare Mode
```bash
dust -b
```
Shows exact byte counts instead of human-readable sizes.

### Apparent Size Mode
```bash
dust -s
```
Shows apparent size instead of disk usage.

## Filtering

### By Size
```bash
# Show only entries larger than 1MB
dust -m 1M

# Show only entries larger than 100KB
dust -m 100K
```

### By Pattern
```bash
# Ignore log files
dust -i "*.log"

# Ignore multiple patterns
dust -i "*.log" -i "*.tmp"
```

### By Depth
```bash
# Show only top 2 levels
dust -d 2

# Show only current directory
dust -d 1
```

## Performance Tips

- Use `-d` to limit depth for large directories
- Use `-n` to limit output lines
- Use `-m` to filter small files
- Use `-D` to show only directories

## Comparison with du

Dust advantages:
- More intuitive tree output
- Colored output
- Better performance
- Percentage display
- Easier filtering

Traditional du equivalents:
```bash
# du style
du -h --max-depth=1 | sort -hr

# Dust style
dust -d 1 -r
```

## Use Cases

### System Administration
- Find large directories consuming disk space
- Clean up disk space
- Monitor directory growth
- System maintenance

### Development
- Analyze project size
- Find large build artifacts
- Clean up development directories
- Monitor repository size

## Troubleshooting

- **Permission denied**: Some directories may be inaccessible
- **Slow performance**: Use depth limiting for large directories
- **Memory usage**: Limit output with `-n` flag
- **Symlinks**: Use `-L` to follow symlinks

## Alternative Installation

```bash
# Via package manager (if available)
sudo apt install dust
```

## Configuration File

The configuration file at `~/.config/dust/config.toml` supports:
- `reverse` - Sort in reverse order
- `number_of_lines` - Default number of lines to show
- `min_size` - Minimum size threshold
- `depth` - Maximum depth to show
- `apparent_size` - Show apparent size instead of disk usage