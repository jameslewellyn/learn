# Watchexec - File Watcher and Command Runner Installation and Setup Guide

## Overview

**Watchexec** is a simple, standalone tool that watches a path and runs a command whenever it detects modifications. It's designed to be fast, efficient, and easy to use for automating development workflows, testing, and build processes.

### Key Features
- **Fast file watching**: Efficient filesystem monitoring
- **Cross-platform**: Works on Linux, macOS, and Windows
- **Flexible filtering**: Include/exclude patterns for files and directories
- **Signal handling**: Proper process management and cleanup
- **Restart behavior**: Configurable restart policies
- **Shell integration**: Works with any shell command

### Why Use Watchexec?
- Simpler than complex build systems for basic file watching
- More reliable than shell-based file monitoring
- Better performance than polling-based solutions
- Excellent for development workflows and automation
- Lightweight and focused on doing one thing well
- Great for continuous testing and building

## Installation

### Prerequisites
- Any Unix-like system
- Commands you want to run automatically

### Via Mise (Recommended)
```bash
# Install watchexec via mise
mise use -g watchexec

# Verify installation
watchexec --version
```

### Manual Installation
```bash
# Install via cargo
cargo install watchexec-cli

# Or download binary release
curl -L https://github.com/watchexec/watchexec/releases/latest/download/watchexec-1.22.3-x86_64-unknown-linux-musl.tar.xz | tar xJ
sudo mv watchexec /usr/local/bin/
```

### Verify Installation
```bash
# Test basic functionality
watchexec --help

# Simple test (Ctrl+C to exit)
watchexec echo "File changed"
```

## Configuration

### Shell Integration
```bash
# Add to ~/.bashrc or ~/.zshrc
alias watch='watchexec'
alias autorun='watchexec --restart'
alias watchtest='watchexec --clear --restart'

# Function for common development workflows
autotest() {
    local test_command="${1:-npm test}"
    watchexec --clear --restart --ignore "**/node_modules/**" "$test_command"
}

# Function for auto-building
autobuild() {
    local build_command="${1:-make}"
    watchexec --clear --restart --ignore "**/build/**" "$build_command"
}
```

### Configuration File
```bash
# Create watchexec config directory
mkdir -p ~/.config/watchexec

# Create configuration file
cat > ~/.config/watchexec/config.toml << 'EOF'
# Watchexec configuration
[default]
command = "echo 'File changed'"
restart = true
clear = true
ignore = [
    "**/.git/**",
    "**/node_modules/**",
    "**/target/**",
    "**/.DS_Store",
    "**/*.swp",
    "**/*.tmp"
]
EOF
```

## Basic Usage

### Simple File Watching
```bash
# Watch current directory and run command
watchexec echo "Files changed"

# Watch specific directory
watchexec --watch /path/to/directory echo "Directory changed"

# Watch multiple directories
watchexec --watch src --watch tests echo "Source or tests changed"
```

### Restart Behavior
```bash
# Restart command on each change (kill previous execution)
watchexec --restart make build

# Don't restart, let command complete
watchexec make build

# Clear screen before running
watchexec --clear --restart npm test
```

### File Filtering
```bash
# Watch only specific file types
watchexec --exts js,ts,jsx,tsx npm test

# Ignore specific patterns
watchexec --ignore "*.tmp" --ignore "node_modules" make build

# Use gitignore patterns
watchexec --ignore-file .gitignore make build
```

## Advanced Usage

### Development Workflows
```bash
# Auto-testing with coverage
watchexec --clear --restart --exts py \
    "python -m pytest --cov=src tests/"

# Auto-building and running
watchexec --clear --restart --exts go \
    "go build -o app && ./app"

# Web development with live reload
watchexec --clear --restart --exts html,css,js \
    "python -m http.server 8000"

# Auto-formatting code
watchexec --exts py "black src/ tests/"
```

### Build System Integration
```bash
# Auto-compilation
watchexec --clear --restart --exts rs \
    "cargo build"

# Auto-testing with specific test runner
watchexec --clear --restart --exts rs \
    "cargo test -- --nocapture"

# Auto-documentation generation
watchexec --exts md "mkdocs build"

# Auto-linting
watchexec --exts py "flake8 src/ tests/"
```

