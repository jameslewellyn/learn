#!/bin/bash

# Ubuntu 25.04 Development Environment Setup Script
# Installs and configures only tools with guides in the guides/ directory
# Uses mise as the primary tool manager, with fallbacks only for tools not supported by mise
# Designed for minimal Ubuntu installations and Docker containers

#set -x
set -euo pipefail

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

# Function to update package lists only if needed
update_package_lists() {
    echo "Updating package lists..."
    if ! apt list --upgradeable 2>/dev/null | grep -q -v "Listing..."; then
        echo "No package updates available, skipping apt-get update."
    else
        sudo apt-get update
    fi
}

# Function to install packages only if not already installed
install_packages_if_missing() {
    local -n packages_array="$1"
    local description="$2"
    
    echo "Installing $description..."
    local pkgs_to_install=()
    
    for pkg in "${packages_array[@]}"; do
        if ! dpkg -s "$pkg" &>/dev/null; then
            pkgs_to_install+=("$pkg")
        fi
    done
    
    if [ "${#pkgs_to_install[@]}" -gt 0 ]; then
        sudo apt-get install -y "${pkgs_to_install[@]}"
    else
        echo "All $description are already installed."
    fi
}

# Function to add repository/PPA only if not already present
add_repository_if_missing() {
    local repo_name="$1"
    local check_file="$2"
    local add_command="$3"
    local description="$4"
    
    if [ ! -f "$check_file" ]; then
        echo "Adding $description..."
        eval "$add_command"
    else
        echo "$description already present, skipping."
    fi
}

# Function to add PPA using add-apt-repository (for git-core pattern)
add_ppa_if_missing() {
    local ppa_name="$1"
    local check_pattern="$2"
    local description="$3"
    
    if ! ls "$check_pattern" 1>/dev/null 2>&1; then
        echo "Adding $description..."
        sudo add-apt-repository -y "$ppa_name"
    else
        echo "$description already present, skipping."
    fi
}

# Function to add modern repository with GPG key
add_modern_repository_if_missing() {
    local repo_name="$1"
    local repo_file="$2"
    local gpg_url="$3"
    local repo_url="$4"
    local description="$5"
    
    if [ ! -f "$repo_file" ]; then
        echo "Adding $description..."
        curl -fsSL "$gpg_url" | gpg --dearmor | sudo tee "/etc/apt/keyrings/${repo_name}.gpg" 1> /dev/null
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/${repo_name}.gpg] $repo_url" | sudo tee "$repo_file" > /dev/null
    else
        echo "$description already present, skipping."
    fi
}

# Function to configure systemctl service
configure_systemctl_service() {
    local service_name="$1"
    local action="$2"  # "enable" or "start"
    local description="$3"
    
    if ! systemctl is-$action "$service_name" > /dev/null 2>&1; then
        echo "$description..."
        sudo systemctl $action "$service_name"
    else
        echo "$service_name service already $action"
    fi
}

# Function to add line to bashrc only if not already present
add_to_bashrc_if_missing() {
    local line="$1"
    local description="$2"
    
    if ! grep -Fxq "$line" ~/.bashrc; then
        echo "$line" >> ~/.bashrc
        echo "Added $description to ~/.bashrc"
    else
        echo "$description already present in ~/.bashrc"
    fi
}

# Function to check if user is in group and add if not
add_user_to_group_if_missing() {
    local group_name="$1"
    local user_name="$2"
    local description="$3"
    
    if ! groups "$user_name" | grep -q "$group_name"; then
        echo "Adding user to $description..."
        sudo usermod -aG "$group_name" "$user_name"
    else
        echo "User already in $description"
    fi
}

# Function to configure Git settings
configure_git_setting() {
    local setting="$1"
    local prompt="$2"
    local current_value
    
    current_value=$(git config --global "$setting" || echo "")
    
    if [ -z "$current_value" ]; then
        read -p "$prompt: " input_value
        git config --global "$setting" "$input_value"
    else
        echo "Git global $setting is already set to '$current_value'"
    fi
}

# Function to configure subuid/subgid for rootless containers
configure_subuid_subgid() {
    local type="$1"  # "subuid" or "subgid"
    local user="$2"
    local range="$3"
    local description="$4"
    
    if ! grep -q "^$user:$range" "/etc/$type" 2>/dev/null; then
        echo "Configuring $description..."
        sudo usermod --add-sub${type:3}s "$range" "$user"
    else
        echo "$description already configured"
    fi
}

# =============================================================================
# MAIN SCRIPT
# =============================================================================

# Update package lists
update_package_lists

# Step 1: Install minimal system packages required for adding PPAs and repositories
minimal_pkgs=(
    apt-transport-https
    ca-certificates
    curl
    gnupg
    lsb-release
    software-properties-common
    wget
)
install_packages_if_missing minimal_pkgs "minimal system packages for PPAs/repositories"

# Step 2: Add Git PPA for latest version
add_ppa_if_missing \
    "ppa:git-core/ppa" \
    "/etc/apt/sources.list.d/git-core-ubuntu-ppa-*.sources" \
    "Git PPA for latest version"

# Step 3: Add mise PPA
add_modern_repository_if_missing \
    "mise" \
    "/etc/apt/sources.list.d/mise.list" \
    "https://mise.jdx.dev/gpg-key.pub" \
    "https://mise.jdx.dev/deb stable main" \
    "mise PPA"

