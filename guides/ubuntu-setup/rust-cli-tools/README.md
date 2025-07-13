# Rust CLI Tools Installation Guides

This directory contains comprehensive installation and setup guides for modern Rust-based command-line tools. Each tool has its own dedicated guide with installation instructions, configuration, and usage examples.

## Available Tools

### File Management & Navigation
- **[Alacritty](./alacritty.md)** - Modern terminal emulator with GPU acceleration
- **[LSD](./lsd.md)** - Modern `ls` alternative with colors and icons
- **[FD](./fd.md)** - Modern `find` alternative with intuitive syntax
- **[Dust](./dust.md)** - Modern `du` alternative with tree visualization
- **[Zoxide](./zoxide.md)** - Smart `cd` that learns your habits
- **[Broot](./broot.md)** - Interactive tree navigation and file management

### Text Processing & Search
- **[Ripgrep](./ripgrep.md)** - Extremely fast grep alternative
- **[SD](./sd.md)** - Intuitive find & replace CLI (sed alternative)
- **[Bat](./bat.md)** - `cat` with syntax highlighting and Git integration
- **[Delta](./delta.md)** - Beautiful git diff viewer
- **[Tealdeer](./tealdeer.md)** - Fast tldr client for command examples

### System Monitoring & Analysis
- **[Bandwhich](./bandwhich.md)** - Network utilization monitor
- **[Bottom](./bottom.md)** - System monitor (htop alternative)
- **[Procs](./procs.md)** - Modern process monitor (ps alternative)
- **[Hyperfine](./hyperfine.md)** - Command-line benchmarking tool

### Development Tools
- **[Tokei](./tokei.md)** - Code statistics and analysis
- **[Bacon](./bacon.md)** - Background code checker for Rust
- **[Cargo-nextest](./cargo-nextest.md)** - Next-generation test runner

### Terminal Enhancement
- **[Starship](./starship.md)** - Cross-shell prompt customization
- **[Zellij](./zellij.md)** - Terminal multiplexer (tmux alternative)

### Data Processing & Utilities
- **[Jaq](./jaq.md)** - JSON processor (jq alternative)
- **[Watchexec](./watchexec.md)** - File watcher that runs commands
- **[Choose](./choose.md)** - Field selector (cut/awk alternative)
- **[Huniq](./huniq.md)** - Remove duplicate lines while preserving order
- **[Ouch](./ouch.md)** - Universal archive extractor and compressor

## Quick Start

### Prerequisites

First, ensure you have Rust installed:
```bash
# Install Rust (if not already installed)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
```

### System Dependencies

Install required system dependencies:
```bash
sudo apt update
sudo apt install -y build-essential cmake pkg-config libfontconfig1-dev libfreetype6-dev libxcb-xfixes0-dev libxkbcommon-dev python3 libssl-dev libpcap-dev
```

### Install All Tools

You can install all tools at once (this will take significant time):
```bash
cargo install alacritty lsd ripgrep fd-find sd bandwhich du-dust tealdeer starship bat git-delta zoxide broot ouch bottom procs hyperfine tokei bacon cargo-nextest zellij jaq watchexec-cli choose huniq

# Initialize tools that need setup
broot --install
tldr --update
```

### Individual Installation

For better control, install tools individually by following their specific guides.

## Tool Categories

### Essential Daily Tools
Start with these tools for immediate productivity boost:
- **Zoxide** - Smart directory navigation
- **Ripgrep** - Fast search
- **Bat** - Enhanced file viewing
- **LSD** - Better file listing
- **Starship** - Beautiful prompt

### Development Workflow
For developers, these tools are particularly valuable:
- **Delta** - Git diff visualization
- **Tokei** - Code statistics
- **Bacon** - Background code checking
- **Watchexec** - File watching
- **Zellij** - Terminal multiplexing

### System Administration
For system administration tasks:
- **Bottom** - System monitoring
- **Procs** - Process monitoring
- **Dust** - Disk usage analysis
- **Bandwhich** - Network monitoring
- **Hyperfine** - Performance benchmarking

### Text Processing
For text manipulation and processing:
- **SD** - Find and replace
- **Jaq** - JSON processing
- **Choose** - Field selection
- **Huniq** - Duplicate removal
- **Tealdeer** - Quick command help

## Configuration

Each tool has its own configuration directory under `~/.config/`. After installation, you can customize:

- Themes and colors
- Default behavior
- Shell integration
- Keyboard shortcuts
- Output formats

## Update Script

Create a script to update all tools:
```bash
cat > ~/update-rust-tools.sh << 'EOF'
#!/bin/bash
echo "Updating Rust toolchain..."
rustup update

echo "Updating cargo-installed tools..."
cargo install-update -a

echo "Updating tealdeer cache..."
tldr --update

echo "Updating broot configuration..."
broot --install

echo "All tools updated!"
EOF

chmod +x ~/update-rust-tools.sh
```

## Alternative Installation Methods

While these guides focus on `cargo install`, most tools are also available via:
- System package managers (`apt`, `dnf`, etc.)
- Snap packages
- Precompiled binaries from GitHub releases
- Distribution-specific packages

## Troubleshooting

### Common Issues
- **Compilation errors**: Ensure all system dependencies are installed
- **Permission issues**: Never use `sudo` with `cargo install`
- **PATH issues**: Ensure `~/.cargo/bin` is in your PATH
- **Missing dependencies**: Install system packages as needed

### Performance
- Tools may take time to compile from source
- Consider installing in batches to manage system resources
- Use `--locked` flag for reproducible builds when specified

## Contributing

These guides are living documents. If you find improvements or have suggestions:
1. Check the main repository for updates
2. Report issues or suggest improvements
3. Share your custom configurations

## License

These guides are provided as-is for educational and practical use. Each tool has its own license - check individual project repositories for details.

---

**Happy command-line productivity!** 🚀

For the main Rust installation guide, see: [rust-installation-guide.md](../rust-installation-guide.md)