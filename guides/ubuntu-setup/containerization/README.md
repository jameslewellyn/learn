# Containerization Tools

Tools for containerizing applications, managing container workflows, and orchestrating multi-container applications.

## Available Tools

### **[Docker](./docker.md)** - Container Platform
- **Purpose**: Containerize applications and manage container lifecycle
- **Key Features**: Container runtime, image management, networking, volumes
- **Use Case**: Application containerization, development environments, deployment
- **Installation**: Official Docker repository setup

### **[Rootless Docker](./rootless-docker.md)** - Secure Container Runtime
- **Purpose**: Run Docker daemon and containers without root privileges
- **Key Features**: Enhanced security, user isolation, no sudo required
- **Use Case**: Security-sensitive environments, shared systems, compliance
- **Installation**: Rootless Docker installation script

### **[Docker Compose](./docker-compose.md)** - Multi-Container Orchestration
- **Purpose**: Define and manage multi-container applications
- **Key Features**: YAML configuration, service orchestration, networking, volumes
- **Use Case**: Development environments, multi-service applications, testing
- **Installation**: Docker Compose plugin or standalone binary

## Quick Start

```bash
# Install Docker (standard)
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt install docker-compose-plugin

# Install Rootless Docker (alternative)
curl -fsSL https://get.docker.com/rootless | sh
```

## Tool Relationships

### **Docker Foundation**
- **Docker Engine**: Core container runtime
- **Docker CLI**: Command-line interface
- **Docker Daemon**: Background service

### **Security Enhancement**
- **Rootless Docker**: Secure alternative to standard Docker
- **User namespaces**: Enhanced isolation
- **Reduced attack surface**: No root privileges required

### **Orchestration Layer**
- **Docker Compose**: Multi-container application management
- **Service definitions**: YAML-based configuration
- **Network and volume management**: Automatic resource creation

## Configuration Examples

### Basic Docker Setup
```bash
# Test Docker installation
docker run hello-world

# Run nginx container
docker run -d -p 8080:80 nginx

# Build custom image
docker build -t myapp .
```

### Rootless Docker Setup
```bash
# Install rootless Docker
curl -fsSL https://get.docker.com/rootless | sh

# Set environment variables
export PATH=/home/$USER/bin:$PATH
export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock

# Start rootless daemon
systemctl --user start docker
```

### Docker Compose Application
```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "8000:8000"
    depends_on:
      - db
    environment:
      - DATABASE_URL=postgresql://user:password@db:5432/myapp

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

## Use Case Scenarios

### Development Environment
```bash
# Standard Docker for development
docker run -v $(pwd):/app -p 3000:3000 node:18 npm start

# Docker Compose for multi-service apps
docker-compose up -d
```

### Security-Sensitive Environment
```bash
# Rootless Docker for enhanced security
export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock
docker run --user $(id -u):$(id -g) nginx
```

### Production Deployment
```bash
# Docker with proper resource limits
docker run --memory=512m --cpus=0.5 --restart=unless-stopped myapp

# Docker Compose with production overrides
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

## Best Practices

### Security Best Practices
1. **Use rootless Docker** for enhanced security
2. **Run containers as non-root** users
3. **Limit resources** with memory and CPU constraints
4. **Use specific image tags** instead of latest
5. **Scan images** for vulnerabilities

### Development Best Practices
1. **Use Docker Compose** for multi-container applications
2. **Implement health checks** for services
3. **Use volumes** for persistent data
4. **Environment variables** for configuration
5. **Multi-stage builds** for optimized images

### Operational Best Practices
1. **Regular cleanup** of unused containers and images
2. **Monitor resource usage** with docker stats
3. **Backup volumes** and important data
4. **Use logging drivers** for centralized logging
5. **Implement restart policies** for resilience

## Tool Selection Guide

### Choose Docker when:
- Standard containerization needs
- Team familiar with Docker
- Need full Docker ecosystem
- Production deployments with orchestration

### Choose Rootless Docker when:
- Security is a primary concern
- Shared development environments
- Compliance requirements
- Multi-user systems

### Choose Docker Compose when:
- Multi-container applications
- Development environments
- Testing and staging
- Simple orchestration needs

## Integration Workflows

### Development Workflow
```bash
# 1. Develop with Docker Compose
docker-compose up -d

# 2. Build and test
docker-compose run web npm test

# 3. Deploy with Docker
docker build -t myapp:latest .
docker run -d --name myapp myapp:latest
```

### CI/CD Integration
```bash
# GitHub Actions example
- name: Build and test
  run: |
    docker-compose -f docker-compose.test.yml build
    docker-compose -f docker-compose.test.yml run --rm test

- name: Deploy
  run: |
    docker build -t myapp:${{ github.sha }} .
    docker push myapp:${{ github.sha }}
```

### Security-First Workflow
```bash
# 1. Use rootless Docker
export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock

# 2. Scan images
docker scan myapp:latest

# 3. Run with security constraints
docker run --user 1000:1000 --read-only --tmpfs /tmp myapp:latest
```

## Troubleshooting

### Common Issues
- **Permission denied**: Check Docker group membership or use rootless Docker
- **Port conflicts**: Use different ports or stop conflicting services
- **Resource issues**: Monitor with `docker stats` and set appropriate limits
- **Network issues**: Check Docker networks and firewall rules

### Performance Optimization
- **Use multi-stage builds** to reduce image size
- **Optimize Dockerfile** for better layer caching
- **Monitor resource usage** and set appropriate limits
- **Use .dockerignore** to exclude unnecessary files

## Migration Strategies

### From VM to Containers
```bash
# Traditional VM deployment
# Multiple VMs running different services

# Container deployment
# Single host running multiple containers
docker-compose up -d web db cache
```

### From Development to Production
```bash
# Development
docker-compose up -d

# Production
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

## Monitoring and Maintenance

### Health Monitoring
```bash
# Check container health
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Monitor resource usage
docker stats

# Check logs
docker logs container-name
```

### Regular Maintenance
```bash
# Clean up unused resources
docker system prune -a

# Update images
docker-compose pull
docker-compose up -d

# Backup volumes
docker run --rm -v volume_name:/data -v $(pwd):/backup ubuntu tar czf /backup/backup.tar.gz /data
```

---

**Next Steps**: 
1. Start with the [Docker installation guide](./docker.md) for basic containerization
2. Consider [Rootless Docker](./rootless-docker.md) for enhanced security
3. Use [Docker Compose](./docker-compose.md) for multi-container applications
4. Follow best practices for your specific use case