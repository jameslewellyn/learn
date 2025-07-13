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

## Basic Usage

### Essential Configuration

```toml
# Basic starship.toml setup
[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"

[directory]
truncation_length = 3
style = "bold cyan"

[git_branch]
style = "bold purple"

[cmd_duration]
min_time = 500
style = "yellow"
```

### Quick Start Examples

```bash
# Check current configuration
starship config

# Test prompt rendering
starship prompt

# Explain current configuration
starship explain

# Generate sample config
starship preset nerd-font-symbols > ~/.config/starship.toml
```

### Simple Format Customization

```toml
# Single line format
format = "$directory$git_branch$character"

# Two line format
format = """
$directory$git_branch
$character"""

# Minimal format
format = "$directory$character"
```

## Advanced Usage

### Complex Format Strings

```toml
# Comprehensive format
format = """
$username\
$hostname\
$localip\
$shlvl\
$singularity\
$kubernetes\
$directory\
$vcsh\
$git_branch\
$git_commit\
$git_state\
$git_metrics\
$git_status\
$hg_branch\
$docker_context\
$package\
$c\
$cmake\
$cobol\
$daml\
$dart\
$deno\
$dotnet\
$elixir\
$elm\
$erlang\
$golang\
$haskell\
$helm\
$java\
$julia\
$kotlin\
$lua\
$nim\
$nodejs\
$ocaml\
$perl\
$php\
$pulumi\
$purescript\
$python\
$raku\
$rlang\
$red\
$ruby\
$rust\
$scala\
$swift\
$terraform\
$vlang\
$vagrant\
$zig\
$buf\
$nix_shell\
$conda\
$memory_usage\
$aws\
$gcloud\
$openstack\
$azure\
$env_var\
$crystal\
$custom\
$sudo\
$cmd_duration\
$line_break\
$jobs\
$battery\
$time\
$status\
$container\
$shell\
$character"""
```

### Advanced Module Configuration

```toml
# Git integration
[git_branch]
format = "[$symbol$branch(:$remote_branch)]($style) "
symbol = "🌱 "
style = "bold purple"

[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'
style = "bold red"
conflicted = "🏳"
ahead = "🏎💨"
behind = "😰"
diverged = "😵"
up_to_date = "✓"
untracked = "🤷‍"
stashed = "📦"
modified = "📝"
staged = "[++\($count\)](green)"
renamed = "👅"
deleted = "🗑"

# Directory customization
[directory]
format = "[$path]($style)[$read_only]($read_only_style) "
style = "cyan bold"
read_only = "🔒"
truncation_length = 5
truncate_to_repo = true
home_symbol = "🏠"

# Language versions
[python]
format = '[${symbol}${pyenv_prefix}(${version} )(\($virtualenv\) )]($style)'
symbol = "🐍 "
style = "yellow bold"

[rust]
format = "[$symbol($version )]($style)"
symbol = "🦀 "
style = "red bold"

[nodejs]
format = "[$symbol($version )]($style)"
symbol = "⬢ "
style = "green bold"
```

### Conditional Display

```toml
# Show only when in specific contexts
[aws]
format = '[$symbol($profile )(\($region\) )(\[$duration\])]($style)'
symbol = "☁️  "
disabled = false

[docker_context]
format = "[$symbol$context]($style) "
symbol = "🐳 "
only_with_files = true

[kubernetes]
format = '[$symbol$context( \($namespace\))]($style) '
symbol = "☸ "
disabled = false

# Custom conditional modules
[custom.git_server]
command = "git config --get remote.origin.url | grep -oP '(?<=@)[^:]+'"
when = "git rev-parse --is-inside-work-tree"
format = "[$output]($style) "
style = "bold blue"

[custom.project_type]
command = """
if [ -f package.json ]; then echo "📦 Node"
elif [ -f Cargo.toml ]; then echo "🦀 Rust" 
elif [ -f requirements.txt ]; then echo "🐍 Python"
elif [ -f go.mod ]; then echo "🐹 Go"
else echo "📁"
fi
"""
when = "true"
format = "[$output]($style) "
style = "bold white"
```

### Performance Optimization

