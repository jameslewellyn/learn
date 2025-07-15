# Zellij - Terminal Workspace and Multiplexer Installation and Setup Guide

## Overview

**Zellij** is a terminal workspace and multiplexer designed to make working with multiple terminal sessions more intuitive and efficient. It provides a modern approach to terminal multiplexing with features like layout management, session persistence, and collaborative workspaces.

### Key Features
- **Intuitive layout system**: Visual panes and tabs with easy navigation
- **Session persistence**: Resume sessions after disconnection
- **Plugin system**: Extensible with WebAssembly plugins
- **Collaborative workspaces**: Share sessions with other users
- **Built-in themes**: Customizable appearance and color schemes
- **Modern UI**: Context-aware status bars and visual indicators

### Why Use Zellij?
- More user-friendly than tmux for beginners
- Better visual feedback and modern interface
- Strong plugin ecosystem and extensibility
- Excellent for remote development workflows
- Great for organizing complex development environments
- Built-in collaboration features

## Installation

### Prerequisites
- Terminal with true color support
- Modern shell (bash, zsh, fish)

### Via Mise (Recommended)
```bash
# Install zellij via mise
mise use -g zellij

# Verify installation
zellij --version
```

### Manual Installation
```bash
# Install via cargo
cargo install zellij

# Or download binary release
curl -L https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar xz
sudo mv zellij /usr/local/bin/

# Or via package manager (if available)
# sudo apt install zellij  # On newer Ubuntu versions
```

### Verify Installation
```bash
# Test basic functionality
zellij --help

# Check version
zellij --version

# List available layouts
zellij list-sessions
```

## Configuration

### Initial Setup
```bash
# Generate default configuration
zellij setup --generate-config

# Create config directory manually
mkdir -p ~/.config/zellij

# Generate shell completion
zellij setup --generate-completion bash > ~/.local/share/bash-completion/completions/zellij
```

### Configuration File
```bash
# Create main configuration file
cat > ~/.config/zellij/config.kdl << 'EOF'
// Zellij configuration file
keybinds clear-defaults=true {
    normal {
        // Session management
        bind "Ctrl p" { SwitchToMode "Pane"; }
        bind "Ctrl t" { SwitchToMode "Tab"; }
        bind "Ctrl s" { SwitchToMode "Scroll"; }
        bind "Ctrl o" { SwitchToMode "Session"; }
        bind "Ctrl h" { SwitchToMode "Move"; }
        bind "Ctrl n" { SwitchToMode "Resize"; }
        
        // Quick actions
        bind "Alt n" { NewPane; }
        bind "Alt t" { NewTab; }
        bind "Alt h" "Alt Left" { MoveFocusOrTab "Left"; }
        bind "Alt l" "Alt Right" { MoveFocusOrTab "Right"; }
        bind "Alt j" "Alt Down" { MoveFocus "Down"; }
        bind "Alt k" "Alt Up" { MoveFocus "Up"; }
        bind "Alt =" "Alt +" { Resize "Increase"; }
        bind "Alt -" { Resize "Decrease"; }
        bind "Alt f" { ToggleFocusFullscreen; }
        bind "Alt d" { Detach; }
        bind "Alt q" { Quit; }
    }
    
    pane {
        bind "Ctrl p" "Enter" "Esc" { SwitchToMode "Normal"; }
        bind "h" "Left" { MoveFocus "Left"; }
        bind "l" "Right" { MoveFocus "Right"; }
        bind "j" "Down" { MoveFocus "Down"; }
        bind "k" "Up" { MoveFocus "Up"; }
        bind "p" { SwitchFocus; }
        bind "n" { NewPane; SwitchToMode "Normal"; }
        bind "d" { NewPane "Down"; SwitchToMode "Normal"; }
        bind "r" { NewPane "Right"; SwitchToMode "Normal"; }
        bind "x" { CloseFocus; SwitchToMode "Normal"; }
        bind "f" { ToggleFocusFullscreen; SwitchToMode "Normal"; }
        bind "z" { TogglePaneFrames; SwitchToMode "Normal"; }
        bind "w" { ToggleFloatingPanes; SwitchToMode "Normal"; }
        bind "e" { TogglePaneEmbedOrFloating; SwitchToMode "Normal"; }
        bind "c" { SwitchToMode "RenamePane"; PaneNameInput 0;}
    }
    
    tab {
        bind "Ctrl t" "Enter" "Esc" { SwitchToMode "Normal"; }
        bind "r" { SwitchToMode "RenameTab"; TabNameInput 0; }
        bind "h" "Left" "Up" "k" { GoToPreviousTab; }
        bind "l" "Right" "Down" "j" { GoToNextTab; }
        bind "n" { NewTab; SwitchToMode "Normal"; }
        bind "x" { CloseTab; SwitchToMode "Normal"; }
        bind "s" { ToggleActiveSyncTab; SwitchToMode "Normal"; }
        bind "b" { BreakPane; SwitchToMode "Normal"; }
        bind "]" { BreakPaneRight; SwitchToMode "Normal"; }
        bind "[" { BreakPaneLeft; SwitchToMode "Normal"; }
        bind "1" { GoToTab 1; SwitchToMode "Normal"; }
        bind "2" { GoToTab 2; SwitchToMode "Normal"; }
        bind "3" { GoToTab 3; SwitchToMode "Normal"; }
        bind "4" { GoToTab 4; SwitchToMode "Normal"; }
        bind "5" { GoToTab 5; SwitchToMode "Normal"; }
        bind "6" { GoToTab 6; SwitchToMode "Normal"; }
        bind "7" { GoToTab 7; SwitchToMode "Normal"; }
        bind "8" { GoToTab 8; SwitchToMode "Normal"; }
        bind "9" { GoToTab 9; SwitchToMode "Normal"; }
        bind "Tab" { ToggleTab; }
    }
}

// Theme configuration
theme "catppuccin-mocha"

// Plugin configuration
plugins {
    tab-bar { path "tab-bar"; }
    status-bar { path "status-bar"; }
    strider { path "strider"; }
    compact-bar { path "compact-bar"; }
}

// UI configuration
ui {
    pane_frames {
        rounded_corners true
        hide_session_name false
    }
}

// Copy configuration
copy_command "xclip -selection clipboard"
copy_clipboard "system"
copy_on_select false

// Scrollback configuration
scrollback_editor "nvim"
scroll_buffer_size 10000

// Mouse support
mouse_mode true
EOF
```

