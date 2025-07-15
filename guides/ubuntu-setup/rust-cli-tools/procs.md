# Procs - Modern Process Viewer Installation and Setup Guide

## Overview

**Procs** is a modern replacement for the `ps` command written in Rust. It provides a more intuitive and feature-rich way to view and manage system processes with colored output, advanced filtering, and better process tree visualization.

### Key Features
- **Colored output**: Syntax highlighting for better readability
- **Advanced filtering**: Multiple filter criteria and conditions
- **Tree view**: Hierarchical process relationships
- **Sorting options**: Sort by various process attributes
- **Themes**: Customizable color schemes
- **Search capability**: Find processes by name, command, or other attributes
- **Cross-platform**: Works on Linux, macOS, and Windows

### Why Use Procs?
- More readable output than traditional `ps`
- Better process tree visualization
- Powerful filtering and search capabilities
- Modern interface with colors and themes
- Faster and more intuitive than `ps` + `grep` combinations
- Active development with regular updates

## Installation

### Prerequisites
- Rust toolchain (for building from source)
- Modern terminal with color support

### Via Mise (Recommended)
```bash
# Install procs via mise
mise use -g cargo:procs

# Verify installation
procs --version
```

### Manual Installation
```bash
# Install via cargo
cargo install procs

# Or download binary release
curl -L https://github.com/dalance/procs/releases/latest/download/procs-v0.14.4-x86_64-linux.zip -o procs.zip
unzip procs.zip
sudo mv procs /usr/local/bin/

# Or via package manager (if available)
# sudo apt install procs  # On newer Ubuntu versions
```

### Verify Installation
```bash
# Test basic functionality
procs --help

# Show all processes
procs

# Check version
procs --version
```

## Configuration

### Configuration File
```bash
# Create config directory
mkdir -p ~/.config/procs

# Create configuration file
cat > ~/.config/procs/config.toml << 'EOF'
[[columns]]
kind = "Pid"
style = "BrightYellow|Bold"
numeric_search = true
nonnumeric_search = false

[[columns]]
kind = "User"
style = "BrightGreen"
numeric_search = false
nonnumeric_search = true

[[columns]]
kind = "Separator"
style = "White"
numeric_search = false
nonnumeric_search = false

[[columns]]
kind = "Tty"
style = "BrightWhite"
numeric_search = false
nonnumeric_search = false

[[columns]]
kind = "UsageCpu"
style = "BrightMagenta"
numeric_search = true
nonnumeric_search = false

[[columns]]
kind = "UsageMemory"
style = "BrightCyan"
numeric_search = true
nonnumeric_search = false

[[columns]]
kind = "CpuTime"
style = "White"
numeric_search = false
nonnumeric_search = false

[[columns]]
kind = "Command"
style = "BrightWhite"
numeric_search = false
nonnumeric_search = true

[style]
header = "BrightWhite|Bold"
unit = "BrightBlack"
tree = "BrightBlack"

[search]
numeric_search = "BrightBlue|Bold"
nonnumeric_search = "BrightGreen|Bold"
logic = "BrightRed|Bold"

[display]
show_self = false
show_thread = false
show_thread_in_tree = true
cut_to_terminal = true
cut_to_pager = false
cut_to_pipe = false
color_mode = "auto"
separator = "│"

[sort]
column = 0
order = "ascending"

[docker]
path = "docker"

[pager]
mode = "auto"
command = "less"
EOF
```

### Shell Integration
```bash
# Add to ~/.bashrc or ~/.zshrc
alias ps='procs'
alias pst='procs --tree'
alias pss='procs --sortd cpu'
alias psm='procs --sortd memory'

# Useful functions
psgrep() {
    local pattern="$1"
    procs --and --or "$pattern"
}

pskill() {
    local pattern="$1"
    local signal="${2:-TERM}"
    procs --and --or "$pattern" --no-header | awk '{print $1}' | xargs -r kill -"$signal"
}

# Function to monitor specific processes
pswatch() {
    local pattern="$1"
    local interval="${2:-2}"
    
    while true; do
        clear
        echo "=== Processes matching '$pattern' ($(date)) ==="
        procs --and --or "$pattern"
        sleep "$interval"
    done
}

# Function for detailed process info
psinfo() {
    local pid="$1"
    procs --pid "$pid" --insert StartTime,VmRss,VmSize,Threads
}
```

