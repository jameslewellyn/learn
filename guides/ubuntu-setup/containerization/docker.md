# Docker - Container Platform Installation and Setup Guide

A comprehensive guide for installing and configuring Docker on Ubuntu.

## What is Docker?

**Docker** is a containerization platform that allows you to package applications and their dependencies into lightweight, portable containers. It provides consistency across different environments and simplifies application deployment, scaling, and management.

## Key Features

- **Containerization**: Package applications with their dependencies
- **Portability**: Run containers on any system with Docker installed
- **Isolation**: Applications run in isolated environments
- **Efficiency**: Lightweight compared to virtual machines
- **Scalability**: Easy horizontal scaling of applications
- **Version control**: Docker images can be versioned and shared
- **Ecosystem**: Large ecosystem of pre-built images

## Installation

### Method 1: Official Docker Repository (Recommended)

#### Remove Old Versions
```bash
# Remove old Docker versions
sudo apt remove docker docker-engine docker.io containerd runc
```

#### Install Prerequisites
```bash
# Update package index
sudo apt update

# Install required packages
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release
```

#### Add Docker's Official GPG Key
```bash
# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

#### Add Docker Repository
```bash
# Add Docker repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

#### Install Docker Engine
```bash
# Update package index
sudo apt update

# Install Docker Engine, CLI, and containerd
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Method 2: Convenience Script (Less Secure)
```bash
# Download and run convenience script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh
```

### Method 3: Snap Package (Alternative)
```bash
# Install via snap
sudo snap install docker
```

## Post-Installation Setup

### Add User to Docker Group
```bash
# Add current user to docker group
sudo usermod -aG docker $USER

# Apply group changes (logout/login required)
newgrp docker

# Verify group membership
groups $USER
```

### Configure Docker Daemon
```bash
# Create daemon configuration directory
sudo mkdir -p /etc/docker

# Configure Docker daemon
sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2"
}
EOF

# Restart Docker service
sudo systemctl restart docker
```

### Enable Docker Service
```bash
# Enable Docker to start at boot
sudo systemctl enable docker

# Start Docker service
sudo systemctl start docker

# Check Docker status
sudo systemctl status docker
```

## Basic Usage

### Docker Commands

#### Container Management
```bash
# Run a container
docker run hello-world

# Run container interactively
docker run -it ubuntu:20.04 /bin/bash

# Run container in background
docker run -d nginx

# List running containers
docker ps

# List all containers
docker ps -a

# Stop container
docker stop <container_id>

# Remove container
docker rm <container_id>

# Remove all stopped containers
docker container prune
```

#### Image Management
```bash
# List images
docker images

# Pull image from registry
docker pull nginx:latest

# Build image from Dockerfile
docker build -t myapp .

# Tag image
docker tag myapp:latest myapp:v1.0

# Remove image
docker rmi <image_id>

# Remove unused images
docker image prune
```

#### System Information
```bash
# Show Docker version
docker --version

# Show system information
docker info

# Show disk usage
docker system df

# Clean up unused data
docker system prune -a
```

## Creating Docker Images

### Basic Dockerfile
```dockerfile
# Use official base image
FROM ubuntu:20.04

# Set working directory
WORKDIR /app

# Copy files
COPY . .

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install -r requirements.txt

# Expose port
EXPOSE 8000

# Set environment variables
ENV PYTHONPATH=/app

# Run application
CMD ["python3", "app.py"]
```

### Multi-stage Build
```dockerfile
# Build stage
FROM node:16-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Production stage
FROM node:16-alpine

WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .

EXPOSE 3000
CMD ["node", "server.js"]
```

### Build and Tag Images
```bash
# Build image
docker build -t myapp:latest .

# Build with build args
docker build --build-arg NODE_ENV=production -t myapp:prod .

# Build for specific platform
docker buildx build --platform linux/amd64,linux/arm64 -t myapp:latest .
```

## Container Networking

### Network Management
```bash
# List networks
docker network ls

# Create network
docker network create mynetwork

# Connect container to network
docker network connect mynetwork <container_name>

# Disconnect container from network
docker network disconnect mynetwork <container_name>

# Inspect network
docker network inspect mynetwork

# Remove network
docker network rm mynetwork
```

### Port Mapping
```bash
# Map host port to container port
docker run -p 8080:80 nginx

# Map to specific interface
docker run -p 127.0.0.1:8080:80 nginx

# Map all ports
docker run -P nginx
```

## Data Management

### Volumes
```bash
# Create volume
docker volume create myvolume

# List volumes
docker volume ls

# Use volume in container
docker run -v myvolume:/data ubuntu

# Mount host directory
docker run -v /host/path:/container/path ubuntu

# Remove volume
docker volume rm myvolume

# Remove unused volumes
docker volume prune
```

### Bind Mounts
```bash
# Bind mount host directory
docker run -v /home/user/data:/app/data ubuntu

# Bind mount with read-only
docker run -v /home/user/data:/app/data:ro ubuntu
```

## Docker Compose Integration

### Basic docker-compose.yml
```yaml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - .:/app
    environment:
      - DEBUG=1
    depends_on:
      - db

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

### Compose Commands
```bash
# Start services
docker-compose up

# Start in background
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs

# Scale services
docker-compose up --scale web=3
```

## Production Considerations

### Security Best Practices
```bash
# Run as non-root user
FROM ubuntu:20.04
RUN useradd -m appuser
USER appuser

# Use specific image tags
FROM nginx:1.21-alpine

# Scan images for vulnerabilities
docker scan myapp:latest
```

### Resource Management
```bash
# Limit memory usage
docker run --memory=512m nginx

# Limit CPU usage
docker run --cpus=0.5 nginx

# Set restart policy
docker run --restart=unless-stopped nginx
```

