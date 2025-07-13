# Just - Command Runner Installation and Setup Guide

A handy way to save and run project-specific commands with a simple, clean syntax.

## What is Just?

**Just** is a command runner that serves as a modern alternative to Make. It allows you to save and run project-specific commands with an intuitive syntax. Unlike Make, Just focuses on simplicity and doesn't concern itself with dependencies or incremental builds - it's purely for running commands.

## Key Features

- **Simple syntax**: Easy to read and write recipes
- **Cross-platform**: Works on Linux, macOS, and Windows
- **No dependencies**: Single binary with no external dependencies
- **Recipe parameters**: Support for command-line arguments
- **Conditional execution**: Run commands based on conditions
- **Environment variables**: Built-in support for environment variables
- **Recipe dependencies**: Define dependencies between recipes
- **Shell selection**: Choose which shell to use for recipes

## Installation

### Method 1: Cargo (Recommended)
```bash
cargo install just
```

### Method 2: APT (Ubuntu 22.04+)
```bash
sudo apt update
sudo apt install just
```

### Method 3: Manual Binary Download
```bash
# Download latest release
curl -LO "https://github.com/casey/just/releases/latest/download/just-x86_64-unknown-linux-musl.tar.gz"
tar -xzf just-x86_64-unknown-linux-musl.tar.gz
sudo mv just /usr/local/bin/
rm just-x86_64-unknown-linux-musl.tar.gz
```

### Method 4: From Source
```bash
git clone https://github.com/casey/just.git
cd just
cargo build --release
sudo cp target/release/just /usr/local/bin/
```

## Basic Usage

### Creating a Justfile
Create a `justfile` (or `Justfile`) in your project root:

```bash
# This is a justfile
hello:
    echo "Hello, World!"

# Recipe with parameters
greet name:
    echo "Hello, {{name}}!"

# Recipe with default parameter
greet-default name="World":
    echo "Hello, {{name}}!"
```

### Running Recipes
```bash
# List available recipes
just

# Run a recipe
just hello

# Run recipe with parameter
just greet Alice

# Run recipe with default parameter
just greet-default
```

## Justfile Syntax

### Basic Recipe Structure
```bash
# Comments start with #
recipe_name:
    command1
    command2
    
# Recipe with parameters
recipe_with_params param1 param2:
    echo "First param: {{param1}}"
    echo "Second param: {{param2}}"
```

### Parameters and Default Values
```bash
# Required parameter
build target:
    cargo build --target {{target}}

# Optional parameter with default
serve port="8080":
    python -m http.server {{port}}

# Multiple parameters with defaults
deploy env="dev" version="latest":
    docker deploy {{env}} {{version}}
```

### Variables
```bash
# Set variables
version := "1.0.0"
docker_image := "myapp:" + version

# Use variables
build:
    docker build -t {{docker_image}} .

# Environment variables
build:
    echo "Building version {{env_var('VERSION', 'dev')}}"
```

### Recipe Dependencies
```bash
# Recipe depends on other recipes
test: build
    cargo test

# Multiple dependencies
deploy: test lint
    ./deploy.sh

# Conditional dependencies
publish: (test "release")
    cargo publish
```

## Advanced Features

### Conditional Execution
```bash
# Run based on OS
install:
    #!/usr/bin/env bash
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt install something
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install something
    fi

# Check if command exists
setup:
    #!/usr/bin/env bash
    if command -v docker &> /dev/null; then
        echo "Docker is installed"
    else
        echo "Please install Docker"
        exit 1
    fi
```

### Multi-line Recipes
```bash
# Using backslash continuation
long-command:
    command1 \
    --option1 value1 \
    --option2 value2

# Using here documents
generate-config:
    cat > config.yml << EOF
    database:
      host: localhost
      port: 5432
    EOF
```

### Working Directory
```bash
# Change working directory for recipe
build:
    cd frontend && npm run build
    cd backend && cargo build

# Or use subdirectory syntax
build:
    cd frontend
    npm run build
    cd ../backend
    cargo build
```

