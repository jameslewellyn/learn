# Cargo Bacon - Rust Code Watcher and Auto-Tester Installation and Setup Guide

## Overview

**Cargo Bacon** is a background rust code checker and test runner that provides continuous feedback as you write code. It watches your Rust project for changes and automatically runs cargo commands like `check`, `test`, `clippy`, and `build` to give you instant feedback on your code quality and correctness.

### Key Features
- **Automatic watching**: Monitors file changes and runs cargo commands
- **Fast feedback**: Instant compilation and test results
- **Customizable commands**: Configure what commands to run
- **Terminal UI**: Clean, informative terminal interface
- **Error highlighting**: Clear display of errors and warnings
- **Multiple modes**: Support for different development workflows

### Why Use Cargo Bacon?
- Faster development cycle with instant feedback
- Catches errors as you write code
- Reduces context switching between editor and terminal
- Customizable to fit your workflow
- Lightweight and efficient
- Great for Test-Driven Development (TDD)

## Installation

### Prerequisites
- Rust toolchain (rustc 1.56+)
- Cargo package manager
- Active Rust project

### Via Mise (Recommended)
```bash
# Install cargo-bacon via mise
mise use -g cargo:bacon

# Verify installation
bacon --version
```

### Manual Installation
```bash
# Install via cargo
cargo install --locked bacon

# Or install from GitHub
cargo install --git https://github.com/Canop/bacon bacon
```

### Verify Installation
```bash
# Check installation
bacon --version

# Test in a Rust project
cd my_rust_project
bacon

# Show help
bacon --help
```

## Configuration

### Basic Configuration
```bash
# Create bacon configuration in your project
mkdir -p .bacon

# Create basic configuration
cat > .bacon/bacon.toml << 'EOF'
# Bacon configuration

[default]
# The default command to run
command = "check"

# Whether to clear the terminal before each run
clear_terminal = true

# Whether to run on startup
run_on_startup = true

# Additional arguments to pass to cargo
args = ["--workspace", "--all-features"]

# Files to watch (defaults to src/ and Cargo.toml)
paths = ["src", "Cargo.toml", "Cargo.lock"]

# Files to ignore
ignore = ["target/", "*.tmp", "*.bak"]

[jobs.check]
command = "check"
description = "cargo check"
args = ["--workspace", "--all-features"]

[jobs.test]
command = "test"
description = "cargo test"
args = ["--workspace"]

[jobs.clippy]
command = "clippy"
description = "cargo clippy"
args = ["--workspace", "--all-features", "--", "-D", "warnings"]

[jobs.build]
command = "build"
description = "cargo build"
args = ["--workspace"]

[jobs.doc]
command = "doc"
description = "cargo doc"
args = ["--workspace", "--no-deps"]
EOF
```

### Advanced Configuration
```bash
# Advanced bacon configuration
cat > .bacon/bacon.toml << 'EOF'
# Advanced Bacon configuration

[default]
command = "check"
clear_terminal = true
run_on_startup = true
args = ["--workspace", "--all-features"]

# Custom paths to watch
paths = [
    "src",
    "examples",
    "tests",
    "benches",
    "build.rs",
    "Cargo.toml",
    "Cargo.lock",
    "rust-toolchain.toml"
]

# Files and directories to ignore
ignore = [
    "target/",
    ".git/",
    "*.tmp",
    "*.bak",
    ".DS_Store",
    "*.swp",
    "*.swo"
]

# Development jobs
[jobs.check]
command = "check"
description = "Quick check"
args = ["--workspace", "--all-features"]
clear_terminal = true

[jobs.test]
command = "test"
description = "Run tests"
args = ["--workspace"]
clear_terminal = true

[jobs.test-watch]
command = "test"
description = "Watch tests"
args = ["--workspace", "--", "--nocapture"]
clear_terminal = true

[jobs.clippy]
command = "clippy"
description = "Clippy lints"
args = ["--workspace", "--all-features", "--", "-D", "warnings"]
clear_terminal = true

[jobs.clippy-fix]
command = "clippy"
description = "Clippy auto-fix"
args = ["--workspace", "--all-features", "--fix", "--allow-dirty"]
clear_terminal = true

[jobs.build]
command = "build"
description = "Build project"
args = ["--workspace"]
clear_terminal = true

[jobs.build-release]
command = "build"
description = "Release build"
args = ["--workspace", "--release"]
clear_terminal = true

[jobs.doc]
command = "doc"
description = "Generate docs"
args = ["--workspace", "--no-deps", "--open"]
clear_terminal = true

[jobs.bench]
command = "bench"
description = "Run benchmarks"
args = ["--workspace"]
clear_terminal = true

[jobs.expand]
command = "expand"
description = "Macro expansion"
args = ["--ugly"]
clear_terminal = true

# Custom commands
[jobs.format]
command = "fmt"
description = "Format code"
args = ["--all", "--", "--check"]
clear_terminal = true

[jobs.audit]
command = "audit"
description = "Security audit"
args = []
clear_terminal = true

# Integration with other tools
[jobs.tarpaulin]
command = "tarpaulin"
description = "Code coverage"
args = ["--workspace", "--out", "Html"]
clear_terminal = true
EOF
```

