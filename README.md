# Demo Load Balancer với Docker

## 🏗️ Kiến trúc hệ thống

```
Internet
    ↓
[nginx-gateway Container (nginx:alpine)]
    ├── Port 8000: Frontend Load Balancer
    └── Port 8080: API Gateway
           ↓                    ↓
    [frontend-1]        [frontend-2] ← Nuxt.js instances
           ↓                    ↓
    [backend-1]         [backend-2] ← NestJS instances
           ↓                    ↓
           [MySQL Database]
```

## 📦 Các thành phần

- **Frontend**: 2 instances Nuxt.js (Vue 3 + TypeScript + Ant Design Vue)
- **Backend**: 2 instances NestJS (TypeScript + Prisma + MySQL)
- **Database**: MySQL 8.0
- **Load Balancer**: 1 Nginx instance (nginx-gateway)
  - **Frontend LB (Port 8000)**: Load balancing giữa frontend instances
  - **API Gateway (Port 8080)**: Load balancing giữa backend instances

### 🎨 Frontend Features

- **Nuxt 3**: Modern Vue.js framework with SSR/SPA support
- **Vue 3**: Composition API, better TypeScript support
- **Ant Design Vue**: Professional UI component library
- **i18n**: Multi-language support (EN, JA, VN)
- **Tailwind CSS**: Utility-first CSS framework
- **Pinia**: State management
- **TypeScript**: Type safety

### 🚀 Backend Features

- **NestJS**: Progressive Node.js framework
- **Prisma**: Type-safe database ORM
- **Swagger/OpenAPI**: Auto-generated API documentation
- **JWT Authentication**: Secure authentication system
- **Validation**: Input validation with class-validator
- **Versioning**: API versioning support (/v1 prefix)
- **Health Checks**: Built-in health monitoring
- **Docker**: Multi-stage optimized builds

## 🚀 Start services

```bash
# Start all services (migration runs automatically)
make up

# Or manual approach
docker compose up --build -d
```

After starting, you can access:

- 📱 **Frontend**: http://localhost:8000
- 🔌 **API Gateway**: http://localhost:8080
- 📚 **API Documentation**: http://localhost:8080/api
- ❤️ **Health Check**: http://localhost:8080/health

### 4. Kiểm tra status

```bash
# Xem status của tất cả containers
docker compose ps

# Xem logs của specific service
docker compose logs frontend-1
docker compose logs nginx-gateway
docker compose logs db-migrate  # Migration logs
```

## 🔍 Testing Load Balancer

### 1. Access points

- **Frontend**: http://localhost:8000
- **API Gateway**: http://localhost:8080
- **API Documentation**: http://localhost:8080/api
- **Health Checks**:
  - Frontend: http://localhost:8000/
  - Backend: http://localhost:8080/health
- **Database**: MySQL external port 3307

### 2. Test load distribution

```bash
# Test load balancing distribution
make test-load

# Test failover scenario
make test-failover

# Stress test with high load
make test-stress
```

### 📊 Chi tiết Load Balancing Test Results

#### **Backend Load Balancing Analysis:**

- **Algorithm**: Round Robin (default)
- **Upstream Servers**:
  - `backend-1:3000` (max_fails=3, fail_timeout=30s)
  - `backend-2:3000` (max_fails=3, fail_timeout=30s)
- **Expected Distribution**: 50/50 giữa 2 backend instances
- **Headers để track**: `X-Load-Balancer: API-Gateway` (from nginx-gateway nginx)

#### **Frontend Load Balancing Analysis:**

- **Algorithm**: Least Connections (`least_conn`)
- **Upstream Servers**:
  - `frontend-1:3000` (max_fails=3, fail_timeout=30s)
  - `frontend-2:3000` (max_fails=3, fail_timeout=30s)
- **Expected Distribution**: Based on active connections
- **Headers để track**: `X-Frontend-Server: <IP>:3000`

#### **Health Check Endpoints:**

- **Frontend (via Frontend LB)**: `http://localhost:8000/`
- **Backend API (via API Gateway)**: `http://localhost:8080/health`
- **Database**: `mysql://localhost:3307` (MySQL external port)
- **Internal Network**:
  - Backend instances: `http://backend-1:3000/health`, `http://backend-2:3000/health`
  - Frontend instances: `http://frontend-1:3000/`, `http://frontend-2:3000/`
  - MySQL: `mysql://mysql:3306`

#### **Nginx Configuration Details:**

**nginx-gateway Container (Single nginx.conf):**