## Common Use Cases

### Development Workflow
```bash
# Development justfile
default: dev

# Install dependencies
install:
    npm install
    pip install -r requirements.txt

# Start development server
dev:
    python manage.py runserver

# Run tests
test:
    pytest tests/
    npm test

# Format code
format:
    black .
    prettier --write .

# Lint code
lint:
    flake8 .
    eslint .

# Build for production
build:
    npm run build
    python manage.py collectstatic

# Deploy to production
deploy: test build
    ./deploy.sh production
```

### Docker Management
```bash
# Docker workflow
image_name := "myapp"
image_tag := "latest"

# Build Docker image
build:
    docker build -t {{image_name}}:{{image_tag}} .

# Run container
run: build
    docker run -p 8080:8080 {{image_name}}:{{image_tag}}

# Push to registry
push: build
    docker push {{image_name}}:{{image_tag}}

# Clean up
clean:
    docker system prune -f
```

### Database Management
```bash
# Database operations
db_url := env_var_or_default("DATABASE_URL", "postgres://localhost/myapp")

# Run migrations
migrate:
    alembic upgrade head

# Create migration
migrate-create name:
    alembic revision --autogenerate -m "{{name}}"

# Reset database
reset:
    dropdb myapp
    createdb myapp
    just migrate

# Seed database
seed:
    python manage.py seed
```

### Testing and CI
```bash
# Testing pipeline
test-all: test-unit test-integration test-e2e

# Unit tests
test-unit:
    pytest tests/unit/

# Integration tests
test-integration:
    pytest tests/integration/

# End-to-end tests
test-e2e:
    playwright test

# Coverage report
coverage:
    pytest --cov=src tests/
    coverage html

# CI pipeline
ci: lint test-all build
    echo "CI pipeline complete"
```

## Configuration

### Shell Selection
```bash
# Set shell for all recipes
set shell := ["bash", "-c"]

# Or for a specific recipe
python-recipe:
    #!/usr/bin/env python3
    print("This runs in Python")

# Use different shells
powershell-recipe:
    #!/usr/bin/env pwsh
    Write-Host "This runs in PowerShell"
```

### Environment Variables
```bash
# Set environment variables
export NODE_ENV := "development"
export DATABASE_URL := "postgres://localhost/myapp"

# Use in recipes
start:
    echo "Starting in {{env_var('NODE_ENV')}} mode"
    npm start

# Load from .env file
export $(cat .env | xargs)
```

### Justfile Settings
```bash
# Justfile settings
set dotenv-load := true      # Load .env file
set export := true           # Export all variables
set positional-arguments     # Allow positional arguments
set shell := ["bash", "-uc"] # Use bash with unofficial strict mode

# Allow unstable features
set allow-duplicate-recipes := true
```

## Integration with Other Tools

### Git Integration
```bash
# Git workflow
branch := `git rev-parse --abbrev-ref HEAD`
commit := `git rev-parse HEAD`

# Create and push feature branch
feature name:
    git checkout -b feature/{{name}}
    git push -u origin feature/{{name}}

# Release workflow
release version:
    git tag v{{version}}
    git push origin v{{version}}
    just build
    just deploy
```

### Make Integration
```bash
# Migrate from Makefile
.PHONY: all clean build test

# Convert to justfile
all: build test

clean:
    rm -rf build/

build:
    go build -o build/app

test:
    go test ./...
```

### Package Manager Integration
```bash
# Node.js project
install:
    npm install

dev:
    npm run dev

build:
    npm run build

# Python project
install:
    pip install -r requirements.txt

dev:
    python -m flask run

test:
    pytest
```

## Best Practices

### Organization
```bash
# Group related recipes
# Development
dev: install
    npm run dev

dev-build:
    npm run build:dev

# Production
prod-build:
    npm run build:prod

prod-deploy: prod-build
    ./deploy.sh
```

