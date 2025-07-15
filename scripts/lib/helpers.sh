#!/bin/bash

# Helper Functions
# Common utility functions used by Ubuntu setup and container setup scripts

# =============================================================================
# PACKAGE MANAGEMENT FUNCTIONS
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

# =============================================================================
# REPOSITORY MANAGEMENT FUNCTIONS
# =============================================================================

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

# =============================================================================
# SYSTEM CONFIGURATION FUNCTIONS
# =============================================================================

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
# SHELL CONFIGURATION FUNCTIONS
# =============================================================================

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