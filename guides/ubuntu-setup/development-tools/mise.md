# Mise - Development Environment Manager Installation and Setup Guide

A unified tool for managing runtime versions, environment variables, and project tasks.

## What is Mise?

**Mise** (pronounced "meez") is a development environment manager that combines the functionality of several tools:
- **Runtime version management** (like asdf, nvm, pyenv)
- **Environment variable management** (like direnv)
- **Task running** (like make, just)
- **Plugin system** for extensibility

Named after the French culinary term "mise en place" (having everything in its place), mise helps you set up consistent development environments across projects and teams.

## Key Features

- **Multi-language support**: Node.js, Python, Ruby, Go, Java, Rust, and 400+ more
- **Environment variables**: Per-project and global environment management
- **Task runner**: Define and run project-specific tasks
- **Plugin system**: Extensible with custom plugins
- **Fast performance**: Written in Rust for speed
- **Configuration formats**: Support for `.tool-versions`, `.mise.toml`, and legacy formats
- **Shell integration**: Works with bash, zsh, fish
- **CI/CD friendly**: Easy integration with automated workflows

## Installation

### Method 1: Installation Script (Recommended)
```bash
curl https://mise.run | sh
```

### Method 2: APT Repository
```bash
# Add mise repository
sudo install -dm 755 /etc/apt/keyrings
wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1> /dev/null
echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=amd64] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list

# Install mise
sudo apt update
sudo apt install mise
```

### Method 3: Manual Binary Installation
```bash
# Download latest release
curl -LO "https://github.com/jdx/mise/releases/latest/download/mise-v2024.1.0-linux-x64.tar.gz"
tar -xzf mise-v2024.1.0-linux-x64.tar.gz
sudo mv mise /usr/local/bin/
rm mise-v2024.1.0-linux-x64.tar.gz
```

### Method 4: Cargo Installation
```bash
cargo install mise
```

## Basic Setup

### Shell Integration

#### Bash
Add to `~/.bashrc`:
```bash
eval "$(~/.local/bin/mise activate bash)"
```

#### Zsh
Add to `~/.zshrc`:
```bash
eval "$(~/.local/bin/mise activate zsh)"
```

#### Fish
Add to `~/.config/fish/config.fish`:
```bash
~/.local/bin/mise activate fish | source
```

### Verification
```bash
# Check installation
mise --version

# Check shell integration
mise doctor
```

## Basic Usage

### Installing Runtime Versions

#### Global Installation
```bash
# Install and use globally
mise use -g node@20
mise use -g python@3.11
mise use -g go@latest

# Install specific version
mise install ruby@3.2.0
```

#### Project-Specific Installation
```bash
# Navigate to project directory
cd ~/projects/my-app

# Install and use locally
mise use node@18
mise use python@3.10

# This creates/updates .mise.toml
```

### Managing Versions
```bash
# List available versions
mise ls-remote python
mise ls-remote node

# List installed versions
mise ls

# Install without activating
mise install python@3.9

# Switch versions
mise use python@3.9
```

## Configuration

### `.mise.toml` Configuration
Create `.mise.toml` in your project root:

```toml
[tools]
node = "20"
python = "3.11"
go = "latest"
terraform = "1.5.0"

[env]
DATABASE_URL = "postgres://localhost/myapp"
DEBUG = "true"
NODE_ENV = "development"

[tasks.dev]
run = "npm run dev"
description = "Start development server"

[tasks.test]
run = "pytest tests/"
description = "Run tests"

[tasks.build]
run = "npm run build"
description = "Build for production"
```

### Global Configuration
Edit `~/.config/mise/config.toml`:

```toml
[tools]
node = "lts"
python = "3.11"
go = "latest"

[env]
EDITOR = "vim"
PAGER = "less"

[settings]
experimental = true
```

## Advanced Usage

### Environment Variables

#### Per-Project Variables
```bash
# Set environment variables
mise set DATABASE_URL=postgres://localhost/myapp
mise set DEBUG=true

# List variables
mise env

# Unset variables
mise unset DEBUG
```

#### Global Variables
```bash
# Set global variables
mise set -g EDITOR=vim
mise set -g PAGER=less
```

#### Environment Files
```toml
# .mise.toml
[env]
DATABASE_URL = "postgres://localhost/myapp"
DEBUG = { file = ".env.debug" }  # Load from file
API_KEY = { cmd = "op read op://vault/item/password" }  # Load from command
```