### Shell Integration
```bash
# Add to ~/.bashrc or ~/.zshrc
alias b='bacon'
alias bt='bacon test'
alias bc='bacon check'
alias bl='bacon clippy'
alias bb='bacon build'

# Useful functions
bacon_job() {
    local job="${1:-check}"
    echo "Running bacon job: $job"
    bacon "$job"
}

bacon_watch() {
    local command="$1"
    shift
    echo "Watching with bacon: $command $*"
    bacon "$command" -- "$@"
}

# Function to set up bacon in new projects
bacon_init() {
    local project_type="${1:-default}"
    
    echo "Initializing bacon for $project_type project"
    
    mkdir -p .bacon
    
    case "$project_type" in
        "lib")
            cat > .bacon/bacon.toml << 'EOF'
[default]
command = "check"
args = ["--lib", "--all-features"]

[jobs.check]
command = "check"
description = "Library check"
args = ["--lib", "--all-features"]

[jobs.test]
command = "test"
description = "Library tests"
args = ["--lib"]

[jobs.doc]
command = "doc"
description = "Library docs"
args = ["--lib", "--no-deps"]
EOF
            ;;
        "bin")
            cat > .bacon/bacon.toml << 'EOF'
[default]
command = "check"
args = ["--bin", "main"]

[jobs.check]
command = "check"
description = "Binary check"
args = ["--bin", "main"]

[jobs.run]
command = "run"
description = "Run binary"
args = ["--bin", "main"]
EOF
            ;;
        "workspace")
            cat > .bacon/bacon.toml << 'EOF'
[default]
command = "check"
args = ["--workspace", "--all-features"]

[jobs.check]
command = "check"
description = "Workspace check"
args = ["--workspace", "--all-features"]

[jobs.test]
command = "test"
description = "Workspace tests"
args = ["--workspace"]

[jobs.build]
command = "build"
description = "Workspace build"
args = ["--workspace"]
EOF
            ;;
        *)
            echo "Using default configuration"
            ;;
    esac
    
    echo "Bacon configuration created in .bacon/bacon.toml"
}

# Function to run bacon with specific test
bacon_test() {
    local test_name="$1"
    if [[ -n "$test_name" ]]; then
        bacon test -- "$test_name"
    else
        bacon test
    fi
}
```

## Basic Usage

### Starting Bacon
```bash
# Start bacon with default job (usually check)
bacon

# Start with specific job
bacon test
bacon clippy
bacon build

# Start with custom arguments
bacon check -- --all-features
bacon test -- --nocapture
```

### Interactive Commands
```bash
# While bacon is running, you can use these keys:
# 'c' - Switch to check mode
# 't' - Switch to test mode
# 'b' - Switch to build mode
# 'l' - Switch to clippy mode
# 'r' - Restart current job
# 'q' - Quit bacon
# 'h' - Show help
```

### Common Workflows
```bash
# Development workflow
bacon check    # Quick syntax and type checking

# Testing workflow
bacon test     # Run tests continuously

# Quality workflow
bacon clippy   # Continuous linting

# Documentation workflow
bacon doc      # Keep docs updated
```

## Advanced Usage

### Custom Jobs
```bash
# Create custom job configurations
cat > .bacon/bacon.toml << 'EOF'
[jobs.integration]
command = "test"
description = "Integration tests only"
args = ["--test", "*integration*"]

[jobs.unit]
command = "test"
description = "Unit tests only"
args = ["--lib"]

[jobs.examples]
command = "check"
description = "Check examples"
args = ["--examples"]

[jobs.bench]
command = "bench"
description = "Run benchmarks"
args = ["--bench", "*"]

[jobs.miri]
command = "miri"
description = "Run with Miri"
args = ["test"]
EOF

# Run custom jobs
bacon integration
bacon unit
bacon examples
```