### Shell Integration
```bash
# Add to ~/.bashrc or ~/.zshrc
alias zj='zellij'
alias za='zellij attach'
alias zl='zellij list-sessions'
alias zk='zellij kill-session'

# Function to create named sessions
zs() {
    local session_name="${1:-main}"
    zellij attach "$session_name" || zellij new-session --name "$session_name"
}

# Function to kill all sessions
zkill() {
    zellij kill-all-sessions
}

# Auto-start zellij for SSH sessions
if [[ -n "$SSH_CONNECTION" ]] && [[ -z "$ZELLIJ" ]]; then
    zellij attach default || zellij new-session --name default
fi
```

## Basic Usage

### Starting Zellij
```bash
# Start new session
zellij

# Start with specific session name
zellij new-session --name "development"

# Attach to existing session
zellij attach "development"

# List all sessions
zellij list-sessions

# Kill specific session
zellij kill-session "development"
```

### Basic Navigation
```bash
# Default key bindings:
# Ctrl+p : Pane mode
# Ctrl+t : Tab mode
# Ctrl+s : Scroll mode
# Ctrl+o : Session mode
# Ctrl+h : Move mode
# Ctrl+n : Resize mode

# Quick actions:
# Alt+n : New pane
# Alt+t : New tab
# Alt+h/j/k/l : Navigate panes
# Alt+f : Toggle fullscreen
# Alt+d : Detach session
# Alt+q : Quit
```

### Pane Management
```bash
# In pane mode (Ctrl+p):
# n : New pane
# d : New pane down
# r : New pane right
# x : Close pane
# f : Toggle fullscreen
# z : Toggle pane frames
# w : Toggle floating panes
# Arrow keys : Navigate panes
```

### Tab Management
```bash
# In tab mode (Ctrl+t):
# n : New tab
# x : Close tab
# r : Rename tab
# h/l : Navigate tabs
# 1-9 : Go to specific tab
# s : Toggle sync mode
# b : Break pane to new tab
```

