#!/bin/bash

# GUI Tools Setup Functions
# Functions for installing and configuring GUI tools in Ubuntu development environment

# =============================================================================
# SOURCE DEPENDENCIES
# =============================================================================

# Source helper functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/helpers.sh"

# =============================================================================
# GUI TOOLS INSTALLATION
# =============================================================================

# Function to install GUI tools via mise
install_gui_tools() {
    echo "Installing GUI tools via mise..."
    
    # Activate mise
    eval "$(mise activate bash)"
    
    # GUI tools to install
    gui_tools=(
        cargo:alacritty      # GPU-accelerated terminal emulator
    )
    
    mise use -g "${gui_tools[@]}"
    
    echo "GUI tools installation completed!"
}

# =============================================================================
# GUI TOOLS CONFIGURATION
# =============================================================================

# Function to configure GUI tools
configure_gui_tools() {
    echo "Configuring GUI tools..."
    
    # Create configuration directories
    mkdir -p ~/.config/alacritty
    
    # Install Alacritty desktop file
    # Create a symlink to the alacritty binary for desktop file (mise shims)
    ln -s /home/user/.local/share/mise/shims/alacritty ~/.local/bin/alacritty
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    install_desktop_file \
        "alacritty.desktop" \
        "$SCRIPT_DIR/desktop-files/alacritty.desktop" \
        "Alacritty desktop file" \
        "alacritty.png" \
        "$SCRIPT_DIR/desktop-files/alacritty.png"
    
    echo "GUI tools configuration completed!"
}

# =============================================================================
# MAIN GUI SETUP FUNCTION
# =============================================================================

# Main function to setup all GUI tools
setup_gui_tools() {
    echo "Setting up GUI tools..."
    
    # Install GUI tools via mise
    install_gui_tools
    
    # Configure GUI tools
    configure_gui_tools
    
    echo "GUI tools setup completed successfully!"
} 