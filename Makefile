# Demo Load Balancer Makefile
.PHONY: help build up down logs status test test-load test-failover test-stress test-latency clean scale-up scale-down monitor dev-backend dev-frontend

# Default target
help:
	@echo "Demo Load Balancer - Available commands:"
	@echo ""
	@echo "=== Main Commands ==="
	@echo "  build        - Build all containers"
	@echo "  up           - Start all services (full load balancer demo)"
	@echo "  down         - Stop all services"
	@echo "  logs         - Show logs for all services"
	@echo "  status       - Show container status"
	@echo ""
	@echo "=== Testing ==="
	@echo "  test         - Test health endpoints"
	@echo "  test-load    - Test load balancing distribution"
	@echo "  test-failover - Test failover scenario"
	@echo "  test-stress  - Stress test with high load (50+ requests)"
	@echo "  test-latency - Test API latency and analyze request path"
	@echo ""
	@echo "=== Scaling ==="
	@echo "  scale-up     - Scale services to 3 instances each"
	@echo "  scale-down   - Scale services back to 2 instances"
	@echo "  monitor      - Start with monitoring enabled"
	@echo ""
	@echo "=== Development ==="
	@echo "  dev-backend  - Start only backend + database (for backend dev)"
	@echo "  dev-frontend - Start only frontend (for frontend dev)"
	@echo ""
	@echo "=== Cleanup ==="
	@echo "  clean        - Clean up everything"
	@echo ""
	@echo "Usage: make <command>"

# Build containers
build:
	@echo "🔨 Building all containers..."
	docker compose build

# Start services
up:
	@echo "🚀 Starting all services..."
	docker compose up -d
	@echo "✅ Services started!"
	@echo "📱 Frontend: http://localhost:8000"
	@echo "🔌 API Gateway: http://localhost:8080"
	@echo "❤️  Health Check: http://localhost:8080/health"

# Start and watch logs
up-logs:
	@echo "🚀 Starting services with logs..."
	docker compose up --build

# Stop services
down:
	@echo "🛑 Stopping all services..."
	docker compose down
	@echo "✅ Services stopped!"

# Show logs
logs:
	docker compose logs -f

# Show specific service logs
logs-frontend:
	docker compose logs -f frontend-1 frontend-2

logs-backend:
	docker compose logs -f backend-1 backend-2

logs-nginx:
	docker compose logs -f frontend-lb backend-lb

# Show container status
status:
	@echo "📊 Container Status:"
	docker compose ps
	@echo ""
	@echo "💾 Resource Usage:"
	docker stats --no-stream

# Test health endpoints
test:
	@echo "🔍 Testing health endpoints..."
	@echo "Frontend Health:"
	@curl -s http://localhost:8000/health || echo "Frontend not responding"
	@echo ""
	@echo "Backend Health:"
	@curl -s http://localhost:8080/health | jq . || echo "Backend not responding"

# Test load balancing distribution
test-load:
	@echo "🔄 Testing Load Balancing Distribution"
	@echo "======================================"
	@echo ""
	@echo "📊 Backend Load Balancing Test (10 requests to API Gateway):"
	@echo "------------------------------------------------------------"
	@for i in $$(seq 1 10); do \
		echo -n "Request $$i: "; \
		curl -s -I -H "Cache-Control: no-cache" http://localhost:8080/health | grep "X-Load-Balancer:" | head -1 || echo "No load balancer header"; \
	done
	@echo ""
	@echo "📊 Frontend Load Balancing Test (5 requests to Frontend):"
	@echo "----------------------------------------------------------"
	@for i in $$(seq 1 5); do \
		echo -n "Request $$i: "; \
		curl -s -I -H "Cache-Control: no-cache" http://localhost:8000/ | grep -E "X-Frontend-Server|X-Load-Balancer" | head -1 || echo "No frontend server header"; \
	done
	@echo ""
	@echo "🔍 Detailed Response Analysis:"
	@echo "------------------------------"
	@echo "Backend API Headers:"
	@curl -s -I http://localhost:8080/health | grep -E "(X-Load-Balancer|Server|nginx)"
	@echo ""
	@echo "Frontend Headers:"
	@curl -s -I http://localhost:8000/ | grep -E "(X-Frontend-Server|X-Load-Balancer|Server|nginx)"
	@echo ""
	@echo "🏆 Load Balancing Test Complete!"

# Test failover scenario
test-failover:
	@echo "🚨 Testing failover scenario..."
	@echo "Stopping backend-1..."
	docker compose stop backend-1
	@echo "Testing API still works (5 requests):"
	@for i in $$(seq 1 5); do \
		echo -n "Request $$i: "; \
		curl -s http://localhost:8080/health | jq -r '.status' 2>/dev/null || echo "Failed"; \
	done
	@echo "Restarting backend-1..."
	docker compose start backend-1
	@echo "✅ Failover test completed!"

