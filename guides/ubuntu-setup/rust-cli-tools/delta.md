# Delta - Git Diff Viewer

Delta is a syntax-highlighting pager for git, diff, and grep output.

## Installation

```bash
cargo install git-delta
```

## Basic Setup

### Git Configuration

```bash
# Configure git to use delta
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global delta.light false
git config --global delta.side-by-side true
git config --global merge.conflictstyle diff3
git config --global diff.colorMoved default

# Create delta configuration
cat >> ~/.gitconfig << 'EOF'
[delta]
    features = decorations
    whitespace-error-style = 22 reverse
    
[delta "decorations"]
    commit-decoration-style = bold yellow box ul
    file-style = bold yellow ul
    file-decoration-style = none
    hunk-header-decoration-style = yellow box
EOF
```

## Usage Examples

```bash
# Git commands automatically use delta
git diff
git show
git log -p
git blame

# Use delta directly
delta file1.txt file2.txt

# Use with other diff tools
diff -u file1.txt file2.txt | delta

# Use with specific options
git diff | delta --side-by-side
git diff | delta --line-numbers
git diff | delta --dark
git diff | delta --light
```

## Key Features

- Syntax highlighting for diffs
- Side-by-side view
- Line numbers
- Git integration
- Multiple themes
- Navigate mode
- Hyperlinks support
- Word-level highlighting

## Configuration Options

### Basic Configuration
```toml
[delta]
    syntax-theme = "Nord"
    line-numbers = true
    navigate = true
    side-by-side = true
```

### Advanced Configuration
```toml
[delta]
    features = "side-by-side line-numbers decorations"
    syntax-theme = "Dracula"
    plus-style = "syntax #012800"
    minus-style = "syntax #340001"
    line-numbers-minus-style = "#444444"
    line-numbers-plus-style = "#444444"
    line-numbers-left-format = "{nm:>4}┊"
    line-numbers-right-format = "{np:>4}│"
    line-numbers-left-style = "blue"
    line-numbers-right-style = "blue"
```

## Themes

Popular syntax themes:
- `Nord`
- `Dracula`
- `GitHub`
- `Monokai Extended`
- `Solarized (dark)`
- `Solarized (light)`
- `base16`

```bash
# List available themes
delta --list-syntax-themes

# Test theme
git diff | delta --syntax-theme="GitHub"
```

## Navigation

When `navigate = true`:
- `n` - Next file
- `N` - Previous file
- `g` - Go to top
- `G` - Go to bottom
- `/` - Search
- `q` - Quit

## Features

### Side-by-side View
```bash
# Enable side-by-side
git config --global delta.side-by-side true

# Disable side-by-side
git config --global delta.side-by-side false
```

### Line Numbers
```bash
# Enable line numbers
git config --global delta.line-numbers true

# Custom line number style
git config --global delta.line-numbers-left-style "blue"
git config --global delta.line-numbers-right-style "blue"
```

### Hyperlinks
```bash
# Enable hyperlinks (supported terminals)
git config --global delta.hyperlinks true
```

## File Types

Delta supports syntax highlighting for:
- Source code (200+ languages)
- Configuration files
- Markup languages
- Data formats (JSON, YAML, XML)
- Shell scripts
- Documentation files

## Word-level Highlighting

```bash
# Enable word-level highlighting
git config --global delta.word-diff-regex "[^[:space:]]+"
```

## Integration with Other Tools

### With Grep
```bash
# Use delta with grep
grep -n "pattern" file.txt | delta
```

### With Different Tools
```bash
# Use delta with diff
diff -u file1.txt file2.txt | delta

# Use delta with git tools
git log --oneline | delta
git stash show -p | delta
```

## Custom Styles

### Color Customization
```bash
# Customize added/removed line colors
git config --global delta.plus-style "syntax #003800"
git config --global delta.minus-style "syntax #3f0001"

# Customize line number colors
git config --global delta.line-numbers-minus-style "#444444"
git config --global delta.line-numbers-plus-style "#444444"
```

### File Header Styling
```bash
# Customize file headers
git config --global delta.file-style "bold yellow ul"
git config --global delta.file-decoration-style "none"
```

## Performance Options

```bash
# Disable expensive features for large diffs
git config --global delta.max-line-length 512
git config --global delta.max-line-distance 0.6
```

## Environment Variables

- `DELTA_FEATURES` - Default features
- `DELTA_PAGER` - Pager to use
- `BAT_THEME` - Syntax theme (if bat is installed)

## Troubleshooting

- **No colors**: Check terminal color support
- **Slow performance**: Disable side-by-side for large diffs
- **Wrong theme**: Verify theme name with `--list-syntax-themes`
- **Navigation not working**: Check terminal pager support

## Advanced Features

### Custom Features
```bash
# Create custom feature in .gitconfig
[delta "custom"]
    syntax-theme = "GitHub"
    line-numbers = true
    side-by-side = true
    navigate = true
    
# Use custom feature
git config --global delta.features "custom"
```

### File-specific Configuration
```bash
# Different config for different file types
[delta "json"]
    syntax-theme = "Monokai Extended"
    
[delta "python"]
    syntax-theme = "Nord"
```

## Comparison with git diff

Delta advantages:
- Syntax highlighting
- Better visualization
- Side-by-side view
- Navigation support
- Theme support

Traditional git diff advantages:
- Faster for large diffs
- No dependencies
- Universal availability
- Simpler output

## Alternative Installation

```bash
# Via package manager
sudo apt install git-delta

# Via GitHub releases
wget https://github.com/dandavison/delta/releases/latest/download/delta-*-x86_64-unknown-linux-gnu.tar.gz
tar -xzf delta-*.tar.gz
sudo cp delta-*/delta /usr/local/bin/
```

## Integration Examples

### With Git Aliases
```bash
# Add git aliases
git config --global alias.d 'diff --color-moved'
git config --global alias.ds 'diff --color-moved --staged'
git config --global alias.dc 'diff --color-moved --cached'
```

### With Shell Functions
```bash
# Add to ~/.bashrc
function gdiff() {
    git diff --color-moved "$@" | delta
}

function gshow() {
    git show --color-moved "$@" | delta
}
```