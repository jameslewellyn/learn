# Docker Compose - Multi-Container Application Orchestration Guide

A comprehensive guide for installing and using Docker Compose to manage multi-container applications.

## What is Docker Compose?

**Docker Compose** is a tool for defining and running multi-container Docker applications. It uses YAML files to configure application services, networks, and volumes, allowing you to manage complex applications with a single command. It's ideal for development, testing, and staging environments.

## Key Features

- **Multi-container orchestration**: Manage multiple containers as a single application
- **YAML configuration**: Define services using simple YAML files
- **Network management**: Automatic network creation and service discovery
- **Volume management**: Persistent data storage across container restarts
- **Environment management**: Easy configuration for different environments
- **Service scaling**: Scale services up or down with simple commands
- **Service dependencies**: Define startup order and dependencies

## Installation

### Method 1: Docker Compose Plugin (Recommended)

Docker Compose is now included as a Docker plugin with modern Docker installations:

```bash
# Install Docker with Compose plugin
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Verify installation
docker compose version
```

### Method 2: Standalone Installation

```bash
# Download the latest release
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make it executable
sudo chmod +x /usr/local/bin/docker-compose

# Create symbolic link (optional)
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

# Verify installation
docker-compose --version
```

### Method 3: Python pip Installation

```bash
# Install via pip
sudo apt install python3-pip
pip3 install docker-compose

# Verify installation
docker-compose --version
```

## Basic Usage

### Docker Compose File Structure

Create a `docker-compose.yml` file in your project root:

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
      - redis

  db:
    image: postgres:13
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:

networks:
  default:
    driver: bridge
```

### Basic Commands

```bash
# Start all services
docker compose up

# Start services in background
docker compose up -d

# Stop all services
docker compose down

# View running services
docker compose ps

# View logs
docker compose logs

# Follow logs
docker compose logs -f

# View logs for specific service
docker compose logs web

# Scale a service
docker compose up --scale web=3

# Restart a service
docker compose restart web

# Stop a service
docker compose stop web

# Remove stopped containers
docker compose rm
```

## Service Configuration

### Build Configuration

```yaml
services:
  web:
    build:
      context: .
      dockerfile: Dockerfile
      args:
        - NODE_ENV=production
        - API_KEY=secret
    ports:
      - "3000:3000"
```

### Image Configuration

```yaml
services:
  db:
    image: postgres:13
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped
```

### Environment Variables

```yaml
services:
  web:
    image: myapp:latest
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgresql://user:password@db:5432/myapp
      - REDIS_URL=redis://redis:6379
    env_file:
      - .env
      - .env.local
```

### Volume Configuration

```yaml
services:
  web:
    image: nginx
    volumes:
      # Bind mount
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      # Named volume
      - web_data:/usr/share/nginx/html
      # Anonymous volume
      - /var/log/nginx

volumes:
  web_data:
    driver: local
```

## Advanced Configuration

### Multi-Stage Development Setup

```yaml
# docker-compose.yml (base configuration)
version: '3.8'

services:
  web:
    build: .
    ports:
      - "8000:8000"
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

```yaml
# docker-compose.override.yml (development overrides)
version: '3.8'

services:
  web:
    volumes:
      - .:/app
    environment:
      - DEBUG=1
      - RELOAD=1
    command: python manage.py runserver 0.0.0.0:8000

  db:
    ports:
      - "5432:5432"
```

```yaml
# docker-compose.prod.yml (production overrides)
version: '3.8'

services:
  web:
    environment:
      - DEBUG=0
    restart: unless-stopped
    deploy:
      replicas: 3
      resources:
        limits:
          memory: 512M
        reservations:
          memory: 256M

  db:
    restart: unless-stopped
    deploy:
      resources:
        limits:
          memory: 1G
        reservations:
          memory: 512M
```

### Health Checks

```yaml
services:
  web:
    image: myapp:latest
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
    depends_on:
      db:
        condition: service_healthy

  db:
    image: postgres:13
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d myapp"]
      interval: 10s
      timeout: 5s
      retries: 5
```

### Network Configuration

```yaml
version: '3.8'

services:
  web:
    image: nginx
    networks:
      - frontend
      - backend

  api:
    image: myapi:latest
    networks:
      - backend
      - database

  db:
    image: postgres:13
    networks:
      - database

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
  database:
    driver: bridge
    internal: true  # No external access
```

## Development Workflows

### Local Development Setup

```yaml
# docker-compose.dev.yml
version: '3.8'

services:
  web:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "3000:3000"
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
      - CHOKIDAR_USEPOLLING=true
    depends_on:
      - db
      - redis

  db:
    image: postgres:13
    environment:
      - POSTGRES_DB=myapp_dev
      - POSTGRES_USER=dev
      - POSTGRES_PASSWORD=dev
    ports:
      - "5432:5432"
    volumes:
      - postgres_dev_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

  mailhog:
    image: mailhog/mailhog
    ports:
      - "1025:1025"
      - "8025:8025"

volumes:
  postgres_dev_data:
```

### Testing Environment

