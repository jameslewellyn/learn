# Rootless Docker - Secure Container Runtime Installation and Setup Guide

A comprehensive guide for installing and configuring Docker in rootless mode for enhanced security.

## What is Rootless Docker?

**Rootless Docker** allows you to run Docker daemon and containers as a non-root user. This provides significant security benefits by reducing the attack surface and preventing privilege escalation attacks. It's particularly useful in shared environments or where security is a primary concern.

## Key Benefits

- **Enhanced Security**: Runs without root privileges
- **Reduced Attack Surface**: Containers cannot escalate to root
- **User Isolation**: Each user has their own Docker daemon
- **No sudo Required**: Regular users can run Docker commands
- **Compliance**: Meets security requirements for restricted environments
- **Multi-user Support**: Multiple users can run Docker simultaneously

## Prerequisites

### System Requirements
- Ubuntu 20.04 or later
- Kernel version 4.18 or later
- User namespaces enabled
- Sufficient UIDs/GIDs for user namespace mapping

### Check Prerequisites
```bash
# Check kernel version
uname -r

# Check if user namespaces are enabled
cat /proc/sys/kernel/unprivileged_userns_clone

# Check available UIDs/GIDs
cat /etc/subuid
cat /etc/subgid

# Check if newuidmap and newgidmap are available
which newuidmap newgidmap
```

## Installation

### Method 1: Install Script (Recommended)

#### Download and Run Installation Script
```bash
# Download the installation script
curl -fsSL https://get.docker.com/rootless | sh

# Or download and inspect first
curl -fsSL https://get.docker.com/rootless -o install-rootless.sh
chmod +x install-rootless.sh
./install-rootless.sh
```

#### Set Environment Variables
```bash
# Add to ~/.bashrc or ~/.zshrc
export PATH=/home/$USER/bin:$PATH
export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock

# Source the updated profile
source ~/.bashrc
```

### Method 2: Manual Installation

#### Install Required Packages
```bash
# Install dependencies
sudo apt update
sudo apt install -y uidmap dbus-user-session

# Install Docker CE (without root daemon)
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
```

#### Setup User Namespace Mapping
```bash
# Add user to subuid and subgid (if not already present)
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $USER

# Verify mappings
grep $USER /etc/subuid
grep $USER /etc/subgid
```

#### Install Rootless Docker
```bash
# Download and install rootless Docker
curl -fsSL https://get.docker.com/rootless | sh

# Or install manually
mkdir -p ~/bin
curl -fsSL -o ~/bin/dockerd-rootless.sh https://download.docker.com/linux/static/stable/x86_64/docker-rootless-extras-24.0.7.tgz
tar -xzf ~/bin/docker-rootless-extras-24.0.7.tgz --strip-components=1 -C ~/bin/
rm ~/bin/docker-rootless-extras-24.0.7.tgz
```

## Configuration

### Environment Setup
```bash
# Create systemd user directory
mkdir -p ~/.config/systemd/user

# Add environment variables to shell profile
cat >> ~/.bashrc << 'EOF'
# Rootless Docker environment
export PATH=/home/$USER/bin:$PATH
export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock
export DOCKER_BUILDKIT=1
EOF

# Source the profile
source ~/.bashrc
```

### Systemd Service Configuration
```bash
# Enable systemd user services
systemctl --user enable docker

# Start Docker service
systemctl --user start docker

# Check service status
systemctl --user status docker

# Enable lingering (start services on boot)
sudo loginctl enable-linger $USER
```

### Advanced Configuration
```bash
# Create Docker daemon configuration
mkdir -p ~/.config/docker

# Configure daemon options
cat > ~/.config/docker/daemon.json << 'EOF'
{
  "log-driver": "journald",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2",
  "data-root": "/home/$USER/.local/share/docker"
}
EOF
```

## Basic Usage

### Verify Installation
```bash
# Check Docker version
docker --version

# Check Docker info
docker info

# Test with hello-world
docker run hello-world

# Check rootless status
docker info | grep -i rootless
```

### Container Management
```bash
# Run container (no sudo needed)
docker run -d nginx

# List running containers
docker ps

# Execute command in container
docker exec -it <container_id> /bin/bash

# Stop container
docker stop <container_id>

# Remove container
docker rm <container_id>
```

## Networking in Rootless Mode

