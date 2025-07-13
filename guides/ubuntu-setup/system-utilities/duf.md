# Duf - Disk Usage/Free Utility Installation and Setup Guide

A better alternative to `df` with a user-friendly output and additional features.

## What is Duf?

**Duf** (Disk Usage/Free) is a modern replacement for the traditional `df` command. It provides a colorful, user-friendly overview of disk usage with additional features like sorting, filtering, and JSON output. Written in Go, it's fast, cross-platform, and provides more intuitive information about your storage devices.

## Key Features

- **Colorful output**: Easy-to-read colored display
- **User-friendly**: Human-readable sizes and percentages
- **Multiple filesystems**: Shows all mounted filesystems
- **Sorting options**: Sort by various criteria
- **Filtering**: Show only specific filesystem types
- **JSON output**: Machine-readable output for scripts
- **Themes**: Multiple color themes available
- **Performance**: Fast and lightweight

## Installation

### Method 1: APT (Ubuntu 22.04+)
```bash
sudo apt update
sudo apt install duf
```

### Method 2: Snap Package
```bash
sudo snap install duf-utility
```

### Method 3: Manual Binary Download
```bash
# Download latest release
curl -LO "https://github.com/muesli/duf/releases/latest/download/duf_0.8.1_linux_amd64.deb"
sudo dpkg -i duf_0.8.1_linux_amd64.deb
rm duf_0.8.1_linux_amd64.deb
```

### Method 4: From Source (Go required)
```bash
go install github.com/muesli/duf@latest
```

## Basic Usage

### Display All Filesystems
```bash
# Show all mounted filesystems
duf

# Show only local filesystems (default)
duf --only local

# Show all filesystems including special ones
duf --all
```

### Human-Readable Output
```bash
# Default output (human-readable)
duf

# Show exact byte values
duf --output mountpoint,size,used,avail,usage,type
```

### Sorting Options
```bash
# Sort by size (largest first)
duf --sort size

# Sort by usage percentage
duf --sort usage

# Sort by available space
duf --sort avail

# Sort by filesystem type
duf --sort type

# Sort by mountpoint
duf --sort mountpoint
```

## Advanced Usage

### Filtering Filesystems

#### By Filesystem Type
```bash
# Show only ext4 filesystems
duf --only-fs ext4

# Show only tmpfs filesystems
duf --only-fs tmpfs

# Show multiple filesystem types
duf --only-fs ext4,xfs,btrfs

# Hide specific filesystem types
duf --hide-fs tmpfs,squashfs
```

#### By Mountpoint
```bash
# Show only specific mountpoints
duf --only /home,/var

# Hide specific mountpoints
duf --hide /snap,/dev
```

### Output Formats

#### JSON Output
```bash
# Machine-readable JSON output
duf --json

# Pretty-printed JSON
duf --json | jq '.'

# Extract specific information
duf --json | jq '.[] | select(.filesystem == "ext4") | {mountpoint, usage}'
```

#### Custom Output Columns
```bash
# Show specific columns
duf --output mountpoint,size,used,avail,usage

# Available columns:
# mountpoint, size, used, avail, usage, inodes, inodes_used, inodes_avail, inodes_usage, type, filesystem
```

### Theming and Colors

#### Available Themes
```bash
# Default theme
duf

# Dark theme
duf --theme dark

# Light theme
duf --theme light

# ANSI theme (basic colors)
duf --theme ansi
```

#### Disable Colors
```bash
# Disable all colors
duf --no-color

# Suitable for piping to other commands
duf --no-color | grep "/"
```

## Configuration

### Environment Variables
```bash
# Add to ~/.bashrc or ~/.zshrc
export DUF_THEME="dark"
export DUF_OUTPUT="mountpoint,size,used,avail,usage,type"
```

### Aliases and Functions
```bash
# Add to ~/.bashrc or ~/.zshrc
alias df='duf'
alias duf-local='duf --only local'
alias duf-all='duf --all'
alias duf-json='duf --json'
alias duf-sort-size='duf --sort size'
alias duf-sort-usage='duf --sort usage'

# Function to show only high usage filesystems
duf-high-usage() {
    duf --json | jq -r '.[] | select(.usage_percent > 80) | "\(.mountpoint): \(.usage_percent)%"'
}

# Function to show filesystem summary
duf-summary() {
    echo "Filesystem Summary:"
    duf --json | jq -r 'group_by(.filesystem) | .[] | "\(.[0].filesystem): \(length) filesystem(s)"'
}
```

## Integration with Other Tools