## Advanced Usage

### Layouts
```bash
# Create custom layout directory
mkdir -p ~/.config/zellij/layouts

# Create development layout
cat > ~/.config/zellij/layouts/development.kdl << 'EOF'
layout {
    default_tab_template {
        pane size=1 borderless=true {
            plugin location="zellij:tab-bar"
        }
        children
        pane size=2 borderless=true {
            plugin location="zellij:status-bar"
        }
    }
    
    tab name="Code" focus=true {
        pane split_direction="vertical" {
            pane split_direction="horizontal" {
                pane command="nvim" {
                    args "."
                }
                pane command="git" {
                    args "status"
                }
            }
            pane split_direction="horizontal" {
                pane command="npm" {
                    args "run" "dev"
                }
                pane
            }
        }
    }
    
    tab name="Server" {
        pane split_direction="vertical" {
            pane command="docker-compose" {
                args "logs" "-f"
            }
            pane command="htop"
        }
    }
    
    tab name="Database" {
        pane command="psql" {
            args "-U" "postgres" "-d" "mydb"
        }
    }
}
EOF

# Start with custom layout
zellij --layout development
```

### Plugin Management
```bash
# Install plugins
mkdir -p ~/.config/zellij/plugins

# Download community plugins
curl -L https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm \
    -o ~/.config/zellij/plugins/zjstatus.wasm

# Configure plugin in config.kdl
cat >> ~/.config/zellij/config.kdl << 'EOF'
plugins {
    zjstatus { path "zjstatus"; }
}
EOF
```

### Session Management Scripts
```bash
#!/bin/bash
# Advanced session management

# Create project-specific session
create_project_session() {
    local project_name="$1"
    local project_path="$2"
    
    if [[ -z "$project_name" || -z "$project_path" ]]; then
        echo "Usage: create_project_session <name> <path>"
        return 1
    fi
    
    # Create session with project layout
    zellij new-session --name "$project_name" \
        --layout project \
        --cwd "$project_path"
}

# Session backup and restore
backup_sessions() {
    local backup_file="$HOME/.config/zellij/sessions_backup.json"
    zellij list-sessions --format json > "$backup_file"
    echo "Sessions backed up to $backup_file"
}

restore_sessions() {
    local backup_file="$HOME/.config/zellij/sessions_backup.json"
    if [[ -f "$backup_file" ]]; then
        while IFS= read -r session; do
            local name=$(echo "$session" | jq -r '.name')
            echo "Restoring session: $name"
            zellij new-session --name "$name" --detached
        done < <(jq -c '.[]' "$backup_file")
    fi
}
```

### Collaborative Sessions
```bash
# Share session with others
share_session() {
    local session_name="$1"
    local user="$2"
    
    echo "Starting collaborative session: $session_name"
    zellij new-session --name "$session_name"
    
    # Generate connection command for other user
    echo "Share this command with $user:"
    echo "zellij attach $session_name"
}

# Multi-user development environment
create_team_session() {
    local project_name="$1"
    
    # Create session with team layout
    zellij new-session --name "team-$project_name" --layout team-dev
    
    echo "Team session created: team-$project_name"
    echo "Team members can join with: zellij attach team-$project_name"
}
```

### Integration with Development Tools
```bash
# Git integration
git_session() {
    local repo_path="$1"
    cd "$repo_path" || return 1
    
    zellij new-session --name "git-$(basename "$repo_path")" --layout git-workflow
}

# Docker development environment
docker_session() {
    local compose_file="$1"
    
    zellij new-session --name "docker-dev" --layout docker-dev \
        --cwd "$(dirname "$compose_file")"
}

# Testing environment
test_session() {
    local project_path="$1"
    
    cd "$project_path" || return 1
    zellij new-session --name "testing-$(basename "$project_path")" \
        --layout testing
}
```

