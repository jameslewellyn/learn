# Broot - Interactive Tree Navigation

Broot is a new way to navigate directory trees, providing a tree overview with fuzzy search.

## Installation

```bash
cargo install broot
```

## Basic Setup

### Initial Configuration

```bash
# Initialize broot (creates config and shell integration)
broot --install

# Add alias
echo 'alias tree="broot"' >> ~/.bashrc
echo 'alias br="broot"' >> ~/.bashrc

# Configuration is automatically created at ~/.config/broot/conf.hjson
# You can customize it after first run
```

## Usage Examples

```bash
# Launch broot
broot

# Launch with specific directory
broot /path/to/directory

# Launch with hidden files
broot -h

# Launch with sizes
broot -s

# Launch with permissions
broot -p

# Launch with dates
broot -d

# Launch with git status
broot -g

# Launch with specific pattern
broot pattern

# Launch with depth limit
broot --max-depth 3

# Launch with custom config
broot --conf ~/.config/broot/custom.hjson
```

## Key Features

- Interactive tree navigation
- Fuzzy search
- File operations
- Custom actions
- Git integration
- Configurable appearance
- Shell integration

## Navigation

### Basic Navigation
- `↑/↓` - Move up/down
- `Enter` - Open file/directory
- `Esc` - Close broot
- `?` - Show help
- `Tab` - Switch between panels

### Search
- Type to search (fuzzy matching)
- `Ctrl+F` - Focus search
- `Ctrl+G` - Clear search
- `/pattern` - Regex search
- `!pattern` - Inverse search

### File Operations
- `Space` - Toggle selection
- `Ctrl+A` - Select all
- `Ctrl+D` - Deselect all
- `Delete` - Delete selected
- `Ctrl+C` - Copy
- `Ctrl+V` - Paste
- `Ctrl+X` - Cut

## Configuration

The configuration file is located at `~/.config/broot/conf.hjson`:

### Basic Configuration
```hjson
{
    show_hidden: false
    show_sizes: true
    show_dates: true
    show_git: true
    max_depth: 10
    columns: [
        "mark"
        "name"
        "size"
        "date"
        "git"
        "perm"
    ]
}
```

### Color Customization
```hjson
{
    skin: {
        default: "gray(20) none"
        tree: "ansi(94) none"
        directory: "ansi(33) none bold"
        file: "gray(20) none"
        match: "ansi(34) none"
        selected_line: "none ansi(44)"
        permissions: "ansi(35) none"
        size: "ansi(36) none"
        date: "ansi(32) none"
        git_branch: "ansi(33) none"
        git_insertions: "ansi(32) none"
        git_deletions: "ansi(31) none"
    }
}
```

## Custom Actions

### Built-in Actions
- `:cd` - Change directory
- `:edit` - Edit file
- `:view` - View file
- `:open` - Open with default application
- `:parent` - Go to parent directory
- `:toggle_hidden` - Toggle hidden files
- `:toggle_sizes` - Toggle size display
- `:toggle_git` - Toggle git information

### Custom Actions
Add custom actions to the config:

```hjson
{
    verbs: [
        {
            key: "ctrl-e"
            execution: "$EDITOR {file}"
            description: "edit file"
        }
        {
            key: "ctrl-g"
            execution: "git status"
            description: "git status"
        }
        {
            key: "ctrl-t"
            execution: "bat {file}"
            description: "view with bat"
        }
    ]
}
```

## Search Patterns

### Basic Search
- `abc` - Files containing "abc"
- `*.rs` - Rust files
- `!test` - Files not containing "test"
- `/\.rs$/` - Files ending with .rs (regex)

### Advanced Search
- `size:>1M` - Files larger than 1MB
- `date:>2023-01-01` - Files modified after date
- `git:modified` - Modified files in git
- `perm:rwx` - Files with specific permissions

## File Operations

### Selection
- `Space` - Toggle file selection
- `Ctrl+A` - Select all visible files
- `Ctrl+I` - Invert selection
- `Ctrl+U` - Unselect all

### Operations on Selected Files
- `Delete` - Delete selected files
- `:rm` - Remove files
- `:cp` - Copy files
- `:mv` - Move files
- `:chmod` - Change permissions

## Git Integration

When in a git repository, broot shows:
- Git branch information
- File modification status
- Staged/unstaged changes
- Ignored files

Git status indicators:
- `M` - Modified
- `A` - Added
- `D` - Deleted
- `R` - Renamed
- `?` - Untracked
- `!` - Ignored

## Panel Management

### Multi-panel Mode
- `Ctrl+→` - Open right panel
- `Ctrl+←` - Open left panel
- `Tab` - Switch between panels
- `Ctrl+W` - Close current panel

### Panel Operations
- Drag and drop between panels
- Copy/move files between panels
- Compare directories
- Synchronize panels

## Keyboard Shortcuts

### Essential Shortcuts
- `?` - Help
- `Esc` - Quit/Cancel
- `Enter` - Open/Execute
- `Space` - Select/Deselect
- `Tab` - Switch panels
- `Ctrl+Q` - Quit broot

### Navigation
- `↑/↓` - Move cursor
- `PageUp/PageDown` - Page navigation
- `Home/End` - Go to start/end
- `g` - Go to top
- `G` - Go to bottom

## Performance Tips

- Use depth limits for large directories
- Filter files to reduce display
- Use specific search patterns
- Enable git integration only when needed

## Troubleshooting

- **Slow performance**: Reduce max depth or use filters
- **Config not loading**: Check config file syntax
- **Colors not working**: Verify terminal color support
- **Git integration issues**: Ensure git is installed and repo is valid

## Integration with Other Tools

### With Editors
```hjson
{
    verbs: [
        {
            key: "ctrl-e"
            execution: "$EDITOR {file}"
        }
        {
            key: "ctrl-v"
            execution: "vim {file}"
        }
    ]
}
```

### With File Managers
```hjson
{
    verbs: [
        {
            key: "ctrl-o"
            execution: "nautilus {directory}"
        }
    ]
}
```

### With Other Tools
```hjson
{
    verbs: [
        {
            key: "ctrl-b"
            execution: "bat {file}"
        }
        {
            key: "ctrl-r"
            execution: "rg {pattern} {directory}"
        }
    ]
}
```

## Use Cases

### Development
- Navigate project structures
- Search for specific files
- Git status overview
- Quick file editing

### System Administration
- Explore directory structures
- Find large files
- Check permissions
- File management

### File Organization
- Organize downloads
- Clean up directories
- Compare folder contents
- Bulk operations

## Alternative Installation

```bash
# Via package manager (if available)
sudo apt install broot

# Via GitHub releases
wget https://github.com/Canop/broot/releases/latest/download/broot-x86_64-unknown-linux-gnu.tar.gz
tar -xzf broot-*.tar.gz
sudo cp broot /usr/local/bin/
```

## Configuration Examples

### Minimal Setup
```hjson
{
    show_hidden: false
    show_sizes: true
    max_depth: 5
}
```

### Power User Setup
```hjson
{
    show_hidden: true
    show_sizes: true
    show_dates: true
    show_git: true
    max_depth: 15
    columns: ["mark", "name", "size", "date", "git", "perm"]
}
```