### Custom Themes
```bash
# Create custom theme
cat > ~/.config/procs/themes/dark.toml << 'EOF'
# Dark theme for procs
[[columns]]
kind = "Pid"
style = "Yellow"

[[columns]]
kind = "User"
style = "Green"

[[columns]]
kind = "Separator"
style = "DarkGray"

[[columns]]
kind = "State"
style = "Cyan"

[[columns]]
kind = "UsageCpu"
style = "Red"

[[columns]]
kind = "UsageMemory"
style = "Blue"

[[columns]]
kind = "Command"
style = "White"

[style]
header = "BrightWhite|Bold"
unit = "DarkGray"
tree = "DarkGray"

[search]
numeric_search = "BrightBlue"
nonnumeric_search = "BrightGreen"
logic = "BrightRed"
EOF

# Use custom theme
procs --theme dark
```

## Basic Usage

### Viewing Processes
```bash
# Show all processes
procs

# Show processes in tree format
procs --tree

# Show only your processes
procs --uid $(id -u)

# Show processes for specific user
procs --uid 0  # root processes
procs --user postgres

# Show kernel threads
procs --kernel

# Show threads
procs --thread
```

### Filtering and Searching
```bash
# Search by process name
procs firefox

# Search by command pattern
procs python

# Search by multiple criteria (AND)
procs --and firefox --and --pid 1000

# Search by multiple criteria (OR)
procs --or firefox --or chrome

# Search by PID
procs --pid 1234

# Search by PPID (parent process ID)
procs --ppid 1

# Search by process state
procs --state S  # Sleeping processes
procs --state R  # Running processes
procs --state Z  # Zombie processes
```

### Sorting and Ordering
```bash
# Sort by CPU usage (descending)
procs --sortd cpu

# Sort by memory usage (descending)
procs --sortd memory

# Sort by PID (ascending)
procs --sorta pid

# Sort by start time
procs --sortd start

# Sort by command name
procs --sorta command
```

## Advanced Usage

### Custom Column Display
```bash
# Show specific columns
procs --insert Pid,User,State,Command

# Show additional information
procs --insert StartTime,VmRss,VmSize,Threads

# Show Docker container info
procs --insert Docker

# Show environment variables
procs --insert Env

# Show file descriptors
procs --insert Fd

# Comprehensive view
procs --insert Pid,User,State,Priority,Nice,UsageCpu,UsageMemory,VmRss,VmSize,Threads,Command
```

### Process Tree Analysis
```bash
# Show complete process tree
procs --tree

# Show tree for specific process and children
procs --tree --ppid 1

# Show tree with thread information
procs --tree --thread

# Focus on specific process tree
procs --tree firefox

# Show systemd services tree
procs --tree --ppid 1 | grep systemd
```

### System Monitoring
```bash
# Monitor high CPU processes
monitor_cpu() {
    local threshold="${1:-80}"
    echo "Monitoring processes with CPU usage > ${threshold}%"
    
    while true; do
        clear
        echo "=== High CPU Processes ($(date)) ==="
        procs --sortd cpu | head -20
        
        # Check for high CPU processes
        high_cpu=$(procs --sortd cpu --no-header | head -10 | awk -v thresh="$threshold" '$6 > thresh {print $1, $6}')
        
        if [[ -n "$high_cpu" ]]; then
            echo
            echo "=== Alert: High CPU Usage ==="
            echo "$high_cpu"
        fi
        
        sleep 5
    done
}

# Monitor memory usage
monitor_memory() {
    local threshold="${1:-80}"
    echo "Monitoring processes with memory usage > ${threshold}%"
    
    while true; do
        clear
        echo "=== High Memory Processes ($(date)) ==="
        procs --sortd memory | head -20
        
        sleep 5
    done
}

# System overview
system_overview() {
    echo "=== System Process Overview ==="
    echo
    echo "Total processes: $(procs --no-header | wc -l)"
    echo "Running processes: $(procs --state R --no-header | wc -l)"
    echo "Sleeping processes: $(procs --state S --no-header | wc -l)"
    echo "Zombie processes: $(procs --state Z --no-header | wc -l)"
    echo
    echo "Top 10 CPU consumers:"
    procs --sortd cpu | head -11
    echo
    echo "Top 10 Memory consumers:"
    procs --sortd memory | head -11
}
```