### Logging Configuration
```bash
# Configure logging driver
docker run --log-driver=syslog nginx

# Configure log options
docker run --log-opt max-size=10m --log-opt max-file=3 nginx
```

## Advanced Features

### Docker Buildx
```bash
# Create buildx builder
docker buildx create --name mybuilder --use

# Build for multiple platforms
docker buildx build --platform linux/amd64,linux/arm64 -t myapp:latest --push .

# Inspect builder
docker buildx inspect mybuilder
```

### Docker Swarm Mode
```bash
# Initialize swarm
docker swarm init

# Join swarm as worker
docker swarm join --token <token> <manager-ip>:2377

# Deploy service
docker service create --name web --replicas 3 nginx

# List services
docker service ls

# Scale service
docker service scale web=5
```

## Development Workflow

### Development Environment
```bash
# Run with volume mounting for development
docker run -v $(pwd):/app -p 8000:8000 myapp:dev

# Use Docker Compose for development
docker-compose -f docker-compose.dev.yml up
```

### Testing
```bash
# Run tests in container
docker run --rm -v $(pwd):/app myapp:test npm test

# Run tests with coverage
docker run --rm -v $(pwd):/app -v coverage:/app/coverage myapp:test npm run test:coverage
```

## Monitoring and Debugging

### Container Inspection
```bash
# Inspect container
docker inspect <container_id>

# View container logs
docker logs <container_id>

# Follow log output
docker logs -f <container_id>

# Execute command in running container
docker exec -it <container_id> /bin/bash

# Show container processes
docker top <container_id>
```

### Resource Monitoring
```bash
# Show container resource usage
docker stats

# Show resource usage for specific container
docker stats <container_id>

# Monitor events
docker events
```

## Maintenance

### Cleanup Commands
```bash
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune

# Remove unused networks
docker network prune

# Remove unused volumes
docker volume prune

# Remove all unused data
docker system prune -a

# Remove everything (dangerous)
docker system prune -a --volumes
```

### Health Checks
```dockerfile
# Add health check to Dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8000/health || exit 1
```

## Troubleshooting

### Common Issues

#### Permission Denied
```bash
# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Or run with sudo
sudo docker run hello-world
```

#### Docker Daemon Not Running
```bash
# Start Docker service
sudo systemctl start docker

# Enable Docker service
sudo systemctl enable docker

# Check service status
sudo systemctl status docker
```

#### Out of Disk Space
```bash
# Check disk usage
docker system df

# Clean up unused data
docker system prune -a

# Remove specific containers/images
docker rm $(docker ps -aq)
docker rmi $(docker images -q)
```

#### Network Issues
```bash
# Restart Docker service
sudo systemctl restart docker

# Reset Docker networks
docker network prune

# Check firewall rules
sudo ufw status
```

### Performance Issues
```bash
# Check resource usage
docker stats

# Optimize images
# - Use multi-stage builds
# - Minimize layers
# - Use .dockerignore

# Monitor system resources
htop
df -h
```

## Integration with CI/CD

### GitHub Actions
```yaml
name: Docker Build and Push

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Login to DockerHub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}
    
    - name: Build and push
      uses: docker/build-push-action@v3
      with:
        context: .
        push: true
        tags: myapp:latest
```

### GitLab CI
```yaml
stages:
  - build
  - test
  - deploy

build:
  stage: build
  script:
    - docker build -t myapp:$CI_COMMIT_SHA .
    - docker push myapp:$CI_COMMIT_SHA

test:
  stage: test
  script:
    - docker run --rm myapp:$CI_COMMIT_SHA npm test

deploy:
  stage: deploy
  script:
    - docker pull myapp:$CI_COMMIT_SHA
    - docker stop myapp || true
    - docker rm myapp || true
    - docker run -d --name myapp -p 80:8000 myapp:$CI_COMMIT_SHA
```

## Best Practices

### Dockerfile Best Practices
1. **Use specific tags**: Avoid `latest` tags in production
2. **Minimize layers**: Combine RUN commands
3. **Use .dockerignore**: Exclude unnecessary files
4. **Run as non-root**: Create and use non-root user
5. **Multi-stage builds**: Keep production images small

### Security Best Practices
1. **Scan images**: Regularly scan for vulnerabilities
2. **Use trusted images**: Only use official or verified images
3. **Update regularly**: Keep base images updated
4. **Limit privileges**: Use least privilege principle
5. **Network security**: Use custom networks, not default bridge

### Performance Best Practices
1. **Layer caching**: Order instructions for optimal caching
2. **Resource limits**: Set appropriate resource limits
3. **Health checks**: Implement proper health checks
4. **Logging**: Configure appropriate logging drivers
5. **Monitoring**: Implement monitoring and alerting

## Integration with Your Toolkit

Docker pairs excellently with:
- **docker-compose**: Multi-container orchestration
- **kubernetes**: Container orchestration at scale
- **CI/CD tools**: Automated building and deployment
- **monitoring tools**: Container monitoring and logging
- **security tools**: Vulnerability scanning and compliance

## Updates and Maintenance

### Update Docker
```bash
# Update package lists
sudo apt update

# Update Docker
sudo apt upgrade docker-ce docker-ce-cli containerd.io

# Restart Docker service
sudo systemctl restart docker
```

### Regular Maintenance
```bash
# Weekly cleanup script
#!/bin/bash
echo "Cleaning up Docker..."
docker system prune -f
docker volume prune -f
echo "Docker cleanup complete"
```

Docker provides a powerful platform for containerizing applications, enabling consistent deployment across different environments and simplifying development workflows.

---

For more information:
- [Docker Official Documentation](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)