### Task Management

#### Define Tasks
```toml
# .mise.toml
[tasks.install]
run = "npm install"
description = "Install dependencies"

[tasks.dev]
run = "npm run dev"
description = "Start development server"
depends = ["install"]

[tasks.test]
run = ["pytest", "npm test"]
description = "Run all tests"

[tasks.deploy]
run = "kubectl apply -f k8s/"
description = "Deploy to Kubernetes"
depends = ["test", "build"]
```

#### Run Tasks
```bash
# List available tasks
mise tasks

# Run a task
mise run dev
mise run test

# Run with dependencies
mise run deploy  # Runs test and build first
```

### Plugin System

#### List Available Plugins
```bash
# Show available plugins
mise plugins

# Show installed plugins
mise plugins ls

# Install plugin
mise plugin install https://github.com/user/mise-plugin
```

#### Custom Plugins
Create custom plugins for tools not included by default:

```bash
# Create plugin directory
mkdir -p ~/.local/share/mise/plugins/my-tool

# Create plugin script
cat > ~/.local/share/mise/plugins/my-tool/bin/install << 'EOF'
#!/bin/bash
# Plugin installation script
EOF
```

## Language-Specific Examples

### Node.js Development
```toml
# .mise.toml
[tools]
node = "20"
pnpm = "8"

[env]
NODE_ENV = "development"

[tasks.install]
run = "pnpm install"

[tasks.dev]
run = "pnpm dev"
depends = ["install"]

[tasks.build]
run = "pnpm build"

[tasks.test]
run = "pnpm test"
```

### Python Development
```toml
# .mise.toml
[tools]
python = "3.11"

[env]
PYTHONPATH = "src"
DATABASE_URL = "sqlite:///app.db"

[tasks.install]
run = "pip install -r requirements.txt"

[tasks.dev]
run = "python -m flask run"
depends = ["install"]

[tasks.test]
run = "pytest"

[tasks.lint]
run = "black . && flake8 ."
```

### Go Development
```toml
# .mise.toml
[tools]
go = "latest"

[env]
CGO_ENABLED = "0"
GOOS = "linux"

[tasks.build]
run = "go build -o bin/app"

[tasks.test]
run = "go test ./..."

[tasks.run]
run = "go run main.go"
```

### Multi-Language Project
```toml
# .mise.toml
[tools]
node = "18"
python = "3.10"
go = "1.21"
terraform = "1.5"

[env]
DATABASE_URL = "postgres://localhost/myapp"
API_BASE_URL = "http://localhost:3000"

[tasks.install-frontend]
run = "cd frontend && npm install"

[tasks.install-backend]
run = "cd backend && pip install -r requirements.txt"

[tasks.install]
depends = ["install-frontend", "install-backend"]

[tasks.dev]
run = "docker-compose up"
depends = ["install"]

[tasks.test]
run = ["cd frontend && npm test", "cd backend && pytest"]
```

## Integration with Other Tools

### Docker Integration
```toml
# .mise.toml
[tools]
node = "18"

[tasks.docker-build]
run = "docker build -t myapp ."

[tasks.docker-run]
run = "docker run -p 3000:3000 myapp"
depends = ["docker-build"]
```

### Git Hooks
```bash
# .git/hooks/pre-commit
#!/bin/bash
mise run lint
mise run test
```

### CI/CD Integration
```yaml
# GitHub Actions
- name: Setup mise
  run: curl https://mise.run | sh

- name: Install tools
  run: mise install

- name: Run tests
  run: mise run test
```

### IDE Integration
```json
// VSCode settings.json
{
  "python.defaultInterpreterPath": "~/.local/share/mise/installs/python/3.11/bin/python",
  "terminal.integrated.env.linux": {
    "PATH": "${env:PATH}:~/.local/share/mise/shims"
  }
}
```

## Performance Tuning

### Caching
```toml
# ~/.config/mise/config.toml
[settings]
cache_prune_age = "30d"  # Prune cache older than 30 days
```

### Parallel Installation
```bash
# Install multiple tools in parallel
mise install python@3.11 node@20 go@latest --jobs 4
```

### Shims vs PATH
```bash
# Use PATH modification (faster)
export MISE_USE_SHIMS=0

# Use shims (more compatible)
export MISE_USE_SHIMS=1
```

