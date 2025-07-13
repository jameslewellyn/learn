# Shell Productivity Tools

Tools that enhance command-line productivity and shell experience.

## Available Tools

### **[FZF](./fzf.md)** - Fuzzy Finder
- **Purpose**: Interactive filtering for any list of items
- **Key Features**: Universal fuzzy matching, shell integration, customizable
- **Use Case**: File navigation, command history, general filtering
- **Installation**: `sudo apt install fzf`

### **[McFly](./mcfly.md)** - Intelligent Command History
- **Purpose**: Neural network-powered command history search
- **Key Features**: Contextual results, machine learning, directory-aware
- **Use Case**: Smart command history search and suggestion
- **Installation**: `cargo install mcfly`

## Quick Start

```bash
# Install both tools
sudo apt install fzf
cargo install mcfly

# Basic shell integration
echo 'eval "$(mcfly init bash)"' >> ~/.bashrc
source /usr/share/doc/fzf/examples/key-bindings.bash
```

## Tool Synergy

These tools work excellently together:

### **FZF + McFly = Enhanced Shell Experience**
- **FZF**: Provides fuzzy finding for files, processes, and general lists
- **McFly**: Provides intelligent command history search with context awareness
- **Together**: Complete shell productivity enhancement

### **Integration Examples**

```bash
# FZF for file finding
find . -type f | fzf

# McFly for command history (Ctrl+R)
# Automatically provides contextual command suggestions

# Combined workflow
# 1. Use McFly to find previously used commands
# 2. Use FZF to select files for those commands
# 3. Enhanced productivity with both tools active
```

## Key Benefits

1. **Reduced Typing**: Both tools minimize the need to type full commands/paths
2. **Context Awareness**: McFly learns your patterns, FZF adapts to your workflow
3. **Speed**: Both tools are optimized for fast, real-time filtering
4. **Customization**: Extensive configuration options for both tools
5. **Shell Integration**: Seamless integration with bash, zsh, and fish

## Configuration Tips

### Shell Integration
```bash
# Add to ~/.bashrc or ~/.zshrc
eval "$(mcfly init bash)"
source /usr/share/doc/fzf/examples/key-bindings.bash
source /usr/share/doc/fzf/examples/completion.bash

# Environment variables
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"
export MCFLY_FUZZY=true
export MCFLY_RESULTS=50
```

### Key Bindings
- **Ctrl+R**: McFly command history search
- **Ctrl+T**: FZF file finder
- **Alt+C**: FZF directory navigation

## Best Practices

1. **Start with defaults**: Both tools work great out of the box
2. **Customize gradually**: Add configuration as you discover preferences
3. **Use together**: Leverage the complementary nature of both tools
4. **Regular updates**: Keep both tools updated for latest features
5. **Backup configuration**: Save your shell configurations

## Troubleshooting

### Common Issues
- **Key bindings not working**: Check shell integration
- **Performance issues**: Adjust result limits and fuzzy matching settings
- **Compatibility**: Ensure both tools are compatible with your shell

### Resources
- Individual tool guides contain detailed troubleshooting
- Both tools have active communities and documentation
- Configuration examples available in respective guides

## Integration with Other Tools

These shell productivity tools enhance:
- **Git workflows**: Better branch selection and command history
- **File management**: Enhanced navigation and file operations
- **Development**: Faster project navigation and command execution
- **System administration**: Efficient command recall and file finding

---

**Next Steps**: Choose the tools that match your workflow and follow their individual installation guides for detailed setup instructions.