### Project-Specific Workflows
```bash
# Web development workflow
web_dev_bacon() {
    cat > .bacon/bacon.toml << 'EOF'
[default]
command = "check"

[jobs.check]
command = "check"
description = "Check web project"
args = ["--all-features"]

[jobs.test]
command = "test"
description = "Web tests"
args = ["--all-features"]

[jobs.wasm]
command = "build"
description = "Build for WASM"
args = ["--target", "wasm32-unknown-unknown"]

[jobs.server]
command = "run"
description = "Run server"
args = ["--bin", "server"]
EOF
}

# CLI tool workflow
cli_dev_bacon() {
    cat > .bacon/bacon.toml << 'EOF'
[default]
command = "check"

[jobs.check]
command = "check"
description = "Check CLI tool"
args = ["--all-features"]

[jobs.test]
command = "test"
description = "CLI tests"
args = ["--all-features"]

[jobs.install]
command = "install"
description = "Install locally"
args = ["--path", ".", "--force"]

[jobs.release]
command = "build"
description = "Release build"
args = ["--release"]
EOF
}

# Library workflow
lib_dev_bacon() {
    cat > .bacon/bacon.toml << 'EOF'
[default]
command = "check"

[jobs.check]
command = "check"
description = "Check library"
args = ["--lib", "--all-features"]

[jobs.test]
command = "test"
description = "Library tests"
args = ["--lib"]

[jobs.doc]
command = "doc"
description = "Generate docs"
args = ["--lib", "--no-deps"]

[jobs.publish-check]
command = "publish"
description = "Check publish"
args = ["--dry-run"]
EOF
}
```

### Integration with Testing Frameworks
```bash
# Integration with criterion benchmarks
criterion_bacon() {
    cat > .bacon/bacon.toml << 'EOF'
[jobs.bench]
command = "bench"
description = "Criterion benchmarks"
args = ["--bench", "*"]

[jobs.bench-baseline]
command = "bench"
description = "Baseline benchmarks"
args = ["--bench", "*", "--", "--save-baseline", "main"]

[jobs.bench-compare]
command = "bench"
description = "Compare benchmarks"
args = ["--bench", "*", "--", "--baseline", "main"]
EOF
}

# Integration with proptest
proptest_bacon() {
    cat > .bacon/bacon.toml << 'EOF'
[jobs.proptest]
command = "test"
description = "Property tests"
args = ["--", "--nocapture"]

[jobs.proptest-verbose]
command = "test"
description = "Verbose property tests"
args = ["--", "--nocapture", "--test-threads", "1"]
EOF
}

# Integration with cargo-watch for specific files
watch_specific() {
    local file="$1"
    local job="${2:-check}"
    
    echo "Watching $file for $job"
    
    cat > .bacon/bacon.toml << EOF
[default]
command = "$job"
paths = ["$file"]

[jobs.$job]
command = "$job"
description = "Watch $file"
args = ["--all-features"]
EOF
    
    bacon "$job"
}
```

### Continuous Integration Integration
```bash
# CI-friendly bacon configuration
ci_bacon() {
    cat > .bacon/bacon.toml << 'EOF'
[default]
command = "check"
clear_terminal = false
run_on_startup = true

[jobs.ci-check]
command = "check"
description = "CI check"
args = ["--workspace", "--all-features", "--locked"]
clear_terminal = false

[jobs.ci-test]
command = "test"
description = "CI test"
args = ["--workspace", "--locked"]
clear_terminal = false

[jobs.ci-clippy]
command = "clippy"
description = "CI clippy"
args = ["--workspace", "--all-features", "--locked", "--", "-D", "warnings"]
clear_terminal = false

[jobs.ci-format]
command = "fmt"
description = "CI format check"
args = ["--all", "--", "--check"]
clear_terminal = false
EOF
}

# GitHub Actions integration
github_actions_bacon() {
    cat > .github/workflows/bacon.yml << 'EOF'
name: Bacon CI

on: [push, pull_request]

jobs:
  bacon:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Install Rust
      uses: actions-rs/toolchain@v1
      with:
        toolchain: stable
        override: true
        components: rustfmt, clippy
    
    - name: Install Bacon
      run: cargo install --locked bacon
    
    - name: Run Bacon Check
      run: bacon ci-check --no-tty
    
    - name: Run Bacon Test
      run: bacon ci-test --no-tty
    
    - name: Run Bacon Clippy
      run: bacon ci-clippy --no-tty
    
    - name: Run Bacon Format
      run: bacon ci-format --no-tty
EOF
}
```