### Default Networking
```bash
# Rootless Docker uses slirp4netns by default
# Check network configuration
docker network ls

# Create custom network
docker network create mynetwork

# Run container with custom network
docker run --network mynetwork nginx
```

### Port Mapping
```bash
# Map to high ports (>1024)
docker run -p 8080:80 nginx

# Map to privileged ports (requires additional setup)
# This requires special configuration
```

### Enable Privileged Port Mapping
```bash
# Allow binding to privileged ports
sudo sysctl net.ipv4.ip_unprivileged_port_start=80

# Make permanent
echo 'net.ipv4.ip_unprivileged_port_start=80' | sudo tee -a /etc/sysctl.conf

# Alternative: Use rootlesskit port forwarder
export DOCKERD_ROOTLESS_ROOTLESSKIT_PORT_DRIVER=builtin
```

## Storage Configuration

### Default Storage Location
```bash
# Check Docker root directory
docker info | grep "Docker Root Dir"

# Default location: ~/.local/share/docker
ls -la ~/.local/share/docker/
```

### Custom Storage Location
```bash
# Create custom storage directory
mkdir -p ~/docker-storage

# Configure custom storage in daemon.json
cat > ~/.config/docker/daemon.json << 'EOF'
{
  "data-root": "/home/$USER/docker-storage",
  "storage-driver": "overlay2"
}
EOF

# Restart Docker service
systemctl --user restart docker
```

## Security Considerations

### User Namespace Isolation
```bash
# Check user namespace mapping
cat /proc/self/uid_map
cat /proc/self/gid_map

# Verify container isolation
docker run --rm alpine id
docker run --rm alpine cat /proc/self/uid_map
```

### File System Security
```bash
# Docker files owned by user
ls -la ~/.local/share/docker/

# Container files are mapped to user
docker run --rm -v /tmp:/host ubuntu ls -la /host
```

### Network Security
```bash
# Network isolation
docker network ls

# No access to host network by default
# Cannot bind to privileged ports without configuration
```

## Performance Optimization

### Storage Driver Optimization
```bash
# Use overlay2 storage driver (default)
docker info | grep "Storage Driver"

# Configure storage options
cat > ~/.config/docker/daemon.json << 'EOF'
{
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.size=20G"
  ]
}
EOF
```

### Resource Limits
```bash
# Set resource limits for containers
docker run --memory=512m --cpus=0.5 nginx

# Monitor resource usage
docker stats
```

## Development Workflow

### Docker Compose with Rootless
```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "8080:8000"  # Use non-privileged ports
    volumes:
      - .:/app
    environment:
      - DEBUG=1
    user: "$(id -u):$(id -g)"  # Run as current user

  db:
    image: postgres:13
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
```

### Build and Push Images
```bash
# Build image
docker build -t myapp:latest .

# Push to registry (authentication required)
docker login
docker push myapp:latest
```

## Troubleshooting

### Common Issues

#### Permission Errors
```bash
# Check user namespace mapping
cat /etc/subuid
cat /etc/subgid

# Fix mapping if needed
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 $USER

# Restart Docker service
systemctl --user restart docker
```

#### Service Won't Start
```bash
# Check systemd user service
systemctl --user status docker

# Check logs
journalctl --user -u docker

# Restart service
systemctl --user restart docker
```

#### Network Issues
```bash
# Check slirp4netns
ps aux | grep slirp4netns

# Restart Docker daemon
systemctl --user restart docker

# Check network configuration
docker network ls
```

#### Storage Issues
```bash
# Check disk usage
docker system df

# Clean up unused data
docker system prune -a

# Check storage driver
docker info | grep "Storage Driver"
```

### Performance Issues
```bash
# Check resource usage
docker stats

# Monitor system resources
htop

# Check Docker daemon logs
journalctl --user -u docker -f
```

## Migration from Root Docker

### Stop Root Docker
```bash
# Stop root Docker service
sudo systemctl stop docker
sudo systemctl disable docker

# Optional: Remove root Docker
sudo apt remove docker-ce docker-ce-cli containerd.io
```

### Migrate Images
```bash
# Export images from root Docker
sudo docker save -o images.tar image1:tag image2:tag

# Import to rootless Docker
docker load -i images.tar
rm images.tar
```

