# Bottom - System Monitor Installation and Setup Guide

## Overview

**Bottom** (also known as `btm`) is a cross-platform graphical process/system monitor with a customizable interface, written in Rust. It provides real-time system information including CPU usage, memory consumption, disk I/O, network activity, and process management in an intuitive terminal-based interface.

### Key Features
- **Real-time monitoring**: CPU, memory, disk, network, and process statistics
- **Interactive interface**: Mouse and keyboard navigation
- **Customizable layouts**: Flexible widget arrangement
- **Process management**: Kill, sort, and filter processes
- **Multiple data sources**: Support for various system metrics
- **Themes and colors**: Customizable appearance

### Why Use Bottom?
- More feature-rich than `top` and `htop`
- Better visualization of system resources
- Modern, responsive interface
- Extensive customization options
- Cross-platform compatibility
- Low resource usage

## Installation

### Prerequisites
- Terminal with color support
- Modern system (Linux, macOS, Windows)

### Via Mise (Recommended)
```bash
# Install bottom via mise
mise use -g bottom

# Verify installation
btm --version
```

### Manual Installation
```bash
# Install via cargo
cargo install bottom

# Or download binary release
curl -L https://github.com/ClementTsang/bottom/releases/latest/download/bottom_x86_64-unknown-linux-gnu.tar.gz | tar xz
sudo mv btm /usr/local/bin/
```

### Verify Installation
```bash
# Test basic functionality
btm --version

# Quick test run
btm --help
```

## Configuration

### Configuration File
```bash
# Create config directory
mkdir -p ~/.config/bottom

# Create configuration file
cat > ~/.config/bottom/bottom.toml << 'EOF'
# Bottom configuration file

[flags]
# Basic settings
battery = true
disable_click = false
dot_marker = false
group_processes = false
hide_table_gap = false
hide_time = false
left_legend = false
mem_as_value = false
tree = false
show_table_scroll_position = false
whole_word = false
case_sensitive = false
current_usage = false
expanded_on_startup = false

# Display settings
default_time_value = "30s"
time_delta = 1000
rate = 1000

# Color settings
color = "default"

[colors]
# Custom color scheme
table_header_color = "LightBlue"
widget_title_color = "Gray"
border_color = "Gray"
highlighted_border_color = "LightBlue"
text_color = "Gray"
graph_color = "Gray"
cursor_color = "Red"
selected_text_color = "Black"
selected_bg_color = "LightBlue"
EOF
```

### Shell Integration
```bash
# Add to ~/.bashrc or ~/.zshrc
alias btop='btm'
alias htop='btm'
alias top='btm'

# Function for quick system overview
sysmon() {
    btm --basic --time_delta 500
}

# Function for process monitoring
procmon() {
    btm --process --time_delta 1000
}
```

## Basic Usage

### Starting Bottom
```bash
# Start with default settings
btm

# Start with basic mode (less widgets)
btm --basic

# Start with expanded process view
btm --expanded

# Start with tree view of processes
btm --tree
```

### Navigation
```bash
# Basic navigation keys:
# q or Ctrl+C : Quit
# h : Show help
# Tab : Switch between widgets
# Shift+Tab : Reverse switch between widgets
# Up/Down : Navigate items
# Left/Right : Switch between time intervals
# + : Zoom in on time interval
# - : Zoom out on time interval
# = : Reset zoom
# Space : Pause/resume updates
```

### Process Management
```bash
# Process interaction:
# d : Kill selected process
# c : Sort by CPU usage
# m : Sort by memory usage
# p : Sort by process name
# n : Sort by PID
# / : Search processes
# s : Sort by process state
# Enter : Show process details
```

### Customization Options
```bash
# Different layouts
btm --default_widget_type proc  # Start with process widget
btm --default_widget_type cpu   # Start with CPU widget
btm --default_widget_type mem   # Start with memory widget

# Time intervals
btm --time_delta 500           # Update every 500ms
btm --default_time_value "60s" # Show last 60 seconds

# Display options
btm --hide_time                # Hide time axis
btm --dot_marker              # Use dots instead of lines
btm --mem_as_value            # Show memory as values
```