### Performance Optimization
```bash
# Optimize bacon for large projects
optimize_bacon() {
    cat > .bacon/bacon.toml << 'EOF'
[default]
command = "check"
clear_terminal = true
run_on_startup = false

# Optimize file watching
paths = [
    "src",
    "Cargo.toml"
]

ignore = [
    "target/",
    ".git/",
    "*.tmp",
    "*.bak",
    ".DS_Store",
    "*.swp",
    "*.swo",
    "*.log",
    "coverage/",
    "docs/",
    "examples/"
]

[jobs.fast-check]
command = "check"
description = "Fast check"
args = ["--lib"]
clear_terminal = true

[jobs.incremental]
command = "check"
description = "Incremental check"
args = ["--workspace", "--all-features"]
clear_terminal = false
EOF
}

# Memory-efficient configuration
memory_efficient_bacon() {
    cat > .bacon/bacon.toml << 'EOF'
[default]
command = "check"
clear_terminal = true

# Reduce memory usage
[jobs.check-single]
command = "check"
description = "Single-threaded check"
args = ["--jobs", "1"]

[jobs.test-single]
command = "test"
description = "Single-threaded test"
args = ["--jobs", "1"]
EOF
}
```

### Debugging and Troubleshooting
```bash
# Debug bacon configuration
debug_bacon() {
    echo "=== Bacon Configuration Debug ==="
    
    # Check if bacon.toml exists
    if [[ -f ".bacon/bacon.toml" ]]; then
        echo "✓ Found bacon configuration"
        echo "Configuration:"
        cat .bacon/bacon.toml
    else
        echo "✗ No bacon configuration found"
        echo "Creating default configuration..."
        bacon_init
    fi
    
    # Check file permissions
    echo -e "\n=== File Permissions ==="
    ls -la .bacon/ 2>/dev/null || echo "No .bacon directory"
    
    # Check cargo project
    echo -e "\n=== Cargo Project Check ==="
    if [[ -f "Cargo.toml" ]]; then
        echo "✓ Found Cargo.toml"
        cargo check --quiet && echo "✓ Project compiles" || echo "✗ Project has errors"
    else
        echo "✗ No Cargo.toml found"
    fi
    
    # Check bacon version
    echo -e "\n=== Bacon Version ==="
    bacon --version
}

# Troubleshoot bacon issues
troubleshoot_bacon() {
    echo "=== Bacon Troubleshooting ==="
    
    # Check if bacon is running
    if pgrep -f "bacon" > /dev/null; then
        echo "✓ Bacon is running"
        echo "Bacon processes:"
        ps aux | grep bacon | grep -v grep
    else
        echo "✗ Bacon is not running"
    fi
    
    # Check file watching
    echo -e "\n=== File Watch Status ==="
    if command -v inotifywait >/dev/null; then
        echo "✓ inotify tools available"
    else
        echo "✗ inotify tools not available"
        echo "Install with: sudo apt install inotify-tools"
    fi
    
    # Check system limits
    echo -e "\n=== System Limits ==="
    echo "Max file watches: $(cat /proc/sys/fs/inotify/max_user_watches)"
    echo "Current watches: $(find /proc/*/fd -lname anon_inode:inotify 2>/dev/null | wc -l)"
    
    # Check bacon logs
    echo -e "\n=== Recent Bacon Activity ==="
    journalctl --user -u bacon -n 10 --no-pager 2>/dev/null || echo "No systemd logs found"
}
```

## Integration Examples

### With IDE Integration
```bash
# VS Code integration
vscode_bacon() {
    mkdir -p .vscode
    
    cat > .vscode/tasks.json << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "bacon-check",
            "type": "shell",
            "command": "bacon",
            "args": ["check"],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            },
            "isBackground": true
        },
        {
            "label": "bacon-test",
            "type": "shell",
            "command": "bacon",
            "args": ["test"],
            "group": "test",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            },
            "isBackground": true
        }
    ]
}
EOF

    cat > .vscode/launch.json << 'EOF'
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Bacon Debug",
            "type": "lldb",
            "request": "launch",
            "program": "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
            "args": [],
            "cwd": "${workspaceFolder}",
            "preLaunchTask": "bacon-check"
        }
    ]
}
EOF
}

# Vim/Neovim integration
vim_bacon() {
    cat > .vimrc.bacon << 'EOF'
" Bacon integration for Vim
function! BaconStart()
    :term bacon check
endfunction

function! BaconTest()
    :term bacon test
endfunction

function! BaconClippy()
    :term bacon clippy
endfunction

" Key mappings
nnoremap <leader>bc :call BaconStart()<CR>
nnoremap <leader>bt :call BaconTest()<CR>
nnoremap <leader>bl :call BaconClippy()<CR>
EOF
}
```

