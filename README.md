# Setup a Webapp
In this task, I implemented a robust, cross-platform development environment. The setup utilizes **Vagrant** to provide a consistent virtualized Debian base, **Docker** for containerized services like MongoDB, and **Nix** for deterministic environment management.

By using **Nix flakes**, I've pinned the versions of Node.js and NPM, ensuring that every developer works with the exact same toolchain regardless of their host OS.

**To run the project:**
- Start the VM: `vagrant up`
- Log in: `vagrant ssh`
- Backend: `cd app/backend`, then `nix develop` → `npm install` → `npm start`
- Frontend: `cd app/frontend`, then `nix develop` → `npm install` → `npm start -- --no-open`
- Open `http://localhost:3000` in a browser to see the working web interface.

# Deploying a Containerized Web Application
In this task, I containerized the Web Application using **Docker** and **Docker Compose**. The setup ensures environment consistency and "cloud-readiness" through isolated services for Frontend, Backend, and MongoDB.

I used **multi-stage builds** with **Nginx** to optimize the frontend image and implemented a centralized **.env** system for easy configuration of ports and API endpoints.

**To run the project:**
- Build and start all services: `docker-compose up --build -d`
- Frontend: Accessible at `http://localhost:3000`
- Backend API: Accessible at `http://localhost:5001`
- Database: MongoDB running on `localhost:27017`

# Artifact Management
In this task, I implemented a private **Docker Registry** using **Sonatype Nexus** to manage container images. This setup allows for centralized storage and versioning of the application's artifacts.

I configured a **Docker Hosted Repository**, enabling secure authentication and image tagging to ensure a consistent deployment pipeline.

**To access the Registry:**
- Nexus UI: `http://localhost:8081` (Use your administrator credentials)
- Docker Registry: Accessible at `localhost:8082`
- Artifacts: Versioned images are stored in the `space2study-registry` repository

# Monitoring Infrastructure and Application Performance
In this task, I implemented a comprehensive monitoring stack using **Prometheus**, **Grafana**, and **cAdvisor** to track the health of the infrastructure and the performance of containerized services.

**Key Metrics Tracked:**
- **CPU Usage:** Real-time processor load per service (Backend, Frontend, MongoDB, Nexus).
- **Memory Usage:** Precise RAM consumption to prevent OOM (Out of Memory) issues.
- **Memory Cached:** Monitoring system-level data caching for database and file performance.

# Configure Logging Mechanisms
In this task, I implemented a centralized logging system using **Grafana Loki** and **Promtail**. This setup allows for real-time aggregation and analysis of logs from all containerized services

**Key Logging Features:**
- **Service Labeling:** Logs are tagged with `service_name` for instant filtering in Grafana.
- **Log Levels:** Automatic identification of `info`, `warn`, and `error` levels with color-coded visualization.
- **Error Tracking:** Real-time monitoring of database connection statuses and application runtime warnings.

# Monitor Resource Usage and Plan for Scalability
In this task, I implemented resource management by adding **deploy limits** directly into the `docker-compose.yml` for all key services. This ensures that the infrastructure remains stable and prevents OOM (Out of Memory) issues.

I removed hardcoded `container_name` attributes to enable **horizontal scaling**, allowing the Docker engine to manage unique identifiers for service replicas without naming collisions.

**Key Technical Implementations:**
- **Memory Limits:** Defined strict constraints (e.g., **3GB for Nexus, 512MB for Backend & MongoDB**) to ensure predictable host performance.
- **Dynamic Naming:** Enabled scaling by removing static names, verified with `docker-compose up -d --scale backend=3 --scale frontend=2`.
- **Resource Monitoring:** Used `docker stats` to verify that memory limits are correctly enforced for each service replica.