## Advanced Usage

### Custom Layouts
```bash
# Create custom layout configuration
cat > ~/.config/bottom/layout.toml << 'EOF'
[[row]]
  [[row.child]]
    type = "cpu"
    ratio = 30
  [[row.child]]
    type = "mem"
    ratio = 40
  [[row.child]]
    type = "net"
    ratio = 30

[[row]]
  [[row.child]]
    type = "proc"
    ratio = 100
EOF

# Use custom layout
btm --config ~/.config/bottom/layout.toml
```

### Advanced Process Filtering
```bash
# Filter processes by name
btm --process --regex "chrome|firefox"

# Filter by user
btm --process --regex "^$(whoami)"

# Show only high CPU processes
btm --process --cpu_left_legend
```

### Performance Monitoring
```bash
# High-frequency monitoring
btm --time_delta 100 --rate 100

# Memory-focused monitoring
btm --mem_as_value --expanded --default_widget_type mem

# Network monitoring
btm --default_widget_type net --time_delta 1000
```

### System Analysis Scripts
```bash
#!/bin/bash
# System health check script using bottom

check_system_health() {
    echo "=== System Health Check ==="
    
    # Get current system stats
    btm --basic --time_delta 1000 --autohide_time &
    BTM_PID=$!
    
    # Let it run for 10 seconds
    sleep 10
    
    # Kill bottom
    kill $BTM_PID
    
    echo "Health check complete"
}

# Resource usage alerting
monitor_resources() {
    local cpu_threshold=80
    local mem_threshold=90
    
    while true; do
        # This is a conceptual example - bottom doesn't export data directly
        # You would typically use other tools for scripting
        echo "Monitoring resources..."
        sleep 30
    done
}
```

### Integration with Other Tools
```bash
# Use with tmux for persistent monitoring
tmux new-session -d -s monitor 'btm'

# Create monitoring dashboard
create_dashboard() {
    tmux new-session -d -s dashboard
    tmux split-window -h -t dashboard
    tmux send-keys -t dashboard:0 'btm --basic' Enter
    tmux send-keys -t dashboard:1 'btm --expanded --default_widget_type proc' Enter
    tmux attach-session -t dashboard
}

# Log system stats (conceptual - bottom doesn't export directly)
log_system_stats() {
    local log_file="$1"
    echo "$(date): Starting system monitoring" >> "$log_file"
    # Use other tools for actual logging
    vmstat 1 >> "$log_file" &
    iostat 1 >> "$log_file" &
}
```

### Custom Themes
```bash
# Create custom color scheme
cat > ~/.config/bottom/themes/custom.toml << 'EOF'
[colors]
# Custom dark theme
table_header_color = "Cyan"
widget_title_color = "Yellow"
border_color = "White"
highlighted_border_color = "Cyan"
text_color = "White"
graph_color = "Green"
cursor_color = "Red"
selected_text_color = "Black"
selected_bg_color = "Cyan"
high_battery_color = "Green"
medium_battery_color = "Yellow"
low_battery_color = "Red"
EOF

# Use custom theme
btm --config ~/.config/bottom/themes/custom.toml
```

### Keyboard Shortcuts Configuration
```bash
# Custom keybindings in config
cat >> ~/.config/bottom/bottom.toml << 'EOF'
[key_bindings]
# Custom key bindings
quit = "q"
help = "h"
toggle_pause = "space"
search = "/"
process_kill = "d"
process_terminate = "t"
zoom_in = "+"
zoom_out = "-"
zoom_reset = "="
EOF
```