### Custom Themes
```bash
# Create custom theme
mkdir -p ~/.config/zellij/themes

cat > ~/.config/zellij/themes/custom-dark.kdl << 'EOF'
themes {
    custom-dark {
        fg 248 248 242
        bg 40 40 40
        red 249 38 114
        green 166 226 46
        yellow 244 191 117
        blue 102 217 239
        magenta 174 129 255
        orange 253 151 31
        cyan 161 239 228
        black 0 0 0
        white 248 248 248
    }
}
EOF

# Use custom theme in config
echo 'theme "custom-dark"' >> ~/.config/zellij/config.kdl
```

### Performance Optimization
```bash
# Optimize for large projects
optimize_zellij() {
    cat >> ~/.config/zellij/config.kdl << 'EOF'
// Performance optimizations
ui {
    pane_frames {
        rounded_corners false  // Disable for better performance
    }
}

// Reduce memory usage
scroll_buffer_size 1000
mouse_mode false  // Disable if not needed

// Faster rendering
simplified_ui true
EOF
}

# Memory usage monitoring
monitor_zellij() {
    while true; do
        ps aux | grep zellij | grep -v grep
        sleep 5
    done
}
```

## Integration Examples

### With Development Environments
```bash
# React development session
react_dev_session() {
    local project_path="$1"
    
    cat > /tmp/react-layout.kdl << 'EOF'
layout {
    tab name="Development" focus=true {
        pane split_direction="vertical" {
            pane split_direction="horizontal" {
                pane command="nvim" { args "."; }
                pane command="npm" { args "test" "--" "--watch"; }
            }
            pane split_direction="horizontal" {
                pane command="npm" { args "start"; }
                pane command="git" { args "status"; }
            }
        }
    }
    tab name="Build" {
        pane command="npm" { args "run" "build"; }
    }
}
EOF
    
    cd "$project_path" || return 1
    zellij --layout /tmp/react-layout.kdl new-session --name "react-$(basename "$project_path")"
}

# Python development session
python_dev_session() {
    local project_path="$1"
    local venv_path="$2"
    
    cat > /tmp/python-layout.kdl << 'EOF'
layout {
    tab name="Code" focus=true {
        pane split_direction="vertical" {
            pane command="nvim" { args "."; }
            pane split_direction="horizontal" {
                pane command="python" { args "-m" "pytest" "--watch"; }
                pane
            }
        }
    }
    tab name="REPL" {
        pane command="python"
    }
    tab name="Jupyter" {
        pane command="jupyter" { args "lab"; }
    }
}
EOF
    
    cd "$project_path" || return 1
    source "$venv_path/bin/activate"
    zellij --layout /tmp/python-layout.kdl new-session --name "python-$(basename "$project_path")"
}
```

### With System Administration
```bash
# Server monitoring session
monitoring_session() {
    local server_name="$1"
    
    cat > /tmp/monitoring-layout.kdl << 'EOF'
layout {
    tab name="System" focus=true {
        pane split_direction="vertical" {
            pane command="htop"
            pane split_direction="horizontal" {
                pane command="iostat" { args "-x" "1"; }
                pane command="nethogs"
            }
        }
    }
    tab name="Logs" {
        pane split_direction="horizontal" {
            pane command="journalctl" { args "-f"; }
            pane command="tail" { args "-f" "/var/log/syslog"; }
        }
    }
    tab name="Docker" {
        pane split_direction="vertical" {
            pane command="docker" { args "stats"; }
            pane command="docker" { args "ps"; }
        }
    }
}
EOF
    
    zellij --layout /tmp/monitoring-layout.kdl new-session --name "monitor-$server_name"
}

# Database administration session
dba_session() {
    local db_name="$1"
    
    cat > /tmp/dba-layout.kdl << 'EOF'
layout {
    tab name="Console" focus=true {
        pane command="psql" { args "-d" "$DB_NAME"; }
    }
    tab name="Monitoring" {
        pane split_direction="horizontal" {
            pane command="pg_top"
            pane command="tail" { args "-f" "/var/log/postgresql/postgresql.log"; }
        }
    }
    tab name="Backup" {
        pane
    }
}
EOF
    
    DB_NAME="$db_name" zellij --layout /tmp/dba-layout.kdl new-session --name "dba-$db_name"
}
```