```toml
# Faster scanning
scan_timeout = 30

# Disable expensive modules
[package]
disabled = true

[gcloud]
disabled = true

[aws]
disabled = true

# Optimize git status
[git_status]
ahead = "⇡${count}"
diverged = "⇕⇡${ahead_count}⇣${behind_count}"
behind = "⇣${count}"
```

### Multi-line and Complex Layouts

```toml
# Multi-line with separators
format = """
$all\
$fill\
$cmd_duration $time\
$line_break\
$character"""

[fill]
symbol = "─"
style = "bold black"

# Right-aligned elements
right_format = """
$cmd_duration\
$time"""

# Complex character indicators
[character]
success_symbol = "[❯](bold green)"
error_symbol = "[❯](bold red)"
vicmd_symbol = "[❮](bold yellow)"
format = "$symbol [|](bold bright-black) "
```

### Theme Integration

```toml
# Dark theme configuration
[directory]
style = "bright-blue"

[git_branch]
style = "bright-purple"

[git_status]
style = "bright-red"

# Light theme configuration (palette)
palette = "catppuccin_mocha"

[palettes.catppuccin_mocha]
rosewater = "#f5e0dc"
flamingo = "#f2cdcd"
pink = "#f5c2e7"
mauve = "#cba6f7"
red = "#f38ba8"
maroon = "#eba0ac"
peach = "#fab387"
yellow = "#f9e2af"
green = "#a6e3a1"
teal = "#94e2d5"
sky = "#89dceb"
sapphire = "#74c7ec"
blue = "#89b4fa"
lavender = "#b4befe"
text = "#cdd6f4"
subtext1 = "#bac2de"
subtext0 = "#a6adc8"
overlay2 = "#9399b2"
overlay1 = "#7f849c"
overlay0 = "#6c7086"
surface2 = "#585b70"
surface1 = "#45475a"
surface0 = "#313244"
base = "#1e1e2e"
mantle = "#181825"
crust = "#11111b"
```

### Environment-Specific Configurations

```toml
# Work profile
[env_var.WORK_PROFILE]
format = "[$env_value]($style) "
style = "bright-yellow bold"

# Development vs Production
[custom.environment]
command = "echo $NODE_ENV"
when = '[ "$NODE_ENV" != "" ]'
format = "[$output]($style) "
style = "bold red"

# SSH indicator
[hostname]
ssh_only = true
format = "[$hostname]($style) "
style = "bold red"

# Container indicator
[container]
format = "[$symbol \\[$name\\]]($style) "
symbol = "🐳"
style = "bold blue dimmed"
```

### Integration with Development Tools

```toml
# Package version display
[package]
format = "[$symbol$version]($style) "
symbol = "📦 "
style = "bright-yellow bold"

# Virtual environment
[python]
format = '[${symbol}${pyenv_prefix}(${version} )(\($virtualenv\) )]($style)'
pyenv_version_name = true
pyenv_prefix = "pyenv "

# Docker context
[docker_context]
format = "[$symbol$context]($style) "
symbol = "🐳 "
style = "blue bold"

# Kubernetes context
[kubernetes]
format = '[$symbol$context( \($namespace\))]($style) '
symbol = "☸ "
style = "cyan bold"
disabled = false
```

### Custom Commands and Scripts

```toml
# Custom battery indicator
[custom.battery]
command = "cat /sys/class/power_supply/BAT0/capacity"
when = "test -f /sys/class/power_supply/BAT0/capacity"
format = "🔋 [$output%]($style) "
style = "bright-green"

# Custom weather (requires curl)
[custom.weather]
command = "curl -s 'wttr.in/?format=1' | head -1"
when = "ping -q -c1 wttr.in > /dev/null 2>&1"
format = "[$output]($style) "
style = "bright-blue"

# Git repository status
[custom.git_status]
command = "git status --porcelain | wc -l"
when = "git rev-parse --is-inside-work-tree"
format = "[$output files]($style) "
style = "bright-yellow"

# Custom directory size
[custom.dirsize]
command = "du -sh . | cut -f1"
when = "true"
format = "[$output]($style) "
style = "bright-cyan"
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