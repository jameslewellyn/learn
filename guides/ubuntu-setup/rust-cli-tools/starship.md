# Starship - Cross-shell Prompt

Starship is a minimal, fast, and customizable prompt for any shell.

## Installation

```bash
cargo install starship --locked
```

## Basic Setup

### Shell Integration

```bash
# Add to shell configuration
echo 'eval "$(starship init bash)"' >> ~/.bashrc

# For other shells:
# echo 'eval "$(starship init zsh)"' >> ~/.zshrc
# echo 'starship init fish | source' >> ~/.config/fish/config.fish
```

### Configuration

```bash
# Create configuration directory
mkdir -p ~/.config

# Create basic configuration
cat > ~/.config/starship.toml << 'EOF'
format = """
$username\
$hostname\
$directory\
$git_branch\
$git_state\
$git_status\
$cmd_duration\
$line_break\
$python\
$character"""

[directory]
style = "blue"
read_only = " "
truncation_length = 4
truncate_to_repo = true

[character]
success_symbol = "[❯](purple)"
error_symbol = "[❯](red)"
vicmd_symbol = "[❮](green)"

[git_branch]
format = "[$branch]($style)"
style = "bright-black"

[git_status]
format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)"
style = "cyan"
conflicted = "​"
untracked = "​"
modified = "​"
staged = "​"
renamed = "​"
deleted = "​"
stashed = "≡"

[git_state]
format = '\([$state( $progress_current/$progress_total)]($style)\) '
style = "bright-black"

[cmd_duration]
format = "[$duration]($style) "
style = "yellow"

[python]
format = "[$virtualenv]($style) "
style = "bright-black"
EOF
```

## Key Features

- Cross-shell compatibility
- Fast performance
- Highly customizable
- Context-aware modules
- Git integration
- Language detection
- Custom styling

## Supported Shells

- Bash
- Zsh
- Fish
- PowerShell
- Ion
- Elvish
- Tcsh
- Nushell

## Configuration Modules

### Essential Modules
- `character` - The prompt character
- `directory` - Current directory
- `git_branch` - Git branch info
- `git_status` - Git status info
- `cmd_duration` - Command execution time

### Language Modules
- `python` - Python version and virtualenv
- `rust` - Rust version
- `nodejs` - Node.js version
- `go` - Go version
- `java` - Java version
- `docker_context` - Docker context

### System Modules
- `hostname` - System hostname
- `username` - Current username
- `battery` - Battery level
- `time` - Current time
- `memory_usage` - Memory usage

## Common Configurations

### Minimal Setup
```toml
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"
```

### Developer Setup
```toml
format = """
$username\
$hostname\
$directory\
$git_branch\
$git_status\
$python\
$rust\
$nodejs\
$docker_context\
$cmd_duration\
$line_break\
$character"""
```

### Two-line Setup
```toml
format = """
$all\
$line_break\
$character"""
```

## Advanced Configuration

### Custom Colors
```toml
[directory]
style = "bold cyan"

[git_branch]
style = "bold purple"

[python]
style = "bold green"
```

### Conditional Display
```toml
[git_branch]
truncation_length = 4
truncation_symbol = ""

[git_status]
conflicted = "🏳"
ahead = "🏎💨"
behind = "😰"
diverged = "😵"
untracked = "🤷‍"
stashed = "📦"
modified = "📝"
staged = "➕"
renamed = "👅"
deleted = "🗑"
```

### Performance Optimization
```toml
[cmd_duration]
min_time = 500
show_milliseconds = false

[directory]
truncation_length = 3
truncate_to_repo = true
```

## Preset Configurations

Starship comes with several presets:

```bash
# List available presets
starship preset --list

# Apply a preset
starship preset nerd-font-symbols -o ~/.config/starship.toml

# Available presets:
# - nerd-font-symbols
# - bracketed-segments
# - plain-text-symbols
# - no-runtime-versions
# - pastel-powerline
# - tokyo-night
```

## Custom Modules

You can create custom modules:

```toml
[custom.git_server]
command = "echo git.example.com"
when = "git rev-parse --is-inside-work-tree"
style = "bold blue"
format = "[$output]($style) "
```

## Environment Variables

Configure via environment variables:
- `STARSHIP_CONFIG` - Custom config file path
- `STARSHIP_CACHE` - Cache directory
- `STARSHIP_LOG` - Log level

## Troubleshooting

- **Slow startup**: Disable heavy modules or use `scan_timeout`
- **Icons not showing**: Install a Nerd Font
- **Git info missing**: Ensure you're in a git repository
- **Colors not working**: Check terminal color support

## Performance Tips

```toml
# Reduce scan timeout
scan_timeout = 10

# Disable expensive modules
[aws]
disabled = true

[gcloud]
disabled = true

# Simplify git status
[git_status]
disabled = true
```

## Integration Examples

### With Git
```toml
[git_branch]
format = "[$branch]($style)"
style = "bright-black"

[git_status]
format = '([\[$all_status$ahead_behind\]]($style))'
style = "cyan"
```

### With Docker
```toml
[docker_context]
format = "[$symbol$context]($style)"
style = "blue bold"
symbol = "🐳 "
```

### With Python
```toml
[python]
format = '[${symbol}${pyenv_prefix}(${version} )(\($virtualenv\) )]($style)'
style = "yellow bold"
symbol = "🐍 "
```

## Alternative Installation

```bash
# Via package manager
sudo apt install starship

# Via snap
sudo snap install starship

# Via script
curl -sS https://starship.rs/install.sh | sh
```

## Configuration Testing

```bash
# Test configuration
starship config

# Explain configuration
starship explain

# Time startup
starship timings
```