### Performance Optimization
```bash
# Optimize for low-end systems
btm --time_delta 2000 --rate 2000 --hide_time --basic

# Optimize for high-end systems
btm --time_delta 100 --rate 100 --expanded

# Memory-conscious monitoring
btm --mem_as_value --disable_click --hide_table_gap
```

## Integration Examples

### System Administration
```bash
# Create system monitoring script
#!/bin/bash
monitor_system() {
    echo "Starting system monitoring..."
    
    # Background monitoring
    btm --basic --time_delta 1000 &
    BTM_PID=$!
    
    # Cleanup on exit
    trap "kill $BTM_PID" EXIT
    
    # Wait for user interrupt
    wait
}

# Performance analysis
analyze_performance() {
    local duration="${1:-60}"
    echo "Analyzing system performance for ${duration} seconds..."
    
    # Start bottom in background
    btm --expanded --time_delta 500 &
    BTM_PID=$!
    
    sleep "$duration"
    kill $BTM_PID
    
    echo "Performance analysis complete"
}
```

### Development Environment
```bash
# Monitor development tools
dev_monitor() {
    echo "Monitoring development environment..."
    
    # Monitor common development processes
    btm --process --regex "node|python|java|docker|code"
}

# Resource usage during builds
build_monitor() {
    local build_command="$1"
    
    echo "Starting build monitoring..."
    btm --basic --time_delta 500 &
    BTM_PID=$!
    
    # Run build command
    eval "$build_command"
    
    # Stop monitoring
    kill $BTM_PID
    echo "Build monitoring complete"
}
```

### Docker Integration
```bash
# Monitor Docker containers
docker_monitor() {
    echo "Monitoring Docker containers..."
    btm --process --regex "docker|containerd"
}

# Container resource analysis
container_analysis() {
    local container_name="$1"
    
    echo "Analyzing container: $container_name"
    
    # Monitor specific container processes
    btm --process --regex "$container_name"
}
```

## Troubleshooting

### Common Issues

**Issue**: Bottom not showing colors
```bash
# Solution: Check terminal color support
echo $TERM
export TERM=xterm-256color
btm --color always
```

**Issue**: High CPU usage by bottom itself
```bash
# Solution: Increase update intervals
btm --time_delta 2000 --rate 2000
```

**Issue**: Mouse not working
```bash
# Solution: Enable mouse support
btm --disable_click false
# Or check terminal mouse support
```

**Issue**: Missing system information
```bash
# Solution: Check system permissions
# Some metrics may require elevated permissions
sudo btm
```

### Performance Tips
```bash
# Reduce resource usage
btm --basic --time_delta 1000 --hide_time --disable_click

# Optimize for remote sessions
btm --dot_marker --hide_table_gap --basic

# Better responsiveness
btm --time_delta 250 --rate 250
```

### Configuration Troubleshooting
```bash
# Test configuration
btm --config ~/.config/bottom/bottom.toml --help

# Reset to defaults
mv ~/.config/bottom/bottom.toml ~/.config/bottom/bottom.toml.backup
btm  # Will use default configuration

# Debug configuration issues
btm --debug
```

## Comparison with Alternatives

### Bottom vs htop
```bash
# Bottom advantages:
# - More modern interface
# - Better visualization
# - More customization options
# - Cross-platform

# htop advantages:
# - More mature
# - Simpler interface
# - Better known by sysadmins
```

### Bottom vs top
```bash
# Bottom advantages:
# - Graphical interface
# - Real-time graphs
# - Better process management
# - More system information

# top advantages:
# - Available on all systems
# - Lower resource usage
# - Simpler operation
```

## Resources and References

- [Bottom GitHub Repository](https://github.com/ClementTsang/bottom)
- [Bottom Documentation](https://clementtsang.github.io/bottom/)
- [Configuration Guide](https://clementtsang.github.io/bottom/configuration/)
- [Rust CLI Tools](https://github.com/rust-cli/awesome-rust-cli)

This guide provides comprehensive coverage of bottom installation, configuration, and usage patterns for effective system monitoring and process management.