### Shell Scripts
```bash
#!/bin/bash
# Check disk usage and alert if high
HIGH_USAGE_THRESHOLD=90

duf --json | jq -r --arg threshold "$HIGH_USAGE_THRESHOLD" '
    .[] | 
    select(.usage_percent > ($threshold | tonumber)) | 
    "\(.mountpoint) is \(.usage_percent)% full"
' | while read -r line; do
    echo "WARNING: $line"
done
```

### System Monitoring
```bash
#!/bin/bash
# System monitoring script
echo "=== Disk Usage Report ==="
echo "Date: $(date)"
echo

# Show all local filesystems
duf --only local

echo
echo "=== High Usage Filesystems ==="
duf --json | jq -r '.[] | select(.usage_percent > 80) | "\(.mountpoint): \(.usage_percent)%"'

echo
echo "=== Filesystem Types ==="
duf --json | jq -r 'group_by(.filesystem) | .[] | "\(.[0].filesystem): \(length) filesystem(s)"'
```

### Cron Jobs
```bash
# Add to crontab (crontab -e)
# Check disk usage every hour and log warnings
0 * * * * /usr/local/bin/duf --json | jq -r '.[] | select(.usage_percent > 90) | "\(.mountpoint): \(.usage_percent)%"' | while read line; do logger "High disk usage: $line"; done

# Daily disk usage report
0 6 * * * /usr/local/bin/duf --only local > /var/log/daily-disk-usage.log
```

## Comparison with Traditional Tools

### df vs duf
```bash
# Traditional df command
df -h

# Equivalent duf command
duf

# df with specific filesystem types
df -h -t ext4

# duf equivalent
duf --only-fs ext4
```

### Output Comparison
```bash
# df output (example):
# Filesystem      Size  Used Avail Use% Mounted on
# /dev/sda1        20G   15G  4.2G  79% /

# duf output (example):
# ┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
# │ 1 local device                                                                                     │
# ├─────────────────────┬────────┬─────────┬────────┬─────────────────────────────────────┬──────────┤
# │ MOUNTED ON          │   SIZE │    USED │  AVAIL │                  USE%               │ TYPE     │
# ├─────────────────────┼────────┼─────────┼────────┼─────────────────────────────────────┼──────────┤
# │ /                   │   20G  │    15G  │   4.2G │ [████████████████████████████████   ] 79%      │ ext4     │
# └─────────────────────┴────────┴─────────┴────────┴─────────────────────────────────────┴──────────┘
```

## Advanced Features

### Monitoring Scripts

#### Disk Usage Alert Script
```bash
#!/bin/bash
# /usr/local/bin/disk-usage-alert.sh

THRESHOLD=85
EMAIL="admin@example.com"

# Check for high disk usage
HIGH_USAGE=$(duf --json | jq -r --arg threshold "$THRESHOLD" '
    .[] | 
    select(.usage_percent > ($threshold | tonumber)) | 
    "\(.mountpoint) is \(.usage_percent)% full (Size: \(.size_bytes / 1024 / 1024 / 1024 | round)GB)"
')

if [ -n "$HIGH_USAGE" ]; then
    echo "High disk usage detected:"
    echo "$HIGH_USAGE"
    
    # Send email alert (if mail is configured)
    if command -v mail &> /dev/null; then
        echo "$HIGH_USAGE" | mail -s "High Disk Usage Alert" "$EMAIL"
    fi
fi
```

#### Disk Growth Tracking
```bash
#!/bin/bash
# /usr/local/bin/disk-growth-tracker.sh

LOGFILE="/var/log/disk-growth.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Log current disk usage
echo "[$TIMESTAMP]" >> "$LOGFILE"
duf --json | jq -r '.[] | "\(.mountpoint): \(.usage_percent)% (\(.used_bytes / 1024 / 1024 / 1024 | round)GB used)"' >> "$LOGFILE"
echo "" >> "$LOGFILE"

# Analyze growth (compare with previous day)
if [ -f "$LOGFILE.yesterday" ]; then
    echo "Growth analysis:" >> "$LOGFILE"
    # Implementation depends on specific requirements
fi
```

### Performance Monitoring Integration

#### With Prometheus/Grafana
```bash
#!/bin/bash
# Export duf metrics for Prometheus
# /usr/local/bin/duf-prometheus-exporter.sh

echo "# HELP disk_usage_percent Disk usage percentage"
echo "# TYPE disk_usage_percent gauge"

duf --json | jq -r '.[] | "disk_usage_percent{mountpoint=\"\(.mountpoint)\",filesystem=\"\(.filesystem)\"} \(.usage_percent)"'

echo "# HELP disk_size_bytes Total disk size in bytes"
echo "# TYPE disk_size_bytes gauge"

duf --json | jq -r '.[] | "disk_size_bytes{mountpoint=\"\(.mountpoint)\",filesystem=\"\(.filesystem)\"} \(.size_bytes)"'
```