### With Remote Development
```bash
# Remote development session
remote_dev_session() {
    local host="$1"
    local project_path="$2"
    
    # Create SSH session with development layout
    ssh -t "$host" "cd $project_path && zellij attach dev || zellij new-session --name dev --layout development"
}

# Tmux migration helper
migrate_from_tmux() {
    echo "Migrating tmux sessions to zellij..."
    
    # List tmux sessions
    tmux list-sessions -F "#{session_name}" 2>/dev/null | while read -r session; do
        echo "Creating zellij session for tmux session: $session"
        
        # Create equivalent zellij session
        zellij new-session --name "tmux-$session" --detached
    done
    
    echo "Migration complete. Use 'zellij list-sessions' to see new sessions."
}
```

## Troubleshooting

### Common Issues

**Issue**: Zellij not starting properly
```bash
# Solution: Check configuration syntax
zellij setup --check

# Solution: Reset configuration
mv ~/.config/zellij ~/.config/zellij.backup
zellij setup --generate-config

# Solution: Check terminal compatibility
echo $TERM
export TERM=xterm-256color
```

**Issue**: Key bindings not working
```bash
# Solution: Check for conflicts with terminal/shell
# Remove conflicting bindings from ~/.bashrc or ~/.zshrc

# Solution: Reset key bindings
zellij setup --generate-config --clean
```

**Issue**: Poor performance
```bash
# Solution: Optimize configuration
cat >> ~/.config/zellij/config.kdl << 'EOF'
ui {
    pane_frames {
        rounded_corners false
    }
}
mouse_mode false
scroll_buffer_size 1000
EOF
```

**Issue**: Sessions not persisting
```bash
# Solution: Check session directory
ls ~/.cache/zellij/

# Solution: Manual session backup
zellij list-sessions --format json > ~/.config/zellij/sessions.json
```

### Performance Tips
```bash
# Reduce memory usage
scroll_buffer_size 1000
mouse_mode false

# Improve rendering
simplified_ui true
pane_frames { rounded_corners false }

# Optimize for remote connections
copy_clipboard "system"
copy_on_select false
```

### Migration from Tmux
```bash
# Key binding comparison helper
tmux_to_zellij_keys() {
    echo "Tmux -> Zellij key bindings:"
    echo "Ctrl+b % -> Ctrl+p r (split right)"
    echo "Ctrl+b \" -> Ctrl+p d (split down)"
    echo "Ctrl+b o -> Alt+h/j/k/l (navigate)"
    echo "Ctrl+b c -> Ctrl+t n (new tab)"
    echo "Ctrl+b & -> Ctrl+t x (close tab)"
    echo "Ctrl+b d -> Alt+d (detach)"
    echo "Ctrl+b [ -> Ctrl+s (scroll mode)"
}

# Configuration migration
migrate_tmux_config() {
    if [[ -f ~/.tmux.conf ]]; then
        echo "Found tmux config. Manual migration required."
        echo "Common tmux features and zellij equivalents:"
        echo "- status-line -> status-bar plugin"
        echo "- window names -> tab names"
        echo "- pane titles -> pane names"
        echo "- session management -> built-in session management"
    fi
}
```

## Comparison with Alternatives

### Zellij vs Tmux
```bash
# Feature comparison:
# Zellij advantages:
# - Modern UI with better visual feedback
# - Easier configuration with KDL format
# - Built-in plugin system
# - Better mouse support
# - Collaborative features

# Tmux advantages:
# - More mature and stable
# - Wider adoption and community
# - More lightweight
# - Better tested in edge cases
```

### Zellij vs Screen
```bash
# Zellij advantages:
# - Modern interface and features
# - Better session management
# - Plugin ecosystem
# - Active development

# Screen advantages:
# - Available on more systems by default
# - Simpler and more lightweight
# - Extremely stable
```

## Resources and References

- [Zellij GitHub Repository](https://github.com/zellij-org/zellij)
- [Zellij Documentation](https://zellij.dev/)
- [Configuration Guide](https://zellij.dev/documentation/configuration.html)
- [Plugin Development](https://zellij.dev/documentation/plugins.html)
- [Layout System](https://zellij.dev/documentation/layouts.html)
- [Community Plugins](https://github.com/zellij-org/awesome-zellij)

This guide provides comprehensive coverage of zellij installation, configuration, and usage patterns for effective terminal multiplexing and workspace management.