## Troubleshooting

### Common Issues

#### Shell Integration Not Working
```bash
# Check shell integration
mise doctor

# Manually activate
eval "$(mise activate bash)"

# Check PATH
echo $PATH | grep mise
```

#### Tool Installation Fails
```bash
# Check available versions
mise ls-remote python

# Install with verbose output
mise install python@3.11 --verbose

# Check logs
mise log
```

#### Environment Variables Not Loading
```bash
# Check current environment
mise env

# Verify configuration
mise config

# Trust the directory
mise trust
```

#### Performance Issues
```bash
# Check mise status
mise status

# Disable unused features
export MISE_DISABLE_PLUGINS=1
```

### Debugging
```bash
# Enable debug mode
export MISE_DEBUG=1

# Check configuration
mise config

# Validate configuration
mise validate
```

## Migration

### From asdf
```bash
# Import existing .tool-versions
mise import-asdf

# Or manually convert
# .tool-versions -> .mise.toml
```

### From pyenv/nvm/rbenv
```bash
# Install equivalent versions
mise use python@$(python --version | cut -d' ' -f2)
mise use node@$(node --version | cut -d'v' -f2)
mise use ruby@$(ruby --version | cut -d' ' -f2)
```

### From direnv
```bash
# Convert .envrc to .mise.toml
# .envrc:
# export DATABASE_URL=postgres://localhost/myapp

# .mise.toml:
[env]
DATABASE_URL = "postgres://localhost/myapp"
```

## Best Practices

### Project Setup
1. **Define tools explicitly**: Specify exact versions for reproducibility
2. **Use environment variables**: Keep configuration in .mise.toml
3. **Document tasks**: Add descriptions to tasks
4. **Version control**: Commit .mise.toml to repository
5. **Team adoption**: Ensure all team members use mise

### Configuration Management
```toml
# .mise.toml
[tools]
# Use specific versions for stability
node = "18.17.0"
python = "3.11.4"

# Use 'latest' for non-critical tools
terraform = "latest"

[env]
# Use environment-specific variables
DATABASE_URL = { cmd = "echo $DATABASE_URL_DEV" }
```

### Task Organization
```toml
# .mise.toml
[tasks.install]
run = "npm install"
description = "Install dependencies"

[tasks.dev]
run = "npm run dev"
description = "Start development server"
depends = ["install"]

[tasks.test]
run = "npm test"
description = "Run tests"
depends = ["install"]

[tasks.ci]
run = "npm run build && npm test"
description = "CI pipeline"
depends = ["install"]
```

## Security Considerations

### Trust System
```bash
# Mise requires explicit trust for .mise.toml files
cd project
mise trust  # Trust current directory

# Check trusted directories
mise trust --list
```

### Environment Variable Security
```toml
# Don't commit sensitive variables
[env]
DATABASE_URL = { cmd = "op read op://vault/db/url" }  # Use secret manager
API_KEY = { file = ".env.local" }  # Load from gitignored file
```

### Plugin Security
```bash
# Only install plugins from trusted sources
mise plugin install https://github.com/trusted-user/plugin

# Review plugin code before installation
```

## Scripts and Automation

### Useful Aliases
```bash
# Add to .bashrc/.zshrc
alias m="mise"
alias mr="mise run"
alias mi="mise install"
alias mu="mise use"
alias ml="mise ls"
```

### Maintenance Script
```bash
#!/bin/bash
# ~/.local/bin/mise-maintenance

echo "Mise Maintenance"
echo "==============="

# Update mise
mise self-update

# Prune cache
mise cache prune

# Update all tools
mise upgrade

# Show status
mise status
```

## Updates and Maintenance

### Update Mise
```bash
# Self-update
mise self-update

# Or reinstall
curl https://mise.run | sh
```

### Update Tools
```bash
# Update all tools
mise upgrade

# Update specific tool
mise upgrade python

# Check for updates
mise outdated
```

### Cleanup
```bash
# Clean cache
mise cache clean

# Remove unused versions
mise prune
```

Mise provides a comprehensive solution for managing development environments, combining the best features of multiple tools into a single, fast, and reliable system that scales from individual projects to large teams.

---

For more information:
- [Mise GitHub Repository](https://github.com/jdx/mise)
- [Mise Documentation](https://mise.jdx.dev/)
- [Mise Configuration Reference](https://mise.jdx.dev/configuration.html)