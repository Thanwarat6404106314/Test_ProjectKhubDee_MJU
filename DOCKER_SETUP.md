# Khubdeemju Docker Setup

## What was configured:

1. **Created Dockerfile** for khubdeemju Spring Boot application at `khubdeemju/Dockerfile`
   - Uses OpenJDK 17 (matching your Spring Boot 3.3.1 requirement)
   - Exposes port 8081

2. **Updated application.properties**
   - Changed database URL from `localhost` to `mysql` (Docker container name)
   - This allows the application to connect to MySQL within the Docker network

3. **Added khubdeemju service to docker-compose.yaml**
   - Service name: `khubdeemju`
   - Container name: `khubdee-khubdeemju`
   - Exposed on host port: **8083** (mapped to container port 8081)
   - Depends on MySQL container being healthy before starting

4. **Updated MySQL service** in docker-compose.yaml
   - Added port mapping `3306:3306` to allow external access if needed

## How to run:

### Step 1: Build the JAR file
```powershell
cd khubdeemju
mvn clean package -DskipTests
cd ..
```

### Step 2: Build and start all Docker containers
```powershell
docker compose build
docker compose up -d
```

### Step 3: Check container status
```powershell
docker compose ps
```

### Step 4: View logs
```powershell
# All services
docker compose logs -f

# Only khubdeemju
docker compose logs -f khubdeemju

# Only MySQL
docker compose logs -f mysql
```

## Access points:

- **Khubdeemju API**: http://localhost:8083
- **Tomcat (Website)**: http://localhost:8081
- **phpMyAdmin**: http://localhost:8082
- **MySQL**: localhost:3306 (for external tools like MySQL Workbench)

## Useful commands:

```powershell
# Stop all containers
docker compose down

# Rebuild and restart a specific service
docker compose up -d --build khubdeemju

# View real-time logs
docker compose logs -f khubdeemju

# Restart just the khubdeemju service
docker compose restart khubdeemju

# Access container shell
docker exec -it khubdee-khubdeemju sh
```

## Network architecture:

All services run in the `khubdee-network` Docker network:
- `mysql` - MySQL database (internal port 3306, external 3306)
- `khubdeemju` - Spring Boot API (internal port 8081, external 8083)
- `tomcat` - Website (internal port 8080, external 8081)
- `phpmyadmin` - Database admin tool (internal port 80, external 8082)

Services communicate using container names as hostnames within the network.
