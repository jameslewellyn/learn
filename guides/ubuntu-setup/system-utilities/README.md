# System Utilities

Tools for system monitoring, disk management, and system administration.

## Available Tools

### **[Duf](./duf.md)** - Disk Usage/Free Utility
- **Purpose**: Modern replacement for the `df` command with better visualization
- **Key Features**: Colorful output, sorting, filtering, JSON output
- **Use Case**: Disk usage monitoring, system administration, storage analysis
- **Installation**: `sudo apt install duf`

## Quick Start

```bash
# Install duf
sudo apt install duf

# Basic usage
duf

# Show only local filesystems
duf --only local

# Sort by usage
duf --sort usage

# JSON output for scripts
duf --json
```

## Key Features

### **Enhanced Disk Monitoring**
- **Visual**: Colorful, easy-to-read output with progress bars
- **Flexible**: Multiple output formats and sorting options
- **Scriptable**: JSON output for automation and monitoring
- **Filtering**: Show only relevant filesystems

### **System Administration Benefits**
- **Quick Overview**: Instant disk usage visualization
- **Monitoring**: Perfect for system health checks
- **Automation**: JSON output for scripts and alerts
- **Reporting**: Generate disk usage reports

## Configuration Tips

### Useful Aliases
```bash
# Add to ~/.bashrc or ~/.zshrc
alias df='duf'
alias disk='duf --sort usage'
alias diskfull='duf --json | jq -r ".[] | select(.usage_percent > 80) | \"\(.mountpoint): \(.usage_percent)%\""'
```

### Environment Variables
```bash
# Set default theme
export DUF_THEME="dark"

# Set default output format
export DUF_OUTPUT="mountpoint,size,used,avail,usage,type"
```

## Common Use Cases

### System Health Check
```bash
# Quick disk usage overview
duf --only local --sort usage

# Check for high usage filesystems
duf --json | jq -r '.[] | select(.usage_percent > 90) | "\(.mountpoint): \(.usage_percent)%"'
```

### Monitoring Scripts
```bash
#!/bin/bash
# Check disk usage and alert
HIGH_USAGE=$(duf --json | jq -r '.[] | select(.usage_percent > 85) | "\(.mountpoint): \(.usage_percent)%"')

if [ -n "$HIGH_USAGE" ]; then
    echo "High disk usage detected:"
    echo "$HIGH_USAGE"
fi
```

### System Reports
```bash
# Generate disk usage report
duf --output mountpoint,size,used,avail,usage,type > disk-usage-report.txt

# Daily monitoring
duf --only local > /var/log/daily-disk-usage.log
```

## Integration with Other Tools

### Works well with:
- **dust**: For directory-level disk usage analysis
- **bottom**: For complete system monitoring
- **scripts**: For automated monitoring and alerting
- **cron**: For scheduled disk usage checks
- **jq**: For JSON processing and filtering

### Monitoring Stack
```bash
# Complete disk monitoring
duf --only local           # Filesystem overview
dust ~/                    # Directory analysis
bottom                     # System resources
```

## Best Practices

1. **Regular Monitoring**: Include duf in daily system checks
2. **Automation**: Use JSON output for scripts and monitoring
3. **Alerting**: Set up alerts for high disk usage
4. **Documentation**: Include disk usage in system reports
5. **Filtering**: Use filters to focus on relevant filesystems

## Troubleshooting

### Common Issues
- **No output**: Check if filesystems are mounted
- **Colors not working**: Verify terminal color support
- **Permission errors**: Some filesystems may require sudo

### Performance
- **Fast**: Optimized for quick disk usage checking
- **Lightweight**: Minimal resource usage
- **Efficient**: Better performance than traditional df

## Comparison with Traditional Tools

### vs df
```bash
# Traditional df
df -h

# Modern duf
duf
```

**Advantages of duf:**
- Colorful, easy-to-read output
- Better formatting and visualization
- Sorting and filtering options
- JSON output for automation
- More intuitive interface

## Migration from df

### Simple Replacement
```bash
# Replace df with duf
alias df='duf'

# Or use specific variants
alias df='duf --only local'
alias dfall='duf --all'
```

### Script Migration
```bash
# Old df script
df -h | grep -v tmpfs

# New duf script
duf --hide-fs tmpfs
```

---

**Next Steps**: Follow the detailed [duf installation guide](./duf.md) for comprehensive setup instructions, configuration options, and advanced usage examples.