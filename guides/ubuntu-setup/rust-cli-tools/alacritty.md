# Alacritty - Modern Terminal Emulator

Alacritty is a cross-platform, GPU-accelerated terminal emulator written in Rust.

## Installation

```bash
cargo install alacritty
```

## Prerequisites

Ensure you have the necessary system dependencies:

```bash
sudo apt update
sudo apt install -y build-essential cmake pkg-config libfontconfig1-dev libfreetype6-dev libxcb-xfixes0-dev libxkbcommon-dev python3
```

## Basic Setup

### Configuration

```bash
# Create config directory
mkdir -p ~/.config/alacritty

# Create basic configuration file
cat > ~/.config/alacritty/alacritty.yml << 'EOF'
window:
  padding:
    x: 10
    y: 10
  decorations: full
  startup_mode: Windowed

font:
  normal:
    family: "DejaVu Sans Mono"
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
```

### Desktop Integration

```bash
# Create desktop entry
cat > ~/.local/share/applications/alacritty.desktop << 'EOF'
[Desktop Entry]
Type=Application
TryExec=alacritty
Exec=alacritty
Icon=Alacritty
Terminal=false
Categories=System;TerminalEmulator;
Name=Alacritty
GenericName=Terminal
Comment=A cross-platform, GPU-accelerated terminal emulator
StartupWMClass=Alacritty
EOF
```

## Usage Examples

```bash
# Launch Alacritty
alacritty

# Launch with specific command
alacritty -e bash

# Launch with custom config
alacritty --config-file ~/.config/alacritty/custom.yml
```

## Key Features

- GPU-accelerated rendering
- Cross-platform support
- Configurable via YAML
- Vi mode support
- Custom themes and fonts
- Low input latency

## Troubleshooting

- **Font issues**: Install the font family specified in config
- **Performance**: Ensure GPU drivers are properly installed
- **Config errors**: Validate YAML syntax

## Alternative Installation

```bash
# Via package manager (may be older version)
sudo apt install alacritty

# Via snap
sudo snap install alacritty --classic
```