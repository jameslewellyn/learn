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

## Basic Usage

### Essential Navigation

```bash
# Jump to a directory (fuzzy matching)
z documents                      # Jump to any directory containing "documents"
z proj                          # Jump to project directory
z down                          # Jump to Downloads directory

# Interactive directory picker
zi                              # Shows list of directories to choose from

# Jump to previous directory
z -                             # Like cd -

# Jump with partial matches
z doc                           # Matches Documents, docs, documentation, etc.
z dev                           # Matches Development, dev-tools, etc.
```

### Common Patterns

```bash
# Jump to nested directories
z rust proj                     # Matches rust-projects, my-rust-project, etc.
z config nvim                   # Matches .config/nvim

# Jump by directory type
z home                          # Jump to home directory variations
z tmp                           # Jump to temporary directories
z log                           # Jump to log directories

# Quick shortcuts
z ..                            # Go up one level (if configured)
z ~                             # Go to home directory
```

## Advanced Usage

### Database Management

```bash
# View all tracked directories
zoxide query --list

# View directories with scores
zoxide query --score

# Query specific pattern
zoxide query documents
zoxide query --all documents    # Show all matches

# Remove directory from database
zoxide remove /path/to/directory

# Add directory manually
zoxide add /path/to/directory

# Import from other tools
zoxide import --from autojump ~/.local/share/autojump/autojump.txt
zoxide import --from z ~/.z
zoxide import --from autojump --merge  # Merge with existing data
```

### Advanced Navigation

```bash
# Navigate with specific ranking
z documents 2                   # Go to 2nd ranked "documents" directory

# Use with subdirectories
z proj/rust                     # Navigate to rust subdirectory in project dir

# Case sensitive matching
z Documents                     # Exact case matching when mixed case

# Navigate to parent directories
z proj && cd ..                 # Navigate then go up

# Chain navigation
z proj && cd src && ls          # Navigate and execute commands
```

### Interactive Mode Features

```bash
# Launch interactive mode with initial query
zi rust                         # Start interactive mode filtered by "rust"

# Interactive mode keyboard shortcuts:
# - Up/Down: Navigate list
# - Enter: Select directory
# - Ctrl+C: Cancel
# - Tab: Complete current selection
# - /: Filter current list
# - Escape: Clear filter
```

### Configuration and Customization

```bash
# Set custom data directory
export _ZO_DATA_DIR="$HOME/.local/share/zoxide"

# Echo directory when jumping
export _ZO_ECHO=1

# Exclude directories from tracking
export _ZO_EXCLUDE_DIRS="$HOME/.git/*:$HOME/.cache/*:$HOME/tmp/*"

# Maximum age for entries (in seconds)
export _ZO_MAXAGE=10000

# Resolve symlinks before adding to database
export _ZO_RESOLVE_SYMLINKS=1

# Custom FZF options for interactive mode
export _ZO_FZF_OPTS="--height=40% --layout=reverse --border --preview='ls -la {}'"
```

### Integration with Shell Features

```bash
# Shell functions for enhanced usage
function zl() {
    z "$1" && ls -la
}

function zg() {
    z "$1" && git status
}

function zf() {
    z "$1" && fd . | head -20
}

function zr() {
    z "$1" && rg --files | head -20
}

# Project-specific navigation
function project() {
    z ~/Projects/"$1"
}

function repo() {
    z ~/git/"$1"
}

# Work-specific shortcuts
function work() {
    z ~/Work/"$1"
}

function docs() {
    z ~/Documents/"$1"
}
```

### Advanced Querying

```bash
# List directories by frequency
zoxide query --list | sort -n

# Find directories containing specific terms
zoxide query --list | grep -i rust
zoxide query --list | grep -E "(project|dev)"

# Show statistics
zoxide query --stats

# Export database
zoxide query --list > zoxide_backup.txt

# Clean up old entries
zoxide remove --age 30d          # Remove entries older than 30 days
```

### Batch Operations

```bash
# Add multiple directories
for dir in ~/Projects/*/; do
    zoxide add "$dir"
done

# Remove multiple directories
zoxide query --list | grep tmp | while read dir; do
    zoxide remove "$dir"
done

# Backup and restore
zoxide query --list > ~/.zoxide_backup
# Restore: while read dir; do zoxide add "$dir"; done < ~/.zoxide_backup
```

### Integration with Other Tools

```bash
# Use with find
find ~/Projects -maxdepth 2 -type d | while read dir; do zoxide add "$dir"; done

# Use with fd
fd -t d . ~/Projects | head -20 | while read dir; do zoxide add "$dir"; done

# Use with git
git clone https://github.com/user/repo.git && z repo

# Use with tmux
alias t='tmux new-session -c "$(zoxide query --list | fzf)"'

# Use with code editors
alias c='code "$(zoxide query --list | fzf)"'
alias v='vim "$(zoxide query --list | fzf)"'
```

### Performance Optimization

```bash
# Limit database size
export _ZO_MAXAGE=5000           # Keep only recent entries

# Faster interactive mode
export _ZO_FZF_OPTS="--no-preview"  # Disable preview for speed

# Exclude heavy directories
export _ZO_EXCLUDE_DIRS="$HOME/node_modules/*:$HOME/.cargo/*"
```

### Troubleshooting and Maintenance

```bash
# Debug mode
zoxide query --list              # Check what's in database
zoxide query documents           # Test specific queries

# Reset database
rm ~/.local/share/zoxide/db.zo   # Remove database file

# Verify configuration
echo $_ZO_DATA_DIR
echo $_ZO_ECHO
echo $_ZO_EXCLUDE_DIRS

# Check shell integration
type z                           # Should show function definition
type zi                          # Should show function definition
```

### Use Case Examples

```bash
# Development workflow
z frontend && npm start          # Navigate to frontend and start dev server
z backend && cargo run           # Navigate to backend and run Rust server
z docs && mdbook serve           # Navigate to docs and serve

# Daily tasks
z down                          # Go to Downloads
z desk                          # Go to Desktop  
z conf                          # Go to config directory

# Project management
z proj/website                  # Navigate to website project
z proj/api                      # Navigate to API project
z proj/mobile                   # Navigate to mobile project
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