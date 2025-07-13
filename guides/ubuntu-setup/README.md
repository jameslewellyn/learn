# Ubuntu Setup Guides

Comprehensive collection of installation and setup guides for modern command-line tools and development environments on Ubuntu.

## 📋 Quick Navigation

### Core Setup Guides
- **[Rust Installation Guide](./rust-installation-guide.md)** - Install Rust toolchain via rustup
- **[Git Latest PPA Guide](./git-latest-ppa-guide.md)** - Get latest Git via PPA
- **[NerdFont Installation Guide](./nerdfont-installation-guide.md)** - Install NerdFonts for terminal icons
- **[Lazygit Installation Guide](./lazygit-installation-guide.md)** - Terminal-based Git UI

### CLI Tools Collection
- **[Rust CLI Tools Guide](./rust-cli-tools-guide.md)** - Comprehensive guide with 25+ tools
- **[Individual Tool Guides](./rust-cli-tools/)** - Detailed guides for each tool
- **[Recommended Additional Tools](./recommended-additional-cli-tools.md)** - 30+ more tools to consider
- **[CLI Tools Comparison](./cli-tools-comparison.md)** - Current vs recommended tools matrix

## 🚀 Getting Started

### Quick Setup (30 minutes)
For a minimal productive environment:

```bash
# 1. Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env

# 2. Install essential tools
sudo apt update
sudo apt install -y git fzf gh duf tree rsync htop build-essential

# 3. Install core Rust CLI tools
cargo install ripgrep fd-find bat starship zoxide lsd just xsv

# 4. Install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit lazygit.tar.gz
```

### Complete Setup (2-3 hours)
Follow all guides for a comprehensive development environment.

## 📚 Tool Categories

### File Management & Navigation (7 tools)
- **alacritty** - Modern terminal emulator
- **lsd** - Modern `ls` with colors and icons
- **fd** - Fast `find` alternative
- **dust** - Visual `du` alternative
- **zoxide** - Smart `cd` that learns
- **broot** - Interactive tree navigation
- **fzf** - Fuzzy finder (recommended addition)

### Text Processing & Search (6 tools)
- **ripgrep** - Extremely fast grep
- **sd** - Intuitive find & replace
- **bat** - `cat` with syntax highlighting
- **delta** - Beautiful git diff viewer
- **tealdeer** - Fast tldr client
- **xsv** - CSV toolkit (recommended addition)

### System Monitoring (4 tools)
- **bandwhich** - Network monitor
- **bottom** - System monitor
- **procs** - Modern process viewer
- **hyperfine** - Benchmarking tool

### Development Tools (6 tools)
- **tokei** - Code statistics
- **bacon** - Background code checker
- **cargo-nextest** - Test runner
- **lazygit** - Terminal Git UI
- **gh** - GitHub CLI (recommended addition)
- **just** - Command runner (recommended addition)

### Terminal Enhancement (2 tools)
- **starship** - Cross-shell prompt
- **zellij** - Terminal multiplexer

### Data Processing (5 tools)
- **jaq** - JSON processor
- **watchexec** - File watcher
- **choose** - Field selector
- **huniq** - Remove duplicates
- **ouch** - Archive extractor

## 🎯 Installation Strategies

### By Experience Level

#### Beginner (Start Here)
1. [Rust Installation](./rust-installation-guide.md)
2. [NerdFont Installation](./nerdfont-installation-guide.md)
3. Essential tools: `ripgrep`, `bat`, `lsd`, `starship`
4. [Lazygit](./lazygit-installation-guide.md)

#### Intermediate
1. Complete the beginner setup
2. Add productivity tools: `zoxide`, `fzf`, `fd`, `dust`
3. Git workflow: `delta`, `gh`
4. Terminal enhancement: `alacritty`, `zellij`

#### Advanced
1. Complete intermediate setup
2. Development tools: `tokei`, `bacon`, `just`, `watchexec`
3. System monitoring: `bottom`, `bandwhich`, `procs`
4. Data processing: `jaq`, `xsv`, `choose`

### By Use Case

#### Software Developer
**Core:** Rust, Git latest, lazygit, delta, starship, gh, just, bacon, tokei, watchexec
**Extras:** NerdFont, alacritty, zellij, ripgrep, bat, fd

#### System Administrator
**Core:** bottom, procs, bandwhich, hyperfine, dust, duf, htop, mtr, nmap
**Extras:** stress, iotop, rsync, age

#### Data Analyst
**Core:** ripgrep, jaq, xsv, choose, huniq, miller, fx, bat
**Extras:** sd, pandoc, glow

#### Content Creator
**Core:** bat, glow, pandoc, ffmpeg, imagemagick, exiftool
**Extras:** ouch, rsync, rclone

## 🔄 Maintenance

### Update All Tools
```bash
# Update Rust toolchain
rustup update

# Update Rust-installed tools
cargo install-update -a

# Update system packages
sudo apt update && sudo apt upgrade

# Update specific tools
tldr --update
gh extension upgrade --all
```

### Backup Configurations
```bash
# Backup all tool configurations
tar -czf ~/cli-tools-backup.tar.gz \
  ~/.config/starship.toml \
  ~/.config/alacritty/ \
  ~/.config/zellij/ \
  ~/.config/lazygit/ \
  ~/.gitconfig
```

## 🔗 Integration Examples

### Shell Integration
Most tools integrate with your shell for enhanced functionality:

```bash
# Add to ~/.bashrc or ~/.zshrc
eval "$(starship init bash)"      # Beautiful prompt
eval "$(zoxide init bash)"        # Smart cd
source <(gh completion bash)      # GitHub CLI completion
```

### Tool Combinations
- `rg` + `fzf` = Powerful search interface
- `bat` + `fd` = Enhanced file exploration
- `lazygit` + `delta` + `gh` = Complete Git workflow
- `starship` + `zoxide` + `fzf` = Enhanced shell experience

## 🛠️ Troubleshooting

### Common Issues
- **Cargo install fails**: Install build dependencies
- **Tools not in PATH**: Add `~/.cargo/bin` to PATH
- **Permission errors**: Never use `sudo` with cargo
- **Font issues**: Install and configure NerdFonts
- **Performance**: Compile with `--release` flag when needed

### Getting Help
- Check individual tool guides for specific issues
- Use `tldr <tool-name>` for quick examples
- Visit tool repositories for detailed documentation
- Community forums and GitHub issues

## 📈 Performance Impact

### Startup Time
Most tools are designed for speed:
- **Fastest**: ripgrep, fd, bat, starship
- **Medium**: bottom, procs, zoxide
- **Slower**: alacritty startup, tokei on large codebases

### Resource Usage
- **Minimal**: Most text processing tools
- **Moderate**: Terminal emulators, system monitors
- **Higher**: Development tools during compilation

## 🤝 Contributing

These guides are maintained as living documents. Improvements welcome:
- Tool version updates
- Configuration enhancements
- New tool recommendations
- Bug fixes and clarifications

## 📄 License

These guides are provided for educational and practical use. Individual tools have their own licenses - check their repositories for details.

---

## 📊 Quick Stats

- **Total Documented Tools**: 25+ core + 30+ recommended
- **Categories Covered**: 10+ categories
- **Installation Time**: 30 minutes (minimal) to 3 hours (complete)
- **Maintenance**: Monthly updates recommended
- **Platform**: Ubuntu 20.04+ (most work on other Linux distributions)

**Happy command-line productivity!** 🚀

For questions or suggestions, check the individual guides or create an issue in the repository.