```nginx
# Frontend Load Balancer (Port 8000 → frontend instances)
upstream frontend_servers {
    least_conn;  # Use least connections for better distribution
    server frontend-1:3000 max_fails=3 fail_timeout=30s;
    server frontend-2:3000 max_fails=3 fail_timeout=30s;
    keepalive 32;
}

# API Gateway (Port 8080 → backend instances)
upstream backend_servers {
    # round_robin (default) - Equal distribution
    server backend-1:3000 max_fails=3 fail_timeout=30s;
    server backend-2:3000 max_fails=3 fail_timeout=30s;
    keepalive 32;
}

# Server blocks:
# - Port 8000: Frontend Load Balancer
# - Port 8080: API Gateway (routes: /v1/*, /api, /health)
# - CORS: Handled by NestJS backend (app.enableCors())
```

**Load balancing methods available:**

- `round_robin` (default) - Equal distribution
- `least_conn` - Route to server with fewest connections
- `ip_hash` - Sticky sessions based on client IP
- `weighted` - Custom weight distribution

#### **Container Architecture:**

```
                        ┌─────────────────────────────┐
                        │      nginx-gateway          │
                        │      nginx:alpine           │
                        │  Port 8000: Frontend        │
                        │  Port 8080: API Gateway     │
                        └─────────┬─────────┬─────────┘
                                  │         │
                ┌─────────────────┘         └─────────────────┐
                │ (Frontend LB)                    (API Gateway)
                ▼                                             ▼
      ┌─────────────────┐                           ┌─────────────────┐
      │  frontend-1     │                           │   backend-1     │
      │  Nuxt.js + Vue3 │                           │   NestJS:22     │
      │  + Ant Design   │                           │   + Prisma      │
      │  Port: 3000     │                           │   + Swagger     │
      └─────────────────┘                           │   Port: 3000    │
      ┌─────────────────┐                           │   (CORS enabled)│
      │  frontend-2     │                           └─────────────────┘
      │  Nuxt.js + Vue3 │                           ┌─────────────────┐
      │  + Ant Design   │                           │   backend-2     │
      │  Port: 3000     │                           │   NestJS:22     │
      └─────────────────┘                           │   + Prisma      │
                                                    │   + Swagger     │
                                                    │   Port: 3000    │
                                                    │   (CORS enabled)│
                                                    └─────────┬───────┘
                                                              │
                                                              ▼
                                                     ┌─────────────────┐
                                                     │     mysql       │
                                                     │   Port: 3306    │
                                                     │ (External: 3307)│
                                                     └─────────────────┘
```

**Key Architecture Points:**

- **Single Entry Point**: `nginx-gateway` container serves both roles
- **Dual Port Setup**: Port 8000 (Frontend) + Port 8080 (API Gateway)
- **Backend Load Balancing**: API Gateway → Backend instances (round-robin)
- **Frontend Load Balancing**: Frontend LB → Frontend instances (least_conn)
- **Database Migration**: Automated via `db-migrate` service on startup
- **Internal Networking**: All communication via Docker network except external ports

**Request Flow (Optimized Architecture):**

```
1. Frontend Request: Browser → localhost:8000 → nginx-gateway:8000 → frontend-1/2:3000
2. API Request:     Browser → localhost:8080 → nginx-gateway:8080 → backend-1/2:3000
3. API Docs:        Browser → localhost:8080/api → nginx-gateway:8080 → backend-1/2:3000/api
4. Database:        Backend → mysql:3306
```

**Containers Summary:**

- `demo_nginx_gateway`: **Unified Load Balancer** (Frontend LB + API Gateway)
- `demo_frontend_1/2`: **Frontend Instances** (Nuxt.js + Vue 3 + Ant Design Vue + i18n)
- `demo_backend_1/2`: **Backend Instances** (NestJS + Prisma + Swagger + JWT + CORS)
- `demo_mysql`: **Database** (MySQL 8.0)
- `demo_db_migrate`: **Migration Service** (One-time Prisma migration)

### Manual Testing (Optional)

```bash
# Test frontend load balancing
for i in {1..10}; do
  curl -H "Cache-Control: no-cache" http://localhost:8000/ \
    -I -s | grep "X-Frontend-Server"
done

# Test backend load balancing
for i in {1..10}; do
  curl -H "Cache-Control: no-cache" http://localhost:8080/health \
    -I -s | grep "X-Load-Balancer"
done

# Test API Documentation
curl -s http://localhost:8080/api | head -5
```

### 3. Test failover

```bash
# Stop một backend instance
docker compose stop backend-1

# Test API vẫn hoạt động
curl http://localhost:8080/health

# Restart
docker compose start backend-1
```

```bash
# Start với monitoring profile
docker compose --profile monitoring up -d

# Access Nginx metrics
curl http://localhost:9113/metrics
```
