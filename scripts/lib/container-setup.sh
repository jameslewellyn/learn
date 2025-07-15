#!/bin/bash

# Container Setup Functions
# Functions for configuring Docker and Podman in Ubuntu development environment

# =============================================================================
# SOURCE DEPENDENCIES
# =============================================================================

# Source helper functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/helpers.sh"

# =============================================================================
# DOCKER CONFIGURATION FUNCTIONS
# =============================================================================

# Function to install Docker components
install_docker_components() {
    echo "Installing Docker components..."
    
    # Add Docker repository
    add_modern_repository_if_missing \
        "docker" \
        "/etc/apt/sources.list.d/docker.list" \
        "https://download.docker.com/linux/ubuntu/gpg" \
        "https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
        "Docker repository"
    
    # Update package lists after adding repository
    echo "Updating package lists..."
    update_package_lists
    
    # Install Docker packages
    docker_pkgs=(
        containerd.io
        docker-buildx-plugin
        docker-ce
        docker-ce-cli
        docker-compose-plugin
    )
    install_packages_if_missing docker_pkgs "Docker packages"
    
    echo "Docker components installation completed!"
}

# Function to configure Docker
configure_docker() {
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
}

# =============================================================================
# CONTAINER TOOLS INSTALLATION
# =============================================================================

# Function to install container tools via mise
install_container_tools() {
    echo "Installing container tools via mise..."
    
    # Activate mise
    eval "$(mise activate bash)"
    
    # Container tools to install
    container_tools=(
        podman               # daemonless container engine
    )
    
    mise use -g "${container_tools[@]}"
    
    echo "Container tools installation completed!"
}

# =============================================================================
# PODMAN CONFIGURATION FUNCTIONS
# =============================================================================

# Function to configure rootless Podman
configure_rootless_podman() {
    echo "Configuring rootless Podman..."
    echo "Starting subuid/subgid configuration for rootless Podman..."
    
    configure_subuid_subgid "subuid" "$USER" "100000-165535" "subuid for user for Podman rootless containers"
    configure_subuid_subgid "subgid" "$USER" "100000-165535" "subgid for user for Podman rootless containers"
    
    echo "Completed subuid/subgid configuration for rootless Podman."
}

# =============================================================================
# MAIN CONTAINER SETUP FUNCTION
# =============================================================================

# Main function to setup all container tools
setup_containers() {
    echo "Setting up container tools..."
    
    # Install Docker components
    install_docker_components
    
    # Install container tools via mise
    install_container_tools
    
    # Configure Docker
    configure_docker
    
    # Configure rootless Podman
    configure_rootless_podman
    
    echo "Container setup completed successfully!"
} 