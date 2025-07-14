#!/bin/bash

# Ubuntu 25.04 Development Environment Setup Script
# Installs and configures only tools with guides in the guides/ directory
# Uses mise as the primary tool manager, with fallbacks only for tools not supported by mise
# Designed for minimal Ubuntu installations and Docker containers

#set -x
set -euo pipefail

# Update package lists
echo "Updating package lists..."
if ! apt list --upgradeable 2>/dev/null | grep -q -v "Listing..."; then
    echo "No package updates available, skipping apt-get update."
else
    sudo apt-get update
fi

# Step 1: Install only the packages needed to add PPAs and repositories
echo "Installing minimal system packages required for adding PPAs and repositories..."
# Install minimal system packages required for adding PPAs and repositories, but only if not already installed
minimal_pkgs=(
    apt-transport-https
    ca-certificates
    curl
    gnupg
    lsb-release
    software-properties-common
    wget
)

pkgs_to_install=()
for pkg in "${minimal_pkgs[@]}"; do
    if ! dpkg -s "$pkg" &>/dev/null; then
        pkgs_to_install+=("$pkg")
    fi
done

if [ "${#pkgs_to_install[@]}" -gt 0 ]; then
    sudo apt-get install -y "${pkgs_to_install[@]}"
else
    echo "All minimal system packages for PPAs/repositories are already installed."
fi

# Step 2: Add Git PPA for latest version (if not already present)
if ! ls /etc/apt/sources.list.d/git-core-ubuntu-ppa-*.sources 1>/dev/null 2>&1; then
    echo "Adding Git PPA for latest version..."
    sudo add-apt-repository -y ppa:git-core/ppa
else
    echo "Git PPA already present, skipping."
fi

# Step 3: Add mise PPA (if not already present)
if [ ! -f /etc/apt/sources.list.d/mise.list ]; then
    echo "Adding mise PPA..."
    sudo install -dm 755 /etc/apt/keyrings
    curl -fsSL https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1> /dev/null
    echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=amd64] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
else
    echo "mise PPA already present, skipping."
fi

# Step 4: Add Docker repository (modern approach, if not already present)
if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
    echo "Adding Docker repository..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor | sudo tee /etc/apt/keyrings/docker.gpg 1> /dev/null
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
else
    echo "Docker repository already present, skipping."
fi

# Step 5: Update package lists after adding all PPAs
echo "Updating package lists after adding PPAs..."
# Update package lists
echo "Updating package lists..."
if ! apt list --upgradeable 2>/dev/null | grep -q -v "Listing..."; then
    echo "No package updates available, skipping apt-get update."
else
    sudo apt-get update
fi


# Step 6: Install all remaining essential packages, including those from new PPAs
echo "Installing all essential system packages and tools..."
# Only install packages that are not already installed
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

pkgs_to_install=()
for pkg in "${essential_pkgs[@]}"; do
    if ! dpkg -s "$pkg" &>/dev/null; then
        pkgs_to_install+=("$pkg")
    fi
done

if [ "${#pkgs_to_install[@]}" -gt 0 ]; then
    sudo apt-get install -y "${pkgs_to_install[@]}"
else
    echo "All essential system packages and tools are already installed."
fi

# Check if git user.name and user.email are already set in global config
current_git_username=$(git config --global user.name || echo "")
current_git_email=$(git config --global user.email || echo "")

if [ -z "$current_git_username" ]; then
    read -p "Enter your Git username: " GIT_USERNAME
    git config --global user.name "$GIT_USERNAME"
else
    echo "Git global user.name is already set to '$current_git_username'"
fi

if [ -z "$current_git_email" ]; then
    read -p "Enter your Git email: " GIT_EMAIL
    git config --global user.email "$GIT_EMAIL"
else
    echo "Git global user.email is already set to '$current_git_email'"
fi

# Step 7: Install rust and associated programs
rustup install stable

echo "Git, mise, and Docker PPAs added and installed successfully!"

# Install tools via mise (from common.txt)
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
    gping                # ping alternative in Rust
    hexyl                # hex viewer in Rust
    hyperfine            # command-line benchmarking tool
    just                 # handy command runner (like make, but simpler)
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

if ! grep -Fxq 'eval "$(mise activate bash)"' ~/.bashrc; then
    echo 'eval "$(mise activate bash)"' >> ~/.bashrc
fi
echo "All mise tools installed successfully!"

# Configure Docker (only if not already configured)
echo "Configuring Docker..."

# Check if docker group exists and user is already in it
if ! getent group docker > /dev/null 2>&1; then
    echo "Creating docker group..."
    sudo groupadd docker
else
    echo "Docker group already exists"
fi

# Check if user is already in docker group
if ! groups "$USER" | grep -q docker; then
    echo "Adding user to docker group..."
    sudo usermod -aG docker "$USER"
else
    echo "User already in docker group"
fi
# Enable and start Docker service (only if not already enabled)
if ! systemctl is-enabled docker > /dev/null 2>&1; then
    echo "Enabling Docker service..."
    sudo systemctl enable docker
else
    echo "Docker service already enabled"
fi

# Start Docker service (only if not already running)
if ! systemctl is-active docker > /dev/null 2>&1; then
    echo "Starting Docker service..."
    sudo systemctl start docker
else
    echo "Docker service already running"
fi

echo "Docker configuration completed!"

# Configure rootless Docker (only if not already configured)
echo "Configuring rootless Docker..."

echo "Starting subuid/subgid configuration for rootless Podman..."

# Configure subuid for rootless Podman
if ! grep -q "^$USER:100000:65536" /etc/subuid 2>/dev/null; then
    echo "Configuring subuid for user for Podman rootless containers..."
    sudo usermod --add-subuids 100000-165535 "$USER"
else
    echo "Subuid already configured for user for Podman"
fi

# Configure subgid for rootless Podman
if ! grep -q "^$USER:100000:65536" /etc/subgid 2>/dev/null; then
    echo "Configuring subgid for user for Podman rootless containers..."
    sudo usermod --add-subgids 100000-165535 "$USER"
else
    echo "Subgid already configured for user for Podman"
fi

echo "Completed subuid/subgid configuration for rootless Podman."

echo

echo "Setup completed successfully!"