```yaml
# docker-compose.test.yml
version: '3.8'

services:
  web:
    build:
      context: .
      dockerfile: Dockerfile.test
    environment:
      - NODE_ENV=test
      - DATABASE_URL=postgresql://test:test@db:5432/test_db
    depends_on:
      - db
    command: npm run test

  db:
    image: postgres:13
    environment:
      - POSTGRES_DB=test_db
      - POSTGRES_USER=test
      - POSTGRES_PASSWORD=test
    tmpfs:
      - /var/lib/postgresql/data
```

### CI/CD Integration

```yaml
# docker-compose.ci.yml
version: '3.8'

services:
  test:
    build:
      context: .
      dockerfile: Dockerfile
    environment:
      - NODE_ENV=test
      - CI=true
    depends_on:
      - db
      - redis
    command: npm run test:ci

  lint:
    build:
      context: .
      dockerfile: Dockerfile
    command: npm run lint

  security:
    build:
      context: .
      dockerfile: Dockerfile
    command: npm audit

  db:
    image: postgres:13
    environment:
      - POSTGRES_DB=test_db
      - POSTGRES_USER=test
      - POSTGRES_PASSWORD=test
    tmpfs:
      - /var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    tmpfs:
      - /data
```

## Real-World Examples

### Full-Stack Web Application

```yaml
version: '3.8'

services:
  # Frontend
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - REACT_APP_API_URL=http://localhost:8000
    depends_on:
      - backend
    volumes:
      - ./frontend:/app
      - /app/node_modules

  # Backend API
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://user:password@db:5432/myapp
      - REDIS_URL=redis://redis:6379
      - JWT_SECRET=your-secret-key
    depends_on:
      - db
      - redis
    volumes:
      - ./backend:/app
      - /app/venv

  # Database
  db:
    image: postgres:13
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  # Cache
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  # Background jobs
  worker:
    build:
      context: ./backend
      dockerfile: Dockerfile
    environment:
      - DATABASE_URL=postgresql://user:password@db:5432/myapp
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis
    command: celery -A myapp worker --loglevel=info
    volumes:
      - ./backend:/app

  # Reverse proxy
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - frontend
      - backend

volumes:
  postgres_data:
  redis_data:
```

### Microservices Architecture

```yaml
version: '3.8'

services:
  # API Gateway
  gateway:
    build: ./gateway
    ports:
      - "80:80"
    depends_on:
      - auth-service
      - user-service
      - product-service
    environment:
      - AUTH_SERVICE_URL=http://auth-service:3001
      - USER_SERVICE_URL=http://user-service:3002
      - PRODUCT_SERVICE_URL=http://product-service:3003

  # Authentication Service
  auth-service:
    build: ./services/auth
    ports:
      - "3001:3001"
    environment:
      - DATABASE_URL=postgresql://auth:password@auth-db:5432/auth
      - JWT_SECRET=auth-secret
    depends_on:
      - auth-db

  auth-db:
    image: postgres:13
    environment:
      - POSTGRES_DB=auth
      - POSTGRES_USER=auth
      - POSTGRES_PASSWORD=password
    volumes:
      - auth_db_data:/var/lib/postgresql/data

  # User Service
  user-service:
    build: ./services/user
    ports:
      - "3002:3002"
    environment:
      - DATABASE_URL=postgresql://user:password@user-db:5432/users
    depends_on:
      - user-db

  user-db:
    image: postgres:13
    environment:
      - POSTGRES_DB=users
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=password
    volumes:
      - user_db_data:/var/lib/postgresql/data

  # Product Service
  product-service:
    build: ./services/product
    ports:
      - "3003:3003"
    environment:
      - DATABASE_URL=postgresql://product:password@product-db:5432/products
    depends_on:
      - product-db

  product-db:
    image: postgres:13
    environment:
      - POSTGRES_DB=products
      - POSTGRES_USER=product
      - POSTGRES_PASSWORD=password
    volumes:
      - product_db_data:/var/lib/postgresql/data

  # Message Queue
  rabbitmq:
    image: rabbitmq:3-management
    ports:
      - "5672:5672"
      - "15672:15672"
    environment:
      - RABBITMQ_DEFAULT_USER=admin
      - RABBITMQ_DEFAULT_PASS=admin
    volumes:
      - rabbitmq_data:/var/lib/rabbitmq

  # Monitoring
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana_data:/var/lib/grafana

volumes:
  auth_db_data:
  user_db_data:
  product_db_data:
  rabbitmq_data:
  prometheus_data:
  grafana_data:
```

## Environment Management

### Environment Files

```bash
# .env
NODE_ENV=development
DATABASE_URL=postgresql://user:password@localhost:5432/myapp
REDIS_URL=redis://localhost:6379
JWT_SECRET=your-secret-key
```

```bash
# .env.production
NODE_ENV=production
DATABASE_URL=postgresql://user:prod_password@prod-db:5432/myapp
REDIS_URL=redis://prod-redis:6379
JWT_SECRET=production-secret-key
```

### Multiple Environment Files

```yaml
services:
  web:
    image: myapp:latest
    env_file:
      - .env
      - .env.local
      - .env.${NODE_ENV}
    environment:
      - NODE_ENV=${NODE_ENV:-development}
```

