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

# Add Docker repository (modern approach)
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
# Install Docker
echo "Installing Docker..."
# Install Docker packages
sudo apt-get install -y \
    containerd.io \
    docker-buildx-plugin \
    docker-ce \
    docker-ce-cli \
    docker-compose-plugin \
    uidmap \
    dbus-user-session \
    fuse-overlayfs

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

# Configure rootless Docker (only if not already configured)
echo "Configuring rootless Docker..."

# Check if subuid/subgid are already configured
if ! grep -q "$USER:100000:65536" /etc/subuid 2>/dev/null; then
    echo "Configuring subuid and subgid for user..."
    sudo usermod --add-subuids 100000-165535 "$USER"
    sudo usermod --add-subgids 100000-165535 "$USER"
else
    echo "Subuid/subgid already configured for user"
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