### Process Management Scripts
```bash
#!/bin/bash
# Process management utilities

# Kill processes by pattern
kill_by_pattern() {
    local pattern="$1"
    local signal="${2:-TERM}"
    
    echo "Finding processes matching: $pattern"
    local pids=$(procs --and --or "$pattern" --no-header | awk '{print $1}')
    
    if [[ -z "$pids" ]]; then
        echo "No processes found matching: $pattern"
        return 1
    fi
    
    echo "Processes found:"
    procs --and --or "$pattern"
    
    read -p "Kill these processes with signal $signal? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "$pids" | xargs -r kill -"$signal"
        echo "Signal $signal sent to processes"
    else
        echo "Operation cancelled"
    fi
}

# Process resource analysis
analyze_process() {
    local pid="$1"
    
    if [[ -z "$pid" ]]; then
        echo "Usage: analyze_process <PID>"
        return 1
    fi
    
    echo "=== Process Analysis for PID $pid ==="
    
    # Basic info
    procs --pid "$pid" --insert Pid,PPid,User,State,Priority,Nice,Command
    echo
    
    # Resource usage
    echo "=== Resource Usage ==="
    procs --pid "$pid" --insert Pid,UsageCpu,UsageMemory,VmRss,VmSize,Threads
    echo
    
    # Timing info
    echo "=== Timing Information ==="
    procs --pid "$pid" --insert Pid,StartTime,CpuTime
    echo
    
    # File descriptors
    echo "=== File Descriptors ==="
    procs --pid "$pid" --insert Pid,Fd
    echo
    
    # Process tree context
    echo "=== Process Tree Context ==="
    procs --tree --ppid "$(procs --pid "$pid" --no-header | awk '{print $2}')"
}

# Service monitoring
monitor_service() {
    local service_pattern="$1"
    local log_file="/tmp/service_monitor_$(date +%Y%m%d).log"
    
    echo "Monitoring service: $service_pattern"
    echo "Log file: $log_file"
    
    while true; do
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        
        {
            echo "[$timestamp] Service status for: $service_pattern"
            procs --and --or "$service_pattern" --insert Pid,User,State,UsageCpu,UsageMemory,Command
            echo "---"
        } >> "$log_file"
        
        # Display current status
        clear
        echo "=== Service Monitor: $service_pattern ==="
        echo "Timestamp: $timestamp"
        echo "Log: $log_file"
        echo
        procs --and --or "$service_pattern" --insert Pid,User,State,UsageCpu,UsageMemory,Command
        
        sleep 10
    done
}
```

### Docker Integration
```bash
# Monitor Docker containers
docker_processes() {
    echo "=== Docker Container Processes ==="
    procs --insert Pid,User,UsageCpu,UsageMemory,Docker,Command | grep -E "docker|containerd"
}

# Analyze container resource usage
container_analysis() {
    local container_pattern="$1"
    
    echo "=== Container Process Analysis: $container_pattern ==="
    
    # Find container processes
    procs --and --or "$container_pattern" --insert Pid,PPid,User,UsageCpu,UsageMemory,Docker,Command
    
    echo
    echo "=== Resource Summary ==="
    
    # Calculate total resource usage
    local total_cpu=$(procs --and --or "$container_pattern" --no-header | awk '{sum+=$6} END {print sum}')
    local total_mem=$(procs --and --or "$container_pattern" --no-header | awk '{sum+=$7} END {print sum}')
    
    echo "Total CPU usage: ${total_cpu}%"
    echo "Total Memory usage: ${total_mem}%"
}
```