# Test with high load
test-stress:
	@echo "🔥 Stress testing load balancing (50 requests)..."
	@echo "Backend distribution:"
	@for i in $$(seq 1 50); do \
		curl -s -I http://localhost:8080/health | grep "X-Load-Balancer: Backend-LB" >/dev/null && echo -n "✓" || echo -n "✗"; \
		if [ $$((i % 10)) -eq 0 ]; then echo " ($$i)"; fi; \
	done
	@echo ""
	@echo "Frontend distribution:"
	@for i in $$(seq 1 20); do \
		server=$$(curl -s -I http://localhost:8000/ | grep "X-Frontend-Server" | cut -d: -f3 | tr -d ' \r'); \
		if [ "$$server" = "172.23.0.6" ]; then echo -n "1"; else echo -n "2"; fi; \
		if [ $$((i % 10)) -eq 0 ]; then echo " ($$i)"; fi; \
	done
	@echo ""
	@echo "✅ Stress test completed!"



# Test latency and architecture analysis
test-latency:
	@echo "⚡ Testing API Latency & Architecture Analysis"
	@echo "=============================================="
	@echo ""
	@echo "📊 Current Architecture (Browser → frontend-lb:8080 → backend-lb → backend):"
	@echo "Average response time over 10 requests:"
	@total=0; \
	for i in $$(seq 1 10); do \
		start=$$(date +%s%N); \
		curl -s http://localhost:8080/health > /dev/null; \
		end=$$(date +%s%N); \
		duration=$$((($end - $start) / 1000000)); \
		echo "Request $$i: $${duration}ms"; \
		total=$$((total + duration)); \
	done; \
	avg=$$((total / 10)); \
	echo "Average: $${avg}ms"
	@echo ""
	@echo "🔍 Request Path Analysis:"
	@echo "Headers showing the path:"
	@curl -s -I http://localhost:8080/health | grep -E "(X-Load-Balancer|Server)"
	@echo ""
	@echo "📝 To compare with direct backend access:"
	@echo "   See compare_architectures.md for alternative models"



# Scale up services
scale-up:
	@echo "📈 Scaling up to 3 instances each..."
	docker compose up --scale backend-1=2 --scale backend-2=2 \
		--scale frontend-1=2 --scale frontend-2=2 -d
	@echo "✅ Scaled up successfully!"

# Scale down services  
scale-down:
	@echo "📉 Scaling down to 2 instances each..."
	docker compose up --scale backend-1=1 --scale backend-2=1 \
		--scale frontend-1=1 --scale frontend-2=1 -d
	@echo "✅ Scaled down successfully!"

# Start with monitoring
monitor:
	@echo "📊 Starting with monitoring enabled..."
	docker compose --profile monitoring up -d
	@echo "✅ Monitoring enabled!"
	@echo "📈 Nginx metrics: http://localhost:9113/metrics"

# Clean up everything
clean:
	@echo "🧹 Cleaning up everything..."
	docker compose down -v --rmi all
	docker system prune -f
	@echo "✅ Cleanup completed!"

# Quick restart
restart: down up

# Development mode (with logs)
dev:
	@echo "👨‍💻 Starting in development mode..."
	docker compose up --build

# Backend development only
dev-backend:
	@echo "🔧 Starting backend development environment..."
	@echo "⚠️  This will start backend + MySQL on different ports"
	cd backend && docker compose up --build

# Frontend development only  
dev-frontend:
	@echo "🎨 Starting frontend development environment..."
	@echo "Frontend will be available on http://localhost:3000"
	cd frontend && npm run dev

# Stop backend dev environment
down-backend:
	@echo "🛑 Stopping backend development environment..."
	cd backend && docker compose down

# Check nginx configs
check-nginx:
	@echo "🔍 Checking nginx configurations..."
	docker compose exec frontend-lb nginx -t
	docker compose exec backend-lb nginx -t
	@echo "✅ Nginx configs are valid!"

# Database access
db-connect:
	@echo "🗄️  Connecting to database..."
	docker compose exec mysql mysql -u demo_user -p demo_db

# Show environment info
info:
	@echo "ℹ️  Environment Information:"
	@echo "Docker version: $$(docker --version)"
	@echo "Docker Compose version: $$(docker compose --version)"
	@echo "Available ports:"
	@echo "  - 8000: Frontend Load Balancer"
	@echo "  - 8080: API Gateway"
	@echo "  - 3307: MySQL Database"
	@echo "  - 9113: Nginx Exporter (with monitoring profile)" 

setup-sql-master:
	docker exec -i mysql-master \
		mysql -uroot -prootpass -e "CREATE USER IF NOT EXISTS 'repl'@'%' IDENTIFIED WITH mysql_native_password BY 'replpass'; \
		GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%'; FLUSH PRIVILEGES; \
		FLUSH TABLES WITH READ LOCK; SHOW MASTER STATUS\G" > master-status.txt
setup-sql-slave:
	$(eval LOG_FILE=$(shell grep "File:" master-status.txt | awk '{print $$2}'))
	$(eval LOG_POS=$(shell grep "Position:" master-status.txt | awk '{print $$2}'))
	docker exec -i mysql-slave \
		mysql -uroot -prootpassword -e "CHANGE MASTER TO MASTER_HOST='mysql-master', MASTER_USER='repl', MASTER_PASSWORD='replpass', MASTER_LOG_FILE='$(LOG_FILE)', MASTER_LOG_POS=$(LOG_POS); START SLAVE;"