### Complex Filtering
```bash
# Watch multiple file types, ignore build artifacts
watchexec \
    --exts py,js,html,css \
    --ignore "**/__pycache__/**" \
    --ignore "**/node_modules/**" \
    --ignore "**/build/**" \
    "make build"

# Use complex ignore patterns
watchexec \
    --ignore "*.log" \
    --ignore "*.tmp" \
    --ignore "**/.*" \
    --ignore "**/target/**" \
    "cargo check"

# Watch only specific directories
watchexec \
    --watch src \
    --watch tests \
    --ignore "**/*.pyc" \
    "python -m pytest"
```

### Signal Handling
```bash
# Send specific signal to process
watchexec --signal SIGTERM long_running_command

# Kill process group
watchexec --kill-group make serve

# Custom signal handling
watchexec --signal SIGUSR1 custom_daemon
```

### Scripting and Automation
```bash
#!/bin/bash
# Development automation script

# Auto-test runner
auto_test() {
    local project_dir="$1"
    local test_command="$2"
    
    cd "$project_dir" || exit 1
    
    echo "Starting auto-test for $project_dir"
    watchexec \
        --clear \
        --restart \
        --ignore "**/node_modules/**" \
        --ignore "**/.git/**" \
        --ignore "**/coverage/**" \
        "$test_command"
}

# Auto-deployment
auto_deploy() {
    local source_dir="$1"
    local deploy_command="$2"
    
    echo "Starting auto-deployment for $source_dir"
    watchexec \
        --watch "$source_dir" \
        --restart \
        --ignore "**/*.log" \
        --ignore "**/tmp/**" \
        "$deploy_command"
}

# Multi-command execution
multi_watch() {
    local commands=("$@")
    
    for cmd in "${commands[@]}"; do
        echo "Running: $cmd"
        watchexec --restart "$cmd" &
    done
    
    wait
}
```

### CI/CD Integration
```bash
# Continuous integration simulation
simulate_ci() {
    local project_dir="$1"
    
    echo "Simulating CI pipeline for $project_dir"
    
    # Run tests on changes
    watchexec \
        --clear \
        --restart \
        --ignore "**/node_modules/**" \
        --ignore "**/.git/**" \
        "npm run lint && npm test && npm run build"
}

# Development server with auto-restart
dev_server() {
    local server_command="$1"
    local port="${2:-8000}"
    
    echo "Starting development server on port $port"
    
    # Kill any existing process on port
    fuser -k "$port/tcp" 2>/dev/null || true
    
    # Start server with auto-restart
    watchexec \
        --clear \
        --restart \
        --ignore "**/node_modules/**" \
        --ignore "**/.git/**" \
        --ignore "**/logs/**" \
        "$server_command"
}
```

### Performance Optimization
```bash
# Optimize for large projects
watch_large_project() {
    local project_dir="$1"
    local command="$2"
    
    # Use specific patterns to reduce file watching overhead
    watchexec \
        --watch "$project_dir/src" \
        --watch "$project_dir/tests" \
        --exts py,js,ts,jsx,tsx \
        --ignore "**/__pycache__/**" \
        --ignore "**/node_modules/**" \
        --ignore "**/.git/**" \
        --ignore "**/build/**" \
        --ignore "**/dist/**" \
        --debounce 300 \
        "$command"
}

# Debounce for rapid file changes
debounced_watch() {
    local delay="${1:-500}"
    local command="$2"
    
    watchexec \
        --debounce "$delay" \
        --restart \
        "$command"
}
```

### Docker Integration
```bash
# Watch and rebuild Docker images
docker_watch() {
    local dockerfile_path="$1"
    local image_name="$2"
    
    echo "Watching for Docker image changes: $image_name"
    
    watchexec \
        --watch "$dockerfile_path" \
        --exts dockerfile,py,js,go,rs \
        --ignore "**/.git/**" \
        --restart \
        "docker build -t $image_name ."
}

# Auto-restart Docker containers
container_watch() {
    local container_name="$1"
    local source_dir="$2"
    
    echo "Watching for container restart: $container_name"
    
    watchexec \
        --watch "$source_dir" \
        --restart \
        --ignore "**/node_modules/**" \
        "docker restart $container_name"
}
```

### Database Development
```bash
# Auto-migrate database
db_watch() {
    local migration_dir="$1"
    local migrate_command="$2"
    
    echo "Watching for database migrations"
    
    watchexec \
        --watch "$migration_dir" \
        --exts sql \
        --restart \
        "$migrate_command"
}

# Auto-seed database
db_seed_watch() {
    local seed_dir="$1"
    local seed_command="$2"
    
    watchexec \
        --watch "$seed_dir" \
        --exts sql,py,js \
        --restart \
        "$seed_command"
}
```