### Migrate Volumes
```bash
# Copy volumes from root Docker
sudo cp -r /var/lib/docker/volumes/* ~/.local/share/docker/volumes/

# Fix permissions
sudo chown -R $USER:$USER ~/.local/share/docker/volumes/
```

## Advanced Features

### Custom Network Configuration
```bash
# Configure custom network driver
export DOCKERD_ROOTLESS_ROOTLESSKIT_NET=vpnkit

# Use different port driver
export DOCKERD_ROOTLESS_ROOTLESSKIT_PORT_DRIVER=builtin
```

### Resource Control
```bash
# Enable cgroup v2 support
echo 'GRUB_CMDLINE_LINUX="systemd.unified_cgroup_hierarchy=1"' | sudo tee -a /etc/default/grub
sudo update-grub

# Reboot required
sudo reboot
```

### Multi-User Setup
```bash
# Each user has their own Docker daemon
# User A
su - usera
curl -fsSL https://get.docker.com/rootless | sh

# User B
su - userb
curl -fsSL https://get.docker.com/rootless | sh
```

## Monitoring and Maintenance

### Health Checks
```bash
# Check Docker daemon health
docker info

# Check system resources
docker system df

# Monitor container health
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

### Regular Maintenance
```bash
# Cleanup script
#!/bin/bash
echo "Cleaning up rootless Docker..."
docker system prune -f
docker volume prune -f
echo "Cleanup complete"
```

### Backup Configuration
```bash
# Backup Docker configuration
tar -czf docker-config-backup.tar.gz ~/.config/docker/ ~/.local/share/docker/

# Backup images
docker save -o docker-images.tar $(docker images -q)
```

## Best Practices

### Security Best Practices
1. **Use non-privileged ports**: Avoid binding to ports <1024
2. **Regular updates**: Keep Docker and base images updated
3. **Resource limits**: Set appropriate resource limits
4. **Image scanning**: Scan images for vulnerabilities
5. **User isolation**: Leverage user namespace isolation

### Performance Best Practices
1. **Optimize storage**: Use overlay2 driver
2. **Resource management**: Set appropriate limits
3. **Network optimization**: Use efficient network drivers
4. **Image optimization**: Use multi-stage builds
5. **Regular cleanup**: Clean up unused resources

### Development Best Practices
1. **Use Docker Compose**: For multi-container applications
2. **Volume management**: Use named volumes for persistence
3. **Environment variables**: Configure using environment variables
4. **Health checks**: Implement proper health checks
5. **Logging**: Configure appropriate logging

## Integration with CI/CD

### GitHub Actions with Rootless Docker
```yaml
name: Rootless Docker CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Install rootless Docker
      run: |
        curl -fsSL https://get.docker.com/rootless | sh
        echo "$HOME/bin" >> $GITHUB_PATH
        export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock
        dockerd-rootless.sh &
        sleep 5
    
    - name: Test Docker
      run: |
        export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock
        docker run hello-world
```

## Limitations and Considerations

### Known Limitations
- Cannot bind to privileged ports without configuration
- Some Docker features may not be available
- Performance overhead compared to root Docker
- Limited support for some storage drivers
- Network performance may be slower

### When to Use Rootless Docker
- **Security-sensitive environments**
- **Shared systems with multiple users**
- **Compliance requirements**
- **Development environments**
- **CI/CD pipelines**

### When to Use Root Docker
- **Production deployments requiring privileged ports**
- **High-performance requirements**
- **Advanced networking features**
- **Orchestration platforms (Kubernetes)**

## Updates and Maintenance

### Update Rootless Docker
```bash
# Update via installation script
curl -fsSL https://get.docker.com/rootless | sh

# Or update manually
# Download latest binaries and replace in ~/bin/
```

### Regular Maintenance Tasks
```bash
# Weekly maintenance script
#!/bin/bash
set -e

echo "Rootless Docker maintenance..."

# Update images
echo "Updating base images..."
docker pull alpine:latest
docker pull ubuntu:latest

# Clean up unused resources
echo "Cleaning up..."
docker system prune -f

# Check system status
echo "System status:"
docker system df
systemctl --user status docker

echo "Maintenance complete"
```

Rootless Docker provides a secure way to run containers without requiring root privileges, making it ideal for development environments and security-conscious deployments.

---

For more information:
- [Docker Rootless Documentation](https://docs.docker.com/engine/security/rootless/)
- [Rootless Containers](https://rootlesscontaine.rs/)
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)