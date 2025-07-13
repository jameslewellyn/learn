# Bandwhich - Network Utilization Monitor

Bandwhich is a CLI utility for displaying current network utilization by process, connection, and remote IP/hostname.

## Installation

```bash
cargo install bandwhich
```

## Prerequisites

Bandwhich requires libpcap for packet capture:

```bash
sudo apt install libpcap-dev
```

## Basic Setup

### Sudo Wrapper

```bash
# Bandwhich requires root privileges to monitor network traffic
# Create a simple wrapper script
sudo tee /usr/local/bin/bandwhich-monitor << 'EOF'
#!/bin/bash
sudo -E bandwhich "$@"
EOF

sudo chmod +x /usr/local/bin/bandwhich-monitor

# Add alias
echo 'alias bw="bandwhich-monitor"' >> ~/.bashrc
```

## Usage Examples

```bash
# Monitor network usage
sudo bandwhich

# Monitor specific interface
sudo bandwhich -i eth0

# Monitor specific interface (WiFi)
sudo bandwhich -i wlan0

# Raw mode (no TUI)
sudo bandwhich --raw

# Show DNS resolution
sudo bandwhich --show-dns

# Set update interval
sudo bandwhich --interval 1000

# Show only specific number of entries
sudo bandwhich --total-utilization

# Monitor with custom interface
sudo bandwhich -i lo  # localhost
```

## Key Features

- Real-time network monitoring
- Process-level network usage
- Connection tracking
- Remote IP/hostname display
- Interface-specific monitoring
- DNS resolution
- TUI and raw output modes

## Interface Detection

```bash
# List available interfaces
ip link show

# Common interfaces:
# - eth0: Ethernet
# - wlan0: WiFi
# - lo: Loopback
# - docker0: Docker bridge
# - tun0: VPN tunnel
```

## Output Modes

### TUI Mode (default)
Interactive terminal interface with:
- Process list with network usage
- Connection details
- Remote addresses
- Real-time updates

### Raw Mode
```bash
sudo bandwhich --raw
```
- JSON output
- Suitable for scripting
- No interactive interface

## Permissions

Bandwhich requires elevated privileges because it:
- Captures network packets
- Accesses system network information
- Monitors process network activity

## Troubleshooting

- **Permission denied**: Must run with sudo
- **Interface not found**: Check interface names with `ip link`
- **No data shown**: Verify interface is active and has traffic
- **Compilation issues**: Ensure libpcap-dev is installed

## Use Cases

### System Administration
- Monitor bandwidth usage by process
- Identify network-heavy applications
- Track connection patterns
- Debug network issues

### Development
- Monitor application network behavior
- Debug network connections
- Test bandwidth usage
- Analyze connection patterns

### Security
- Monitor suspicious network activity
- Track connections to external hosts
- Identify unexpected network usage
- Monitor for data exfiltration

## Alternative Tools

Similar tools for comparison:
- `nethogs` - Network bandwidth monitor
- `iftop` - Network interface monitor
- `nload` - Network traffic monitor
- `vnstat` - Network statistics

## Alternative Installation

```bash
# Via package manager (if available)
sudo apt install bandwhich
```

## Configuration

Bandwhich doesn't use configuration files, but you can create wrapper scripts:

```bash
# Create monitoring scripts
cat > ~/monitor-wifi.sh << 'EOF'
#!/bin/bash
sudo bandwhich -i wlan0 --show-dns
EOF

cat > ~/monitor-ethernet.sh << 'EOF'
#!/bin/bash
sudo bandwhich -i eth0 --show-dns
EOF

chmod +x ~/monitor-*.sh
```