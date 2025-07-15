#!/bin/bash

# Helper Functions
# Common utility functions used by Ubuntu setup and container setup scripts

# =============================================================================
# PACKAGE MANAGEMENT FUNCTIONS
# =============================================================================



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

# =============================================================================
# FONT MANAGEMENT FUNCTIONS
# =============================================================================

# Function to check if a font is installed
is_font_installed() {
    local font_name="$1"
    fc-list | grep -i "$font_name" > /dev/null 2>&1
}

# Function to install NerdFont
install_nerdfont() {
    local font_name="$1"
    local font_url="$2"
    local description="$3"
    
    if is_font_installed "$font_name"; then
        echo "$description is already installed, skipping."
        return 0
    fi
    
    echo "Installing $description..."
    
    # Create temporary directory
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"
    
    # Download and install font
    if curl -L "$font_url" -o font.zip && unzip -q font.zip; then
        # Create font directory for user
        mkdir -p ~/.local/share/fonts
        
        # Copy TTF files
        cp *.ttf ~/.local/share/fonts/ 2>/dev/null || true
        
        # Update font cache
        fc-cache -fv > /dev/null 2>&1
        
        # Clean up
        cd ~
        rm -rf "$temp_dir"
        
        echo "$description installation completed!"
    else
        echo "Failed to install $description"
        cd ~
        rm -rf "$temp_dir"
        return 1
    fi
}

# Function to check if a desktop file is installed
is_desktop_file_installed() {
    local desktop_name="$1"
    local desktop_file="$2"
    
    # Check if desktop file exists in standard locations
    if [ -f "/usr/share/applications/$desktop_file" ] || \
       [ -f "/usr/local/share/applications/$desktop_file" ] || \
       [ -f "$HOME/.local/share/applications/$desktop_file" ]; then
        return 0
    else
        return 1
    fi
}

# Function to install desktop file
install_desktop_file() {
    local desktop_file="$1"
    local source_path="$2"
    local description="$3"
    local icon_file="$4"
    local icon_source_path="$5"
    
    if is_desktop_file_installed "$desktop_file" "$desktop_file"; then
        echo "$description is already installed, skipping."
        return 0
    fi
    
    echo "Installing $description..."
    
    # Create applications directory for user
    mkdir -p ~/.local/share/applications
    
    # Create icons directory for user if icon is provided
    if [ -n "$icon_file" ] && [ -n "$icon_source_path" ]; then
        mkdir -p ~/.local/share/icons/hicolor/256x256/apps
        cp "$icon_source_path" ~/.local/share/icons/hicolor/256x256/apps/"$icon_file" 2>/dev/null || true
    fi
    
    # Copy desktop file
    if cp "$source_path" ~/.local/share/applications/; then
        # Update desktop database
        update-desktop-database ~/.local/share/applications > /dev/null 2>&1 || true

        # Ensure Ubuntu knows about the new desktop file
        if command -v gtk-update-icon-cache >/dev/null 2>&1; then
            gtk-update-icon-cache ~/.local/share/icons/hicolor > /dev/null 2>&1 || true
        fi
        if command -v update-desktop-database >/dev/null 2>&1; then
            update-desktop-database ~/.local/share/applications > /dev/null 2>&1 || true
        fi
        if command -v xdg-desktop-menu >/dev/null 2>&1; then
            xdg-desktop-menu forceupdate > /dev/null 2>&1 || true
        fi
        if command -v xdg-mime >/dev/null 2>&1; then
            xdg-mime default "$desktop_file" x-scheme-handler/terminal > /dev/null 2>&1 || true
        fi

        echo "$description installation completed!"
    else
        echo "Failed to install $description"
        return 1
    fi
} 