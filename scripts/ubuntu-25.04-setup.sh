#!/bin/bash

# Ubuntu 25.04 Development Environment Setup Script
# Installs and configures all tools mentioned in guides/ubuntu-setup/
# Compatible with minimal Ubuntu installations and Docker containers

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    log_error "This script should not be run as root"
    exit 1
fi

# Check if we're in a Docker container
IS_DOCKER=false
if [ -f /.dockerenv ] || grep -q 'docker\|lxc' /proc/1/cgroup 2>/dev/null; then
    IS_DOCKER=true
    log_info "Detected Docker container environment"
fi

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install package if not already installed
install_package() {
    local package=$1
    if ! dpkg -l | grep -q "^ii  $package "; then
        log_info "Installing $package..."
        sudo apt-get install -y "$package"
    else
        log_info "$package is already installed"
    fi
}

# Function to install packages
install_packages() {
    local packages=("$@")
    for package in "${packages[@]}"; do
        install_package "$package"
    done
}

# Function to add repository if not already added
add_repository() {
    local repo=$1
    local key_url=$2
    local key_file=$3
    
    if ! grep -q "$repo" /etc/apt/sources.list.d/* 2>/dev/null; then
        log_info "Adding repository: $repo"
        
        # Add GPG key
        if [[ -n "$key_url" ]]; then
            curl -fsSL "$key_url" | sudo gpg --dearmor -o "$key_file"
        fi
        
        # Add repository
        echo "deb [signed-by=$key_file] $repo" | sudo tee /etc/apt/sources.list.d/$(echo "$repo" | sed 's|https://||' | sed 's|/|_|g').list
    else
        log_info "Repository already added: $repo"
    fi
}

# Function to download and install binary
install_binary() {
    local name=$1
    local url=$2
    local binary_name=$3
    
    if ! command_exists "$binary_name"; then
        log_info "Installing $name..."
        local temp_dir=$(mktemp -d)
        cd "$temp_dir"
        
        curl -fsSL "$url" -o "$name.tar.gz"
        tar -xzf "$name.tar.gz"
        
        # Find the binary (handle different archive structures)
        if [[ -f "$binary_name" ]]; then
            sudo install "$binary_name" "/usr/local/bin/$binary_name"
        elif [[ -d "$name" ]] && [[ -f "$name/$binary_name" ]]; then
            sudo install "$name/$binary_name" "/usr/local/bin/$binary_name"
        else
            # Try to find the binary in the extracted files
            local found_binary=$(find . -name "$binary_name" -type f | head -1)
            if [[ -n "$found_binary" ]]; then
                sudo install "$found_binary" "/usr/local/bin/$binary_name"
            else
                log_error "Could not find $binary_name in downloaded archive"
                cd - > /dev/null
                rm -rf "$temp_dir"
                return 1
            fi
        fi
        
        cd - > /dev/null
        rm -rf "$temp_dir"
        log_success "$name installed successfully"
    else
        log_info "$name is already installed"
    fi
}

# Function to install Rust tool
install_rust_tool() {
    local tool=$1
    if ! command_exists "$tool"; then
        log_info "Installing $tool via cargo..."
        cargo install "$tool"
    else
        log_info "$tool is already installed"
    fi
}

# Function to configure shell
configure_shell() {
    local shell_rc=""
    if [[ -n "${BASH_VERSION:-}" ]]; then
        shell_rc="$HOME/.bashrc"
    elif [[ -n "${ZSH_VERSION:-}" ]]; then
        shell_rc="$HOME/.zshrc"
    else
        shell_rc="$HOME/.bashrc"
    fi
    
    echo "$1" >> "$shell_rc"
}

# Main installation function
main() {
    log_info "Starting Ubuntu 25.04 development environment setup..."
    
    # Update package lists
    log_info "Updating package lists..."
    sudo apt-get update
    
    # Install essential system packages
    log_info "Installing essential system packages..."
    install_packages \
        "curl" \
        "wget" \
        "git" \
        "build-essential" \
        "cmake" \
        "pkg-config" \
        "libssl-dev" \
        "libpcap-dev" \
        "python3" \
        "python3-pip" \
        "unzip" \
        "software-properties-common" \
        "apt-transport-https" \
        "ca-certificates" \
        "gnupg" \
        "lsb-release" \
        "fontconfig" \
        "libfontconfig1-dev" \
        "libfreetype6-dev" \
        "libxcb-xfixes0-dev" \
        "libxkbcommon-dev"
    
    # Install latest Git from PPA
    log_info "Installing latest Git from PPA..."
    sudo add-apt-repository ppa:git-core/ppa -y
    sudo apt-get update
    install_package "git"
    
    # Install Rust toolchain
    log_info "Installing Rust toolchain..."
    if ! command_exists "rustup"; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    else
        log_info "Rust is already installed"
        source "$HOME/.cargo/env"
    fi
    
    # Install Rust components
    log_info "Installing Rust components..."
    rustup component add rust-analyzer clippy rustfmt
    
    # Install NerdFont (JetBrains Mono)
    log_info "Installing NerdFont (JetBrains Mono)..."
    mkdir -p ~/.local/share/fonts
    cd ~/.local/share/fonts
    if [[ ! -f "JetBrainsMonoNerdFont-Regular.ttf" ]]; then
        curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -o JetBrainsMono.zip
        unzip -q JetBrainsMono.zip
        rm JetBrainsMono.zip
        fc-cache -fv
    else
        log_info "NerdFont is already installed"
    fi
    cd - > /dev/null
    
    # Install Rust CLI tools
    log_info "Installing Rust CLI tools..."
    local rust_tools=(
        "ripgrep"
        "fd-find"
        "bat"
        "lsd"
        "zoxide"
        "starship"
        "delta"
        "sd"
        "dust"
        "broot"
        "tealdeer"
        "ouch"
        "bandwhich"
        "procs"
        "bottom"
        "hyperfine"
        "tokei"
        "bacon"
        "cargo-nextest"
        "watchexec"
        "jaq"
        "choose"
        "huniq"
        "xsv"
        "miller"
        "fx"
        "glow"
        "pandoc"
        "ffmpeg"
        "imagemagick"
        "exiftool"
        "stress"
        "iotop"
        "rsync"
        "rclone"
        "mtr"
        "nmap"
    )
    
    for tool in "${rust_tools[@]}"; do
        install_rust_tool "$tool"
    done
    
    # Install development tools
    log_info "Installing development tools..."
    
    # Install mise
    if ! command_exists "mise"; then
        log_info "Installing mise..."
        curl https://mise.run | sh
        source "$HOME/.bashrc"
    fi
    
    # Install just
    install_rust_tool "just"
    
    # Install lazygit
    if ! command_exists "lazygit"; then
        log_info "Installing lazygit..."
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin/
        rm lazygit lazygit.tar.gz
    fi
    
    # Install GitHub CLI
    if ! command_exists "gh"; then
        log_info "Installing GitHub CLI..."
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt-get update
        install_package "gh"
    fi
    
    # Install shell productivity tools
    log_info "Installing shell productivity tools..."
    
    # Install fzf
    if ! command_exists "fzf"; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
    fi
    
    # Install mcfly
    install_rust_tool "mcfly"
    
    # Install system utilities
    log_info "Installing system utilities..."
    install_package "duf"
    install_package "htop"
    install_package "tree"
    install_package "rsync"
    
    # Install security tools
    log_info "Installing security tools..."
    install_rust_tool "age"
    
    # Install containerization tools (only if not in Docker)
    if [[ "$IS_DOCKER" == "false" ]]; then
        log_info "Installing containerization tools..."
        
        # Install Docker
        if ! command_exists "docker"; then
            log_info "Installing Docker..."
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt-get update
            install_packages "docker-ce" "docker-ce-cli" "containerd.io" "docker-buildx-plugin" "docker-compose-plugin"
            
            # Add user to docker group
            sudo usermod -aG docker "$USER"
            log_warning "Docker installed. You may need to log out and back in for group changes to take effect."
        fi
    else
        log_info "Skipping Docker installation (running in container)"
    fi
    
    # Configure shell environment
    log_info "Configuring shell environment..."
    
    # Add cargo bin to PATH
    configure_shell 'export PATH="$HOME/.cargo/bin:$PATH"'
    
    # Configure starship
    configure_shell 'eval "$(starship init bash)"'
    
    # Configure zoxide
    configure_shell 'eval "$(zoxide init bash)"'
    
    # Configure fzf
    configure_shell 'source ~/.fzf.bash'
    
    # Configure mcfly
    configure_shell 'eval "$(mcfly init bash)"'
    
    # Configure GitHub CLI completion
    configure_shell 'source <(gh completion bash)'
    
    # Add useful aliases
    configure_shell 'alias ls="lsd"'
    configure_shell 'alias ll="lsd -l"'
    configure_shell 'alias la="lsd -la"'
    configure_shell 'alias tree="lsd --tree"'
    configure_shell 'alias find="fd"'
    configure_shell 'alias grep="rg"'
    configure_shell 'alias cat="bat"'
    
    # Create configuration directories and files
    log_info "Creating configuration files..."
    
    # Create starship config
    mkdir -p ~/.config
    cat > ~/.config/starship.toml << 'EOF'
# Get editor completions based on the config schema
"$schema" = 'https://starship.rs/config-schema.json'

# Inserts a blank line between shell prompts
add_newline = true

# Replace the '❯' symbol in the prompt with '➜'
[character]
success_symbol = '[➜](bold green)'
error_symbol = '[✗](bold red)'

# Disable the package module, hiding it from the prompt completely
[package]
disabled = true

[git_branch]
symbol = " "
truncation_length = 4
truncation_symbol = ""

[git_status]
style = "red bold"
ahead = "⇡\${count}"
behind = "⇣\${count}"
diverged = "⇕⇡\${ahead_count}⇣\${behind_count}"
untracked = "?"
stashed = "≡"
modified = "!"
staged = "+"
renamed = "»"
deleted = "✘"

[nodejs]
symbol = " "

[rust]
symbol = " "

[python]
symbol = " "

[golang]
symbol = " "

[php]
symbol = " "

[scala]
symbol = " "

[swift]
symbol = " "

[elixir]
symbol = " "

[julia]
symbol = " "

[docker_context]
symbol = " "

[aws]
symbol = " "

[gcloud]
symbol = " "

[openstack]
symbol = " "

[env_var]
variable = "VIRTUAL_ENV"
symbol = " "
style = "bold black"

[conda]
symbol = " "

[memory_usage]
symbol = " "
disabled = false
threshold = 75

[cmd_duration]
min_time = 2_000
show_milliseconds = true

[line_break]
disabled = false

[time]
disabled = false
format = '🕙[%T]'
time_format = "%T"
utc_time_offset = "-5"
EOF
    
    # Create ripgrep config
    cat > ~/.ripgreprc << 'EOF'
# Don't let ripgrep vomit really long lines to my terminal
--max-columns=150

# Add my 'web' type.
--type-add=web:*.{html,css,js}*

# Search hidden files and directories
--hidden

# Don't search in .git directories
--glob=!.git/*

# Using glob patterns to include/exclude files or folders
--glob=!node_modules/*
--glob=!target/*
--glob=!dist/*
--glob=!build/*
EOF
    
    # Create fd config
    mkdir -p ~/.config/fd
    cat > ~/.config/fd/ignore << 'EOF'
.git/
node_modules/
target/
dist/
build/
*.tmp
*.log
.DS_Store
EOF
    
    # Create lsd config
    mkdir -p ~/.config/lsd
    cat > ~/.config/lsd/config.yaml << 'EOF'
classic: false
blocks:
  - permission
  - user
  - group
  - size
  - date
  - name
color:
  when: auto
date: relative
dereference: false
display: all
icons:
  when: auto
  theme: fancy
  separator: " "
indicators: false
layout: grid
recursion:
  enabled: false
  depth: 5
size: default
permission: rwx
sorting:
  column: name
  reverse: false
  dir-grouping: first
no-symlink: false
total-size: false
EOF
    
    # Create alacritty config
    mkdir -p ~/.config/alacritty
    cat > ~/.config/alacritty/alacritty.yml << 'EOF'
window:
  padding:
    x: 10
    y: 10
  decorations: full
  startup_mode: Windowed

font:
  normal:
    family: "JetBrainsMono Nerd Font"
    style: Regular
  size: 12.0

colors:
  primary:
    background: '0x1e1e1e'
    foreground: '0xd4d4d4'
  cursor:
    text: '0x1e1e1e'
    cursor: '0xd4d4d4'

scrolling:
  history: 10000

shell:
  program: /bin/bash
  args:
    - --login
EOF
    
    # Set environment variables
    configure_shell 'export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"'
    configure_shell 'export EDITOR="vim"'
    configure_shell 'export PAGER="less"'
    
    # Configure Git
    log_info "Configuring Git..."
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global fetch.prune true
    git config --global rebase.autoStash true
    git config --global rerere.enabled true
    
    # Update tldr database
    log_info "Updating tldr database..."
    tldr --update
    
    # Final verification
    log_info "Verifying installations..."
    
    local tools_to_verify=(
        "git" "rustc" "cargo" "ripgrep" "fd" "bat" "lsd" "zoxide" 
        "starship" "delta" "sd" "dust" "broot" "tealdeer" "ouch" 
        "bandwhich" "procs" "bottom" "hyperfine" "tokei" "bacon" 
        "cargo-nextest" "watchexec" "jaq" "choose" "huniq" "xsv" 
        "miller" "fx" "glow" "pandoc" "ffmpeg" "imagemagick" 
        "exiftool" "stress" "iotop" "rsync" "rclone" "mtr" "nmap"
        "mise" "just" "lazygit" "gh" "fzf" "mcfly" "duf" "htop"
        "tree" "age"
    )
    
    local failed_tools=()
    for tool in "${tools_to_verify[@]}"; do
        if command_exists "$tool"; then
            log_success "$tool is installed"
        else
            log_warning "$tool is not installed"
            failed_tools+=("$tool")
        fi
    done
    
    if [[ ${#failed_tools[@]} -gt 0 ]]; then
        log_warning "The following tools failed to install: ${failed_tools[*]}"
        log_warning "You may need to install them manually"
    fi
    
    log_success "Ubuntu 25.04 development environment setup completed!"
    log_info "Please restart your terminal or run 'source ~/.bashrc' to apply changes"
    
    if [[ "$IS_DOCKER" == "false" ]]; then
        log_warning "If Docker was installed, you may need to log out and back in for group changes to take effect"
    fi
}

# Run main function
main "$@" 