### Documentation
```bash
# Document recipes with comments
# Build the application for production
build:
    # Install dependencies
    npm install
    # Build optimized bundle
    npm run build

# Add help recipe
help:
    @echo "Available commands:"
    @echo "  install - Install dependencies"
    @echo "  dev     - Start development server"
    @echo "  build   - Build for production"
    @echo "  test    - Run tests"
```

### Error Handling
```bash
# Exit on error
set -e

# Strict mode
strict-recipe:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "This recipe uses strict mode"

# Error handling
deploy:
    #!/usr/bin/env bash
    set -e
    
    if ! command -v docker &> /dev/null; then
        echo "Docker is required but not installed"
        exit 1
    fi
    
    docker build -t myapp . || {
        echo "Build failed"
        exit 1
    }
```

## Troubleshooting

### Common Issues

#### Recipe not found
```bash
# Check available recipes
just --list

# Verify justfile syntax
just --check
```

#### Parameter errors
```bash
# Check recipe signature
just --show recipe_name

# Use quotes for parameters with spaces
just greet "John Doe"
```

#### Shell issues
```bash
# Check shell configuration
just --evaluate

# Use explicit shell
set shell := ["bash", "-c"]
```

### Debugging
```bash
# Verbose output
just --verbose recipe_name

# Dry run
just --dry-run recipe_name

# Show what would be executed
just --show recipe_name
```

## Migration from Make

### Converting Makefiles
```bash
# Makefile pattern
.PHONY: clean build test
BINARY_NAME=myapp

clean:
	rm -f $(BINARY_NAME)

build: clean
	go build -o $(BINARY_NAME)

test:
	go test ./...

# Equivalent justfile
binary_name := "myapp"

clean:
    rm -f {{binary_name}}

build: clean
    go build -o {{binary_name}}

test:
    go test ./...
```

### Key Differences
- No automatic dependency tracking
- Simpler syntax
- No implicit rules
- Variables use `{{}}` syntax
- No tabs required for indentation

## Scripts and Automation

### Useful Aliases
```bash
# Add to .bashrc/.zshrc
alias j="just"
alias jl="just --list"
alias js="just --show"
```

### Shell Completion
```bash
# Bash completion
just --completions bash > /etc/bash_completion.d/just

# Zsh completion
just --completions zsh > ~/.zsh/_just

# Fish completion
just --completions fish > ~/.config/fish/completions/just.fish
```

### Editor Integration
```bash
# Vim syntax highlighting
mkdir -p ~/.vim/syntax
curl -o ~/.vim/syntax/just.vim https://raw.githubusercontent.com/casey/just/master/contrib/just.vim

# VSCode extension
code --install-extension kokoscript.just
```

## Integration with Your Toolkit

Just pairs excellently with:
- **watchexec**: Run recipes when files change
- **git**: Version control workflows
- **docker**: Container management
- **make**: Can coexist with existing Makefiles
- **cargo**: Rust project management
- **npm/yarn**: Node.js project management

## Updates and Maintenance

### Update Just
```bash
# If installed via cargo
cargo install just

# If installed via apt
sudo apt update && sudo apt upgrade just

# If installed manually
curl -LO "https://github.com/casey/just/releases/latest/download/just-x86_64-unknown-linux-musl.tar.gz"
tar -xzf just-x86_64-unknown-linux-musl.tar.gz
sudo mv just /usr/local/bin/
```

### Justfile Maintenance
```bash
# Check justfile syntax
just --check

# Format justfile
just --fmt

# Update documentation
just --list > README.md
```

Just simplifies project automation by providing a clean, readable syntax for defining and running commands, making it easier to maintain and share project workflows across teams.

---

For more information:
- [Just GitHub Repository](https://github.com/casey/just)
- [Just Manual](https://just.systems/man/en/)
- [Just Examples](https://github.com/casey/just/tree/master/examples)