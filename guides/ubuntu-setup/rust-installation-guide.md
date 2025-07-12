# Rust Installation Guide for Ubuntu

This guide walks you through installing Rust development tools on Ubuntu using `rustup` installed via `apt`.

## Prerequisites

- Ubuntu 18.04 or later
- Terminal access with sudo privileges
- Internet connection

## Step 1: Update Package Lists

First, update your package lists to ensure you have the latest information:

```bash
sudo apt update
```

## Step 2: Install rustup via apt

Install `rustup` using the system package manager:

```bash
sudo apt install rustup
```

## Step 3: Initialize rustup

After installation, initialize rustup for your user:

```bash
rustup default stable
```

This command:
- Downloads and installs the latest stable Rust toolchain
- Installs `rustc` (Rust compiler)
- Installs `cargo` (Rust package manager and build tool)
- Sets up the default toolchain

## Step 4: Add Cargo to PATH

Add Cargo's binary directory to your PATH by adding this line to your shell configuration file:

For bash users (`~/.bashrc`):
```bash
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

For zsh users (`~/.zshrc`):
```bash
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## Step 5: Verify Installation

Verify that everything is installed correctly:

```bash
# Check Rust compiler version
rustc --version

# Check Cargo version
cargo --version

# Check rustup version
rustup --version
```

## Step 6: Install Additional Recommended Tools

### Essential Development Tools

1. **rust-analyzer** (LSP server for IDE support):
```bash
rustup component add rust-analyzer
```

2. **clippy** (Rust linter):
```bash
rustup component add clippy
```

3. **rustfmt** (Code formatter):
```bash
rustup component add rustfmt
```

### Useful Cargo Extensions

Install these popular cargo extensions:

```bash
# Better error messages and suggestions
cargo install cargo-edit

# Security audit tool
cargo install cargo-audit

# Watch for file changes and rebuild
cargo install cargo-watch

# Generate documentation and serve it locally
cargo install cargo-doc

# Profile and benchmark tools
cargo install cargo-flamegraph
cargo install cargo-criterion

# Cross-compilation support
cargo install cross
```

## Step 7: Configure Development Environment

### Set up a basic Rust project structure

Create a new Rust project to test your installation:

```bash
cargo new hello_world
cd hello_world
cargo run
```

### Configure Git (if not already done)

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## Recommended Next Steps

### 1. Learn the Basics
- Read the [Rust Book](https://doc.rust-lang.org/book/) (also available offline with `rustup doc --book`)
- Complete [Rustlings](https://github.com/rust-lang/rustlings) exercises
- Try [Rust by Example](https://doc.rust-lang.org/rust-by-example/)

### 2. Set Up Your Editor/IDE

Popular choices with excellent Rust support:
- **VS Code** with the `rust-analyzer` extension
- **IntelliJ IDEA** with the Rust plugin
- **Vim/Neovim** with rust-analyzer LSP
- **Emacs** with rust-analyzer LSP

### 3. Keep Your Toolchain Updated

Regularly update your Rust installation:

```bash
# Update rustup itself
rustup self update

# Update all installed toolchains
rustup update

# Update installed cargo packages
cargo install-update -a  # requires cargo-update
```

### 4. Explore the Ecosystem

- Browse crates on [crates.io](https://crates.io/)
- Check out [Awesome Rust](https://github.com/rust-unofficial/awesome-rust)
- Join the [Rust community](https://www.rust-lang.org/community)

### 5. Additional Toolchains

You might want to install additional toolchains for specific needs:

```bash
# Install nightly toolchain (for experimental features)
rustup toolchain install nightly

# Install beta toolchain
rustup toolchain install beta

# Switch between toolchains
rustup default stable
rustup default nightly
```

## Troubleshooting

### Common Issues

1. **PATH not updated**: Restart your terminal or run `source ~/.bashrc`
2. **Permission issues**: Make sure you didn't use `sudo` when running rustup commands
3. **Network issues**: If downloads fail, try again later or check your internet connection

### Useful Commands

```bash
# Show installed toolchains
rustup toolchain list

# Show installed components
rustup component list --installed

# Show rustup configuration
rustup show

# Get help
rustup help
cargo help
```

## Alternative Installation Methods

While this guide uses `apt` to install rustup, you can also:

1. **Official installer** (recommended by Rust team):
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

2. **Snap package**:
```bash
sudo snap install rustup --classic
```

The `apt` method is convenient for system-wide management, but the official installer gives you the most up-to-date version and better integration with rustup's self-update mechanism.

---

**Happy Rust coding!** 🦀