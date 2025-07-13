# Zoxide - Smart cd Alternative

Zoxide is a smarter cd command that learns your habits and takes you to the directories you visit most often.

## Installation

```bash
cargo install zoxide
```

## Basic Setup

### Shell Integration

```bash
# Add to shell configuration
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc

# Add aliases
echo 'alias cd="z"' >> ~/.bashrc
echo 'alias cdi="zi"' >> ~/.bashrc  # Interactive mode

# Create configuration directory
mkdir -p ~/.config/zoxide

# Note: zoxide learns from your usage patterns automatically
```

### Other Shell Support

```bash
# For zsh
echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc

# For fish
echo 'zoxide init fish | source' >> ~/.config/fish/config.fish

# For PowerShell
echo 'Invoke-Expression (& { (zoxide init powershell | Out-String) })' >> $PROFILE
```

## Usage Examples

```bash
# Navigate to frequently visited directories
z documents
z proj
z dev

# Interactive directory selection
zi

# Jump to previous directory
z -

# Add directory to zoxide database
z /path/to/directory

# Remove directory from database
zoxide remove /path/to/directory

# Query database
zoxide query documents
zoxide query --list
zoxide query --score

# Import from other tools
zoxide import --from autojump ~/.local/share/autojump/autojump.txt
zoxide import --from z ~/.z
```

## Key Features

- Learns from your usage patterns
- Fuzzy matching
- Interactive selection
- Cross-platform support
- Fast directory jumping
- Import from other tools
- Customizable scoring

## Commands

### Basic Commands
- `z <pattern>` - Jump to directory matching pattern
- `zi` - Interactive directory selection
- `z -` - Jump to previous directory
- `z ..` - Go up one directory

### Advanced Commands
- `zoxide add <path>` - Add directory to database
- `zoxide remove <path>` - Remove directory from database
- `zoxide query <pattern>` - Query database
- `zoxide import` - Import from other tools

## Configuration

### Environment Variables
- `_ZO_DATA_DIR` - Data directory location
- `_ZO_ECHO` - Echo jumped directory
- `_ZO_EXCLUDE_DIRS` - Directories to exclude
- `_ZO_FZF_OPTS` - Options for fzf integration
- `_ZO_MAXAGE` - Maximum age for entries
- `_ZO_RESOLVE_SYMLINKS` - Resolve symlinks

### Custom Configuration
```bash
# Set custom data directory
export _ZO_DATA_DIR="$HOME/.local/share/zoxide"

# Echo directory when jumping
export _ZO_ECHO=1

# Exclude certain directories
export _ZO_EXCLUDE_DIRS="$HOME/.git/*:$HOME/.cache/*"

# Set maximum age for entries
export _ZO_MAXAGE=10000
```

## Fuzzy Matching

Zoxide uses fuzzy matching to find directories:
- `z doc` matches `Documents`
- `z dw` matches `Downloads`
- `z dev/rust` matches `Development/rust-projects`

## Interactive Mode

```bash
# Launch interactive mode
zi

# Navigation keys:
# - Up/Down arrows: Navigate
# - Enter: Select directory
# - Ctrl+C: Cancel
# - Tab: Complete selection
```

## Integration with Other Tools

### With FZF
```bash
# Enhanced interactive mode with fzf
export _ZO_FZF_OPTS="--height 40% --layout=reverse --border"
```

### With Autojump
```bash
# Import autojump database
zoxide import --from autojump ~/.local/share/autojump/autojump.txt
```

### With Z
```bash
# Import z database
zoxide import --from z ~/.z
```

## Database Management

```bash
# View database location
zoxide query --list

# Edit database manually
zoxide edit

# Clean up old entries
zoxide clean

# Show database statistics
zoxide query --stats
```

## Advanced Usage

### Custom Scoring
Zoxide uses a sophisticated scoring algorithm:
- Frequency of visits
- Recency of visits
- Path length
- Exact vs. fuzzy matches

### Batch Operations
```bash
# Add multiple directories
for dir in ~/Projects/*/; do
    zoxide add "$dir"
done

# Query multiple patterns
zoxide query --list | grep -E "(project|dev)"
```

## Shell Functions

Add these to your shell config:

```bash
# Quick project navigation
function project() {
    z ~/Projects/"$1"
}

# Navigate to git repositories
function repo() {
    z ~/git/"$1"
}

# Navigate and list contents
function zl() {
    z "$1" && ls -la
}

# Navigate and show git status
function zg() {
    z "$1" && git status
}
```

## Performance Tips

- Zoxide is very fast by design
- Database is automatically cleaned
- Use short, memorable patterns
- Take advantage of fuzzy matching

## Troubleshooting

- **Not finding directories**: Ensure you've visited them recently
- **Slow performance**: Clean database with `zoxide clean`
- **Wrong directory**: Use more specific patterns
- **Database corruption**: Reimport from backup

## Comparison with cd

Zoxide advantages:
- Learns your habits
- Fuzzy matching
- Fast directory jumping
- Cross-platform
- No need to remember full paths

Traditional cd advantages:
- Direct path navigation
- No learning curve
- Universal availability
- Simple behavior

## Migration

### From Autojump
```bash
# Export autojump database
autojump --stat > autojump_backup.txt

# Import to zoxide
zoxide import --from autojump ~/.local/share/autojump/autojump.txt
```

### From Z
```bash
# Import z database
zoxide import --from z ~/.z
```

## Use Cases

### Development
```bash
# Navigate to project directories
z myproject
z frontend
z backend

# Quick navigation patterns
z mp    # matches myproject
z fe    # matches frontend
z be    # matches backend
```

### System Administration
```bash
# Navigate to system directories
z /var/log
z /etc/nginx
z /home/user

# Common patterns
z log   # matches /var/log
z conf  # matches /etc/nginx
z home  # matches /home/user
```

## Alternative Installation

```bash
# Via package manager
sudo apt install zoxide

# Via script
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
```

## Configuration Examples

### Minimal Setup
```bash
eval "$(zoxide init bash)"
alias cd="z"
```

### Power User Setup
```bash
eval "$(zoxide init bash)"
alias cd="z"
alias cdi="zi"
export _ZO_ECHO=1
export _ZO_FZF_OPTS="--height 40% --layout=reverse --border"
```