#!/bin/bash

# Ubuntu 25.04 Development Environment Setup Script
# Installs and configures only tools with guides in the guides/ directory
# Uses mise as the primary tool manager, with fallbacks only for tools not supported by mise
# Designed for minimal Ubuntu installations and Docker containers

#set -x
set -euo pipefail

# =============================================================================
# SCRIPT PARAMETERS
# =============================================================================

# Parse command line arguments
SETUP_CONTAINERS=false
SETUP_GUI_TOOLS=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --containers)
            SETUP_CONTAINERS=true
            shift
            ;;
        --gui-tools)
            SETUP_GUI_TOOLS=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --containers    Install and configure Docker and Podman"
            echo "  --gui-tools     Install and configure GUI tools (Alacritty)"
            echo "  -h, --help      Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use -h or --help for usage information"
            exit 1
            ;;
    esac
done

# =============================================================================
# SOURCE DEPENDENCIES
# =============================================================================

# Source helper functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/helpers.sh"

# Source container setup functions if container setup is requested
if [ "$SETUP_CONTAINERS" = true ]; then
    source "$SCRIPT_DIR/lib/container-setup.sh"
    fi

# Source GUI tools setup functions if GUI tools setup is requested
if [ "$SETUP_GUI_TOOLS" = true ]; then
    source "$SCRIPT_DIR/lib/gui-tools-setup.sh"
    fi

# =============================================================================
# MAIN SCRIPT
# =============================================================================

# Update package lists
sudo apt-get update

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



# Step 5: Update package lists after adding all PPAs
sudo apt-get update

# Step 6: Install all remaining essential packages
essential_pkgs=(
    build-essential
    clang
    dbus-user-session
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

# Step 7: Install NerdFont for better CLI tool experience
echo "Installing Hack Nerd Font for enhanced CLI tool experience..."
install_nerdfont \
    "Hack" \
    "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.zip" \
    "Hack Nerd Font"

# Step 8: Install rust and associated programs
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
# Mise activation (tool manager)
add_to_bashrc_if_missing 'eval "$(mise activate bash)"' "mise activation"

# Prompt and shell enhancements
add_to_bashrc_if_missing 'eval "$(starship init bash)"' "starship initialization"
starship preset nerd-font-symbols -o ~/.config/starship.toml

# Create configuration directory for zoxide
mkdir -p ~/.config/zoxide

# File and directory listing
add_to_bashrc_if_missing "alias ls='lsd -l --group-dirs=first --color=always'" "lsd alias"

# File viewing (bat)
add_to_bashrc_if_missing "alias cat='bat'" "bat cat alias"
add_to_bashrc_if_missing "alias less='bat'" "bat less alias"

# Terminal multiplexer (zellij)
add_to_bashrc_if_missing "alias zj=\"zellij attach --create main\"" "zellij attach alias"
add_to_bashrc_if_missing "alias zr=\"zellij kill-all-sessions; zellij delete-all-sessions\"" "zellij reset alias"

# Git client
add_to_bashrc_if_missing "alias lg=\"lazygit\"" "lazygit alias"
add_to_bashrc_if_missing 'eval "$(mcfly init bash)"' "mcfly initialization"

# Directory navigation (zoxide)
add_to_bashrc_if_missing 'eval "$(zoxide init bash)"' "zoxide initialization"
add_to_bashrc_if_missing "alias cd=\"z\"" "zoxide cd alias"
add_to_bashrc_if_missing "alias cdi=\"zi\"" "zoxide interactive alias"

echo "All mise tools installed successfully!"

# Setup containers if requested
if [ "$SETUP_CONTAINERS" = true ]; then
    setup_containers
fi

# Setup GUI tools if requested
if [ "$SETUP_GUI_TOOLS" = true ]; then
    setup_gui_tools
fi

echo
echo "Setup completed successfully!"