## Integration Examples

### With Modern Web Development
```bash
# React development
react_watch() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    # Start development server with auto-reload
    watchexec \
        --clear \
        --restart \
        --exts js,jsx,ts,tsx,css,scss \
        --ignore "**/node_modules/**" \
        --ignore "**/build/**" \
        "npm start"
}

# Vue.js development
vue_watch() {
    local project_dir="$1"
    
    cd "$project_dir" || exit 1
    
    watchexec \
        --clear \
        --restart \
        --exts vue,js,ts,css,scss \
        --ignore "**/node_modules/**" \
        --ignore "**/dist/**" \
        "npm run dev"
}
```

### With Backend Development
```bash
# Python Flask development
flask_watch() {
    local app_file="$1"
    
    echo "Starting Flask development server"
    
    watchexec \
        --clear \
        --restart \
        --exts py \
        --ignore "**/__pycache__/**" \
        --ignore "**/venv/**" \
        "python $app_file"
}

# Node.js Express development
express_watch() {
    local app_file="$1"
    
    echo "Starting Express development server"
    
    watchexec \
        --clear \
        --restart \
        --exts js,ts,json \
        --ignore "**/node_modules/**" \
        "node $app_file"
}
```

### With System Administration
```bash
# Configuration file monitoring
config_watch() {
    local config_file="$1"
    local reload_command="$2"
    
    echo "Monitoring configuration file: $config_file"
    
    watchexec \
        --watch "$config_file" \
        --restart \
        "$reload_command"
}

# Log file monitoring
log_watch() {
    local log_file="$1"
    local alert_command="$2"
    
    echo "Monitoring log file: $log_file"
    
    watchexec \
        --watch "$log_file" \
        --ignore-file /dev/null \
        "$alert_command"
}
```

## Troubleshooting

### Common Issues

**Issue**: Too many file system events
```bash
# Solution: Use more specific patterns
watchexec --exts py,js --ignore "**/node_modules/**" command

# Solution: Increase debounce time
watchexec --debounce 1000 command

# Solution: Watch specific directories only
watchexec --watch src --watch tests command
```

**Issue**: Process not restarting properly
```bash
# Solution: Use --restart flag
watchexec --restart command

# Solution: Use signal handling
watchexec --signal SIGTERM --restart command

# Solution: Kill process group
watchexec --kill-group --restart command
```

**Issue**: Ignored files still triggering
```bash
# Solution: Check ignore patterns
watchexec --ignore "**/*.tmp" --ignore "node_modules" command

# Solution: Use .gitignore file
watchexec --ignore-file .gitignore command

# Solution: Be more specific with extensions
watchexec --exts py,js,ts command
```

### Performance Tips
```bash
# Optimize file watching
watchexec --exts py,js --ignore "**/.*" --ignore "**/__pycache__/**" command

# Use debouncing for rapid changes
watchexec --debounce 500 command

# Watch specific directories only
watchexec --watch src --watch tests command

# Use .gitignore for better performance
watchexec --ignore-file .gitignore command
```

### Best Practices
```bash
# Always use --restart for long-running processes
watchexec --restart --clear server_command

# Use appropriate file extensions
watchexec --exts py,js,ts,jsx,tsx test_command

# Ignore common build artifacts
watchexec --ignore "**/__pycache__/**" --ignore "**/node_modules/**" command

# Use clear screen for better visibility
watchexec --clear --restart command
```

## Comparison with Alternatives

### Watchexec vs entr
```bash
# entr (traditional)
find . -name "*.py" | entr python -m pytest

# watchexec (modern)
watchexec --exts py "python -m pytest"

# Watchexec advantages:
# - Better cross-platform support
# - More flexible filtering
# - Better process management
```

### Watchexec vs nodemon
```bash
# nodemon (Node.js specific)
nodemon --watch src --ext js,ts server.js

# watchexec (universal)
watchexec --watch src --exts js,ts "node server.js"

# Watchexec advantages:
# - Works with any language
# - More filtering options
# - Better signal handling
```

## Resources and References

- [Watchexec GitHub Repository](https://github.com/watchexec/watchexec)
- [Watchexec Documentation](https://watchexec.github.io/)
- [Configuration Guide](https://watchexec.github.io/docs/configuration.html)
- [Rust CLI Tools](https://github.com/rust-cli/awesome-rust-cli)

This guide provides comprehensive coverage of watchexec installation, configuration, and usage patterns for automating development workflows and file monitoring tasks.