# Step 4: Add Docker repository
add_modern_repository_if_missing \
    "docker" \
    "/etc/apt/sources.list.d/docker.list" \
    "https://download.docker.com/linux/ubuntu/gpg" \
    "https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    "Docker repository"

# Step 5: Update package lists after adding all PPAs
update_package_lists

# Step 6: Install all remaining essential packages
essential_pkgs=(
    build-essential
    clang
    containerd.io
    dbus-user-session
    docker-buildx-plugin
    docker-ce
    docker-ce-cli
    docker-compose-plugin
    fontconfig
    fuse-overlayfs
    git
    libc-dev
    libfontconfig1-dev
    libfreetype-dev
    libpcap-dev
    libssl-dev
    libxcb-xfixes0-dev
    libxkbcommon-dev
    mise
    pkg-config
    rsync
    rustup
    tree
    uidmap
    unzip
)
install_packages_if_missing essential_pkgs "essential system packages and tools"

# Configure Git settings
configure_git_setting "user.name" "Enter your Git username"
configure_git_setting "user.email" "Enter your Git email"

# Step 7: Install rust and associated programs
rustup install stable

echo "Git, mise, and Docker PPAs added and installed successfully!"

# Install tools via mise
echo "Installing tools via mise..."
eval "$(mise activate bash)"
mise_tools=(
    age                  # simple, modern encryption tool
    bat                  # cat clone with syntax highlighting
    bat-extras           # extra tools for bat (e.g. batdiff, batgrep)
    bottom               # graphical process/system monitor
    cargo:alacritty      # GPU-accelerated terminal emulator
    cargo:bacon          # Rust code watcher/auto-tester
    cargo:bandwhich      # display current network utilization by process
    cargo:broot          # interactive directory/file navigator
    cargo:cargo-nextest  # next-generation Rust test runner
    cargo:gping          # ping alternative in Rust
    cargo:huniq          # fast, parallel uniq for huge files
    cargo:jaq            # jq clone in Rust (JSON processor)
    cargo:mcfly          # smarter shell history search
    cargo:procs          # modern replacement for ps
    cargo:ouch           # compression/decompression tool
    cargo:skim           # fuzzy finder in Rust
    cargo:tealdeer       # fast tldr client (simplified man pages)
    cargo:xsv            # fast CSV toolkit
    choose               # cut/awk alternative for column extraction
    cmake                # cross-platform build system
    delta                # syntax-highlighting pager for git/diff output
    duf                  # disk usage/free utility
    dust                 # du alternative with better visualization
    fd                   # simple, fast alternative to find
    fzf                  # general-purpose command-line fuzzy finder
    grex                 # regex generator in Rust
    hexyl                # hex viewer in Rust
    hyperfine            # command-line benchmarking tool
    just                 # handy command runner (like make, but simpler)
    lazygit              # simple git client in Rust
    lsd                  # modern ls with icons and colors
    podman               # daemonless container engine
    python               # Python programming language
    rclone               # sync files to/from cloud storage
    ripgrep              # fast recursive search (grep alternative)
    ripgrep-all          # ripgrep with support for PDFs, EPUB, and more
    sd                   # intuitive find & replace CLI
    starship             # minimal, fast shell prompt
    tokei                # count lines of code, per language
    watchexec            # run commands in response to file changes
    zellij               # terminal workspace and multiplexer
    zoxide               # smarter cd command, directory jumper
)
mise use -g "${mise_tools[@]}"

# Configure shell environment
add_to_bashrc_if_missing 'eval "$(mise activate bash)"' "mise activation"
add_to_bashrc_if_missing "alias ls='lsd -l --group-dirs=first --color=always'" "lsd alias"
add_to_bashrc_if_missing 'eval "$(zoxide init bash)"' "zoxide initialization"
add_to_bashrc_if_missing "alias cd=\"z\"" "zoxide cd alias"
add_to_bashrc_if_missing "alias cdi=\"zi\"" "zoxide interactive alias"
add_to_bashrc_if_missing "alias zj=\"zellij attach --create main\"" "zellij attach alias"
add_to_bashrc_if_missing "alias zr=\"zellij kill-all-sessions && zellij delete-all-sessions\"" "zellij reset alias"
add_to_bashrc_if_missing 'eval "$(starship init bash)"' "starship initialization"

# Create configuration directory for zoxide
mkdir -p ~/.config/zoxide

echo "All mise tools installed successfully!"

# Configure Docker
echo "Configuring Docker..."

# Create docker group if it doesn't exist
if ! getent group docker > /dev/null 2>&1; then
    echo "Creating docker group..."
    sudo groupadd docker
else
    echo "Docker group already exists"
fi

# Add user to docker group
add_user_to_group_if_missing "docker" "$USER" "docker group"

# Enable and start Docker service
configure_systemctl_service "docker" "enable" "Enabling Docker service"
configure_systemctl_service "docker" "start" "Starting Docker service"

echo "Docker configuration completed!"

# Configure rootless Docker
echo "Configuring rootless Docker..."
echo "Starting subuid/subgid configuration for rootless Podman..."

configure_subuid_subgid "subuid" "$USER" "100000-165535" "subuid for user for Podman rootless containers"
configure_subuid_subgid "subgid" "$USER" "100000-165535" "subgid for user for Podman rootless containers"

echo "Completed subuid/subgid configuration for rootless Podman."

echo
echo "Setup completed successfully!"