### With Git Hooks
```bash
# Pre-commit hook with bacon
pre_commit_bacon() {
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
set -e

echo "Running bacon checks before commit..."

# Run bacon check
bacon check --no-tty --job ci-check

# Run bacon test
bacon test --no-tty --job ci-test

# Run bacon clippy
bacon clippy --no-tty --job ci-clippy

# Run bacon format check
bacon fmt --no-tty --job ci-format

echo "All bacon checks passed!"
EOF
    
    chmod +x .git/hooks/pre-commit
}

# Pre-push hook with bacon
pre_push_bacon() {
    cat > .git/hooks/pre-push << 'EOF'
#!/bin/bash
set -e

echo "Running full bacon suite before push..."

# Run comprehensive checks
bacon check --no-tty --job ci-check
bacon test --no-tty --job ci-test
bacon clippy --no-tty --job ci-clippy
bacon doc --no-tty --job ci-doc

echo "All bacon checks passed for push!"
EOF
    
    chmod +x .git/hooks/pre-push
}
```

### With Docker
```bash
# Docker integration for bacon
docker_bacon() {
    cat > Dockerfile.bacon << 'EOF'
FROM rust:latest

WORKDIR /app

# Install bacon
RUN cargo install --locked bacon

# Copy project
COPY . .

# Run bacon
CMD ["bacon", "check"]
EOF

    cat > docker-compose.bacon.yml << 'EOF'
version: '3.8'

services:
  bacon:
    build:
      context: .
      dockerfile: Dockerfile.bacon
    volumes:
      - .:/app
      - cargo-cache:/usr/local/cargo/registry
    command: bacon check
    stdin_open: true
    tty: true

volumes:
  cargo-cache:
EOF
}
```

## Troubleshooting

### Common Issues

**Issue**: Bacon not detecting file changes
```bash
# Solution: Check inotify limits
echo 'fs.inotify.max_user_watches=524288' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Solution: Check file permissions
ls -la .bacon/
chmod 644 .bacon/bacon.toml

# Solution: Restart bacon
pkill bacon
bacon check
```

**Issue**: Bacon consuming too much CPU
```bash
# Solution: Optimize configuration
cat > .bacon/bacon.toml << 'EOF'
[default]
command = "check"
clear_terminal = false

[jobs.check]
command = "check"
args = ["--jobs", "1"]
EOF

# Solution: Reduce file watching scope
# Edit .bacon/bacon.toml to limit paths
```

**Issue**: Bacon not showing errors properly
```bash
# Solution: Check terminal capabilities
echo $TERM
export TERM=xterm-256color

# Solution: Use different output format
bacon check --no-tty

# Solution: Check bacon version
bacon --version
cargo install --locked bacon --force
```

### Performance Tips
```bash
# Optimize for large projects
[default]
command = "check"
clear_terminal = false
paths = ["src", "Cargo.toml"]

# Use incremental compilation
export CARGO_INCREMENTAL=1

# Limit parallel jobs
[jobs.check]
args = ["--jobs", "2"]

# Use faster linker
export RUSTFLAGS="-C link-arg=-fuse-ld=lld"
```

## Comparison with Alternatives

### Bacon vs cargo-watch
```bash
# cargo-watch
cargo watch -x check

# bacon (better)
bacon check

# Bacon advantages:
# - Better terminal UI
# - More configuration options
# - Job switching
# - Better error display
```

### Bacon vs entr
```bash
# entr
find src -name "*.rs" | entr cargo check

# bacon (better)
bacon check

# Bacon advantages:
# - Rust-specific
# - Better integration
# - More features
# - Easier configuration
```

## Resources and References

- [Bacon GitHub Repository](https://github.com/Canop/bacon)
- [Bacon Documentation](https://dystroy.org/bacon/)
- [Cargo Documentation](https://doc.rust-lang.org/cargo/)
- [Rust Development Tools](https://forge.rust-lang.org/infra/channel-layout.html)

This guide provides comprehensive coverage of cargo bacon installation, configuration, and usage patterns for efficient Rust development with continuous feedback.