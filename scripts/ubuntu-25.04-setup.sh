#!/bin/bash

# Ubuntu 25.04 Development Environment Setup Script
# Installs and configures all tools mentioned in guides/ubuntu-setup/
# Uses mise as the primary tool manager with fallbacks for unavailable tools
# Compatible with minimal Ubuntu installations and Docker containers

set -euo pipefail

# Update package lists
echo "Updating package lists..."
sudo apt-get update

# Install essential system packages
echo "Installing essential system packages..."
sudo apt-get install -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    fontconfig \
    gnupg \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpcap-dev \
    libssl-dev \
    libxcb-xfixes0-dev \
    libxkbcommon-dev \
    lsb-release \
    pkg-config \
    rsync \
    software-properties-common \
    tree \
    unzip \
    wget

# Add Git PPA for latest version
echo "Adding Git PPA for latest version..."
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt-get update
sudo apt-get install -y git

# Add mise PPA and install mise
echo "Installing mise via PPA..."
sudo install -dm 755 /etc/apt/keyrings
wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1> /dev/null
echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=amd64] https://mise.jdx.dev/deb stable main" | sudo tee /etc/apt/sources.list.d/mise.list
sudo apt-get update
sudo apt-get install -y mise

# Add Docker repository (simplified)
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

echo "Git, mise, and Docker PPAs added and installed successfully!"

# Install tools via mise (from common.txt)
echo "Installing tools via mise..."
mise install \
    age \
    bat \
    bottom \
    choose \
    delta \
    duf \
    dust \
    fd \
    fzf \
    hyperfine \
    just \
    lsd \
    rclone \
    ripgrep \
    sd \
    starship \
    tokei \
    watchexec \
    zoxide
echo "All mise tools installed successfully!"

# Install Rust CLI tools via cargo (from uncommon.txt)
echo "Installing Rust CLI tools via cargo..."
# Rust CLI Tools (not available in mise registry)
cargo install \
    alacritty \
    bacon \
    bandwhich \
    broot \
    cargo-nextest \
    huniq \
    jaq \
    mcfly \
    ouch \
    procs \
    skim \
    tealdeer \
    xsv
echo "All cargo tools installed successfully!"

# Install Docker
echo "Installing Docker..."
# Install Docker packages
sudo apt-get install -y \
    containerd.io \
    docker-buildx-plugin \
    docker-ce \
    docker-ce-cli \
    docker-compose-plugin
# Configure standard Docker
echo "Configuring standard Docker..."
# Create docker group if it doesn't exist
sudo groupadd -f docker
# Add user to docker group
sudo usermod -aG docker "$USER"
# Configure rootless Docker
echo "Configuring rootless Docker..."
# Install required packages for rootless Docker
sudo apt-get install -y uidmap dbus-user-session fuse-overlayfs
# Configure subuid and subgid for the user
sudo usermod --add-subuids 100000-165535 "$USER"
sudo usermod --add-subgids 100000-165535 "$USER"
# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker
echo "Docker (standard and rootless) configured successfully!"