### Log Analysis Integration
```bash
# Process activity logger
log_process_activity() {
    local pattern="$1"
    local log_file="/tmp/process_activity_$(date +%Y%m%d).log"
    local interval="${2:-60}"
    
    echo "Logging process activity for: $pattern"
    echo "Interval: ${interval}s, Log: $log_file"
    
    while true; do
        {
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Process snapshot"
            procs --and --or "$pattern" --no-header
            echo "---"
        } >> "$log_file"
        
        sleep "$interval"
    done
}

# Resource usage history
resource_history() {
    local pid="$1"
    local duration="${2:-3600}"  # 1 hour default
    local interval="${3:-30}"    # 30 seconds default
    
    echo "Recording resource usage for PID $pid"
    echo "Duration: ${duration}s, Interval: ${interval}s"
    
    local end_time=$(($(date +%s) + duration))
    local history_file="/tmp/resource_history_${pid}_$(date +%Y%m%d_%H%M%S).csv"
    
    echo "timestamp,pid,cpu_usage,memory_usage,vm_rss,vm_size" > "$history_file"
    
    while [[ $(date +%s) -lt $end_time ]]; do
        local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
        local stats=$(procs --pid "$pid" --no-header --insert Pid,UsageCpu,UsageMemory,VmRss,VmSize 2>/dev/null)
        
        if [[ -n "$stats" ]]; then
            echo "$timestamp,$stats" >> "$history_file"
        else
            echo "Process $pid not found, stopping monitoring"
            break
        fi
        
        sleep "$interval"
    done
    
    echo "Resource history saved to: $history_file"
}
```

## Integration Examples

### With System Administration
```bash
# System health check
system_health_check() {
    echo "=== System Health Check ==="
    echo "Generated: $(date)"
    echo
    
    # Process count by state
    echo "Process States:"
    echo "  Running: $(procs --state R --no-header | wc -l)"
    echo "  Sleeping: $(procs --state S --no-header | wc -l)"
    echo "  Zombie: $(procs --state Z --no-header | wc -l)"
    echo "  Stopped: $(procs --state T --no-header | wc -l)"
    echo
    
    # High resource usage
    echo "Top 5 CPU consumers:"
    procs --sortd cpu | head -6
    echo
    
    echo "Top 5 Memory consumers:"
    procs --sortd memory | head -6
    echo
    
    # Check for zombies
    local zombies=$(procs --state Z --no-header | wc -l)
    if [[ $zombies -gt 0 ]]; then
        echo "⚠️  Warning: $zombies zombie processes detected"
        procs --state Z
        echo
    fi
    
    # Check for high CPU usage
    local high_cpu=$(procs --sortd cpu --no-header | head -5 | awk '$6 > 80 {print $1}')
    if [[ -n "$high_cpu" ]]; then
        echo "⚠️  Warning: Processes with high CPU usage (>80%)"
        echo "$high_cpu" | while read -r pid; do
            procs --pid "$pid"
        done
        echo
    fi
}

# Service status checker
check_services() {
    local services=("nginx" "apache2" "mysql" "postgresql" "redis" "docker")
    
    echo "=== Service Status Check ==="
    
    for service in "${services[@]}"; do
        local count=$(procs --and --or "$service" --no-header | wc -l)
        if [[ $count -gt 0 ]]; then
            echo "✓ $service: $count processes"
            procs --and --or "$service" --insert Pid,User,State,UsageCpu,UsageMemory,Command
        else
            echo "✗ $service: not running"
        fi
        echo
    done
}
```

### With Development Workflows
```bash
# Development environment monitor
dev_monitor() {
    local project_dir="$1"
    local project_name="$(basename "$project_dir")"
    
    echo "=== Development Environment Monitor: $project_name ==="
    
    # Common development processes
    local dev_patterns=("node" "python" "java" "docker" "webpack" "gulp" "npm" "yarn")
    
    for pattern in "${dev_patterns[@]}"; do
        local processes=$(procs --and --or "$pattern" --no-header)
        if [[ -n "$processes" ]]; then
            echo "--- $pattern processes ---"
            procs --and --or "$pattern" --insert Pid,User,UsageCpu,UsageMemory,Command
            echo
        fi
    done
}

# Build process monitor
build_monitor() {
    local build_command="$1"
    local monitor_file="/tmp/build_monitor_$(date +%Y%m%d_%H%M%S).log"
    
    echo "Starting build monitor for: $build_command"
    echo "Monitor log: $monitor_file"
    
    # Start build in background
    $build_command &
    local build_pid=$!
    
    echo "Build PID: $build_pid"
    
    # Monitor build process
    while kill -0 $build_pid 2>/dev/null; do
        {
            echo "$(date '+%Y-%m-%d %H:%M:%S') - Build process status"
            procs --ppid $build_pid --tree --insert Pid,PPid,User,UsageCpu,UsageMemory,Command
            echo "---"
        } >> "$monitor_file"
        
        sleep 5
    done
    
    echo "Build completed. Monitor log saved to: $monitor_file"
}
```