#### With Nagios/Icinga
```bash
#!/bin/bash
# Nagios plugin for disk usage monitoring
# /usr/local/libexec/check_disk_usage.sh

WARNING_THRESHOLD=80
CRITICAL_THRESHOLD=90

# Get highest usage percentage
MAX_USAGE=$(duf --json | jq -r 'max_by(.usage_percent).usage_percent')
MAX_USAGE_MOUNT=$(duf --json | jq -r 'max_by(.usage_percent).mountpoint')

if (( $(echo "$MAX_USAGE > $CRITICAL_THRESHOLD" | bc -l) )); then
    echo "CRITICAL: $MAX_USAGE_MOUNT is ${MAX_USAGE}% full"
    exit 2
elif (( $(echo "$MAX_USAGE > $WARNING_THRESHOLD" | bc -l) )); then
    echo "WARNING: $MAX_USAGE_MOUNT is ${MAX_USAGE}% full"
    exit 1
else
    echo "OK: All filesystems below ${WARNING_THRESHOLD}%"
    exit 0
fi
```

## Troubleshooting

### Common Issues

#### Command Not Found
```bash
# Check if duf is installed
which duf

# Check PATH
echo $PATH

# Install if missing
sudo apt install duf
```

#### No Output or Empty Results
```bash
# Check for mounted filesystems
mount | grep -E "(ext4|xfs|btrfs)"

# Show all filesystems including special ones
duf --all

# Check for permission issues
sudo duf
```

#### Incorrect Colors or Formatting
```bash
# Check terminal support for colors
echo $TERM

# Disable colors if terminal doesn't support them
duf --no-color

# Try different theme
duf --theme ansi
```

### Performance Issues
```bash
# If duf is slow, check for:
# - Network filesystems that might be unresponsive
# - Large number of mounted filesystems

# Show only local filesystems
duf --only local

# Hide problematic filesystem types
duf --hide-fs nfs,cifs
```

## Use Cases

### System Administration
```bash
# Quick system health check
duf --only local --sort usage

# Check specific critical filesystems
duf --only /,/var,/home

# Generate report for documentation
duf --output mountpoint,size,used,avail,usage,type > disk-usage-report.txt
```

### DevOps and Monitoring
```bash
# CI/CD pipeline disk check
if duf --json | jq -e '.[] | select(.usage_percent > 85)' > /dev/null; then
    echo "Disk usage too high for deployment"
    exit 1
fi

# Container monitoring
duf --only-fs overlay,aufs

# Log aggregation
duf --json | jq -r '.[] | select(.mountpoint | startswith("/var/log")) | "\(.mountpoint): \(.usage_percent)%"'
```

### Development Environments
```bash
# Check project directories
duf --only /home,/var,/tmp

# Monitor build directories
duf --only /var/lib/docker

# Development workflow integration
alias check-space='duf --only local --sort usage'
```

## Best Practices

1. **Regular monitoring**: Use in scripts for automated monitoring
2. **Threshold alerts**: Set up alerts for high usage
3. **Filtering**: Use filters to focus on relevant filesystems
4. **JSON output**: Use JSON for scripting and automation
5. **Integration**: Combine with other monitoring tools
6. **Documentation**: Include in system documentation

## Security Considerations

- Duf shows system information that might be sensitive
- Use appropriate permissions for monitoring scripts
- Consider hiding sensitive mountpoints in shared environments
- Regular updates to maintain security

## Integration with Your Toolkit

Duf pairs excellently with:
- **dust**: For directory-level disk usage analysis
- **bottom**: For system monitoring
- **jq**: For JSON processing and filtering
- **scripts**: For automated monitoring and alerting
- **cron**: For scheduled disk usage checks

## Updates and Maintenance

### Update Duf
```bash
# If installed via apt
sudo apt update && sudo apt upgrade duf

# If installed via snap
sudo snap refresh duf-utility

# If installed via go
go install github.com/muesli/duf@latest
```

### Monitoring Script Maintenance
```bash
# Test monitoring scripts regularly
./disk-usage-alert.sh

# Update thresholds based on system usage patterns
# Review and rotate log files
```

Duf provides a modern, user-friendly alternative to traditional disk usage tools, making it easier to monitor and manage disk space across your systems.

---

For more information:
- [Duf GitHub Repository](https://github.com/muesli/duf)
- [Duf Documentation](https://github.com/muesli/duf/blob/master/README.md)
- [Go Installation Guide](https://golang.org/doc/install) (for building from source)