### Variable Interpolation

```yaml
services:
  web:
    image: myapp:${TAG:-latest}
    ports:
      - "${PORT:-3000}:3000"
    environment:
      - DATABASE_URL=${DATABASE_URL}
      - API_KEY=${API_KEY}
```

## Production Considerations

### Resource Limits

```yaml
services:
  web:
    image: myapp:latest
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
      replicas: 3
      restart_policy:
        condition: on-failure
        max_attempts: 3
```

### Security Best Practices

```yaml
services:
  web:
    image: myapp:latest
    user: "1000:1000"  # Run as non-root user
    read_only: true
    tmpfs:
      - /tmp
      - /var/run
    security_opt:
      - no-new-privileges:true
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE
```

### Logging Configuration

```yaml
services:
  web:
    image: myapp:latest
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
    # Or use external logging
    logging:
      driver: "syslog"
      options:
        syslog-address: "tcp://logserver:514"
```

## Troubleshooting

### Common Issues

#### Service Dependencies

```bash
# Check service startup order
docker compose logs

# Force recreate services
docker compose up --force-recreate

# Start specific service
docker compose up db
```

#### Port Conflicts

```bash
# Check port usage
netstat -tulpn | grep :8000

# Use different ports
docker compose up -d -p 8080:8000
```

#### Volume Issues

```bash
# Check volume usage
docker volume ls
docker volume inspect myapp_postgres_data

# Remove volumes
docker compose down -v

# Recreate volumes
docker volume rm myapp_postgres_data
docker compose up -d
```

#### Network Issues

```bash
# Check networks
docker network ls

# Inspect network
docker network inspect myapp_default

# Test connectivity
docker compose exec web ping db
```

### Debugging Commands

```bash
# Check service status
docker compose ps

# View service logs
docker compose logs -f web

# Execute command in service
docker compose exec web /bin/bash

# Check service configuration
docker compose config

# Validate compose file
docker compose config --quiet
```

## Best Practices

### Development Best Practices

1. **Use .dockerignore**: Exclude unnecessary files from build context
2. **Layer caching**: Order Dockerfile instructions for optimal caching
3. **Health checks**: Implement proper health checks for services
4. **Environment variables**: Use environment variables for configuration
5. **Volume management**: Use named volumes for persistent data

### Production Best Practices

1. **Resource limits**: Set appropriate resource limits
2. **Restart policies**: Configure restart policies for resilience
3. **Security**: Run containers as non-root users
4. **Monitoring**: Implement logging and monitoring
5. **Backup**: Regular backup of volumes and data

### File Organization

```
project/
├── docker-compose.yml
├── docker-compose.override.yml
├── docker-compose.prod.yml
├── docker-compose.test.yml
├── .env
├── .env.example
├── .dockerignore
├── services/
│   ├── web/
│   │   ├── Dockerfile
│   │   └── app/
│   └── api/
│       ├── Dockerfile
│       └── src/
└── config/
    ├── nginx/
    └── postgres/
```

## Integration with CI/CD

### GitHub Actions

```yaml
name: Docker Compose CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Build and test
      run: |
        docker compose -f docker-compose.test.yml build
        docker compose -f docker-compose.test.yml run --rm test
        
    - name: Cleanup
      run: docker compose -f docker-compose.test.yml down -v
```

### GitLab CI

```yaml
stages:
  - test
  - build
  - deploy

test:
  stage: test
  script:
    - docker compose -f docker-compose.test.yml build
    - docker compose -f docker-compose.test.yml run --rm test
  after_script:
    - docker compose -f docker-compose.test.yml down -v

build:
  stage: build
  script:
    - docker compose build
    - docker compose push

deploy:
  stage: deploy
  script:
    - docker compose -f docker-compose.prod.yml pull
    - docker compose -f docker-compose.prod.yml up -d
  only:
    - main
```

## Migration and Maintenance

### Migration from Docker Run Commands

```bash
# Convert docker run to docker-compose
# From:
docker run -d --name web -p 8000:8000 -e NODE_ENV=production myapp

# To docker-compose.yml:
services:
  web:
    image: myapp
    ports:
      - "8000:8000"
    environment:
      - NODE_ENV=production
```

### Regular Maintenance

```bash
# Update services
docker compose pull
docker compose up -d

# Clean up unused resources
docker system prune -f

# Backup volumes
docker run --rm -v myapp_postgres_data:/data -v $(pwd):/backup ubuntu tar czf /backup/backup.tar.gz /data
```

## Integration with Your Toolkit

Docker Compose pairs excellently with:
- **Docker**: Container runtime
- **Kubernetes**: For production orchestration
- **CI/CD tools**: Automated testing and deployment
- **monitoring tools**: Application and infrastructure monitoring
- **version control**: Configuration management

Docker Compose simplifies multi-container application development and deployment, making it easier to manage complex applications with multiple services, databases, and dependencies.

---

For more information:
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Docker Compose File Reference](https://docs.docker.com/compose/compose-file/)
- [Docker Compose Best Practices](https://docs.docker.com/compose/production/)