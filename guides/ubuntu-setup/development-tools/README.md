# Development Tools

Tools for modern development workflows, environment management, and project automation.

## Available Tools

### **[Just](./just.md)** - Command Runner
- **Purpose**: Modern alternative to Make for running project commands
- **Key Features**: Simple syntax, parameter support, cross-platform
- **Use Case**: Project automation, build scripts, development workflows
- **Installation**: `cargo install just`

### **[Mise](./mise.md)** - Development Environment Manager
- **Purpose**: Unified tool for runtime versions, environment variables, and tasks
- **Key Features**: Multi-language support, environment management, task runner
- **Use Case**: Managing Node.js/Python/Ruby versions, project environments
- **Installation**: `curl https://mise.run | sh`

## Quick Start

```bash
# Install both tools
cargo install just
curl https://mise.run | sh

# Basic setup
echo 'eval "$(mise activate bash)"' >> ~/.bashrc
source ~/.bashrc
```

## Tool Synergy

These tools complement each other perfectly:

### **Just + Mise = Complete Development Environment**
- **Mise**: Manages language versions and environment variables
- **Just**: Defines and runs project-specific commands
- **Together**: Consistent development environment with automated workflows

### **Integration Examples**

Create a `justfile` that uses mise-managed tools:

```bash
# justfile
default: install dev

# Install dependencies using mise-managed tools
install:
    npm install
    pip install -r requirements.txt

# Start development server
dev:
    npm run dev

# Run tests with specific environment
test:
    pytest tests/

# Build for production
build:
    npm run build
    python setup.py build
```

Create a `.mise.toml` for consistent environments:

```toml
[tools]
node = "18"
python = "3.11"
go = "latest"

[env]
NODE_ENV = "development"
DATABASE_URL = "postgres://localhost/myapp"

[tasks.install]
run = "just install"
description = "Install all dependencies"

[tasks.dev]
run = "just dev"
description = "Start development server"
```

## Key Benefits

1. **Environment Consistency**: Mise ensures same tool versions across team
2. **Automation**: Just provides easy command automation
3. **Simplicity**: Both tools focus on clean, readable configuration
4. **Integration**: Work together seamlessly in development workflows
5. **Cross-platform**: Both work on Linux, macOS, and Windows

## Configuration Tips

### Project Setup
```bash
# Initialize project with both tools
cd my-project

# Create justfile
cat > justfile << 'EOF'
default: install

install:
    npm install

dev:
    npm run dev

test:
    npm test

build:
    npm run build
EOF

# Create .mise.toml
cat > .mise.toml << 'EOF'
[tools]
node = "18"

[env]
NODE_ENV = "development"

[tasks.start]
run = "just dev"
description = "Start development server"
EOF
```

### Team Workflow
```bash
# Team member setup
git clone project
cd project

# Mise automatically installs correct tool versions
mise install

# Just provides consistent commands
just install
just dev
```

## Development Workflows

### Node.js Project
```bash
# .mise.toml
[tools]
node = "18"
pnpm = "8"

[env]
NODE_ENV = "development"

# justfile
install:
    pnpm install

dev:
    pnpm dev

test:
    pnpm test

build:
    pnpm build
```

### Python Project
```bash
# .mise.toml
[tools]
python = "3.11"

[env]
PYTHONPATH = "src"

# justfile
install:
    pip install -r requirements.txt

dev:
    python -m flask run

test:
    pytest

lint:
    black . && flake8 .
```

### Multi-language Project
```bash
# .mise.toml
[tools]
node = "18"
python = "3.11"
go = "latest"

[env]
DATABASE_URL = "postgres://localhost/myapp"

# justfile
install-frontend:
    cd frontend && npm install

install-backend:
    cd backend && pip install -r requirements.txt

install: install-frontend install-backend

dev:
    docker-compose up

test:
    cd frontend && npm test
    cd backend && pytest
```

## Best Practices

### Project Structure
```
project/
├── .mise.toml           # Environment and tool versions
├── justfile             # Project commands
├── .env.example         # Environment template
├── README.md           # Project documentation
└── src/                # Source code
```

### Command Organization
1. **Use descriptive names**: `install`, `dev`, `test`, `build`
2. **Group related tasks**: Development, testing, deployment
3. **Document commands**: Add descriptions to tasks
4. **Use dependencies**: Define task dependencies
5. **Environment specific**: Use mise for environment variables

### Team Adoption
1. **Commit configuration**: Include both `.mise.toml` and `justfile`
2. **Document setup**: Clear installation instructions
3. **Consistent commands**: Same commands across all projects
4. **Version control**: Track environment and tool versions
5. **CI/CD integration**: Use both tools in automation

## Troubleshooting

### Common Issues
- **Command not found**: Check mise activation and PATH
- **Wrong tool version**: Verify mise configuration
- **Task failures**: Check just dependencies and environment

### Resources
- Individual tool guides contain detailed troubleshooting
- Both tools have excellent documentation
- Active communities for support

## Integration with Other Tools

These development tools enhance:
- **Git workflows**: Version-controlled environments and commands
- **CI/CD**: Consistent builds and deployments
- **Docker**: Reproducible environments
- **IDEs**: Consistent tool versions and commands
- **Team collaboration**: Shared development environments

## Migration Strategies

### From Make to Just
```bash
# Makefile
.PHONY: install dev test
install:
	npm install
dev:
	npm run dev

# justfile
install:
    npm install
dev:
    npm run dev
```

### From Multiple Version Managers to Mise
```bash
# Instead of:
nvm use 18
pyenv local 3.11
rbenv local 3.2

# Use:
mise use node@18 python@3.11 ruby@3.2
```

---

**Next Steps**: Choose the tools that match your development workflow and follow their individual installation guides for detailed setup instructions.