### With Monitoring Systems
```bash
# Prometheus metrics exporter (conceptual)
export_metrics() {
    local metrics_file="/tmp/procs_metrics.prom"
    
    {
        echo "# HELP procs_cpu_usage Process CPU usage percentage"
        echo "# TYPE procs_cpu_usage gauge"
        
        procs --no-header --insert Pid,User,Command,UsageCpu | while read -r pid user command cpu; do
            echo "procs_cpu_usage{pid=\"$pid\",user=\"$user\",command=\"$command\"} $cpu"
        done
        
        echo "# HELP procs_memory_usage Process memory usage percentage"
        echo "# TYPE procs_memory_usage gauge"
        
        procs --no-header --insert Pid,User,Command,UsageMemory | while read -r pid user command memory; do
            echo "procs_memory_usage{pid=\"$pid\",user=\"$user\",command=\"$command\"} $memory"
        done
    } > "$metrics_file"
    
    echo "Metrics exported to: $metrics_file"
}

# JSON output for monitoring tools
json_export() {
    local output_file="/tmp/procs_export_$(date +%Y%m%d_%H%M%S).json"
    
    {
        echo "{"
        echo "  \"timestamp\": \"$(date -Iseconds)\","
        echo "  \"processes\": ["
        
        local first=true
        procs --no-header --insert Pid,PPid,User,State,UsageCpu,UsageMemory,Command | while read -r pid ppid user state cpu memory command; do
            if [[ "$first" == "true" ]]; then
                first=false
            else
                echo "    ,"
            fi
            
            echo "    {"
            echo "      \"pid\": $pid,"
            echo "      \"ppid\": $ppid,"
            echo "      \"user\": \"$user\","
            echo "      \"state\": \"$state\","
            echo "      \"cpu_usage\": $cpu,"
            echo "      \"memory_usage\": $memory,"
            echo "      \"command\": \"$command\""
            echo "    }"
        done
        
        echo "  ]"
        echo "}"
    } > "$output_file"
    
    echo "JSON export saved to: $output_file"
}
```

## Troubleshooting

### Common Issues

**Issue**: Colors not displaying properly
```bash
# Solution: Check terminal color support
echo $TERM
export TERM=xterm-256color

# Solution: Force color mode
procs --color always

# Solution: Disable colors if needed
procs --color never
```

**Issue**: Too much output on small terminals
```bash
# Solution: Use pager
procs | less

# Solution: Limit columns
procs --insert Pid,User,Command

# Solution: Filter output
procs firefox
```

**Issue**: Performance with many processes
```bash
# Solution: Filter early
procs --user $(whoami)

# Solution: Use specific patterns
procs systemd

# Solution: Limit output
procs | head -20
```

### Performance Tips
```bash
# Use specific filters to reduce output
procs --user username

# Use tree view for better organization
procs --tree

# Combine with other tools efficiently
procs firefox | head -10

# Use configuration file for consistent settings
# Edit ~/.config/procs/config.toml
```

## Comparison with Alternatives

### Procs vs ps
```bash
# Traditional ps
ps aux | grep firefox

# Modern procs
procs firefox

# Procs advantages:
# - Colored output
# - Better filtering
# - Tree view
# - More readable format
```

### Procs vs htop
```bash
# htop (interactive)
htop

# procs (command-line focused)
procs --tree --sortd cpu

# Different use cases:
# - htop: Interactive monitoring
# - procs: Command-line scripting and one-time views
```

## Resources and References

- [Procs GitHub Repository](https://github.com/dalance/procs)
- [Procs Documentation](https://github.com/dalance/procs/blob/master/README.md)
- [Configuration Reference](https://github.com/dalance/procs/blob/master/CONFIGURATION.md)
- [Rust CLI Tools](https://github.com/rust-cli/awesome-rust-cli)

This guide provides comprehensive coverage of procs installation, configuration, and usage patterns for modern process monitoring and management.