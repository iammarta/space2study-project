# Setup a Webapp

# Deploying a Containerized Web Application
In this task, I containerized a web application using **Docker** and **Docker Compose**. I also implemented **multi-stage builds** and followed best practices to optimize the application. To build and start all services: `docker-compose up --build -d`

# Artifact Management
In this task, I implemented a private **Docker Registry** using **Sonatype Nexus** to manage container images. This setup allows for centralized storage and versioning of the application's artifacts.

# Monitoring Infrastructure and Application Performance
In this task, I implemented a comprehensive monitoring stack using **Prometheus**, **Grafana**, and **cAdvisor** to track the health of the infrastructure and the performance of containerized services.

# Configure Logging Mechanisms
In this task, I implemented a centralized logging system using **Grafana Loki** and **Promtail**. This setup allows for real-time aggregation and analysis of logs from all containerized services

# Monitor Resource Usage and Plan for Scalability
To control resource usage, I configured limits for all services in `docker-compose.yml`:
- Used **YAML anchors** to define reusable templates for CPU and memory limits
- Applied limits to all containers to prevent resource exhaustion
- **Storage Control:** Configured Loki (168h) to automatically delete old data and save disk space.

**Verification:**
- Used `docker stats` to confirm resource usage
- Observed that services stay within defined limits
- Verified horizontal scaling using:
`docker-compose up --scale backend=3`

**Scaling approach:**
- **Backend / Frontend** - scalable horizontally (multiple replicas)
- **Nexus** - requires more memory (vertical scaling)
 
**Bottleneck Analysis**
During testing:
- Identified **Nexus** as the most resource-intensive service
- It runs on Java and requires significantly more memory than other services

**Solution:**
- Assigned a higher memory limit (2.2GB) to Nexus due to its Java-based nature.
- Additionally, configured JVM memory parameters via `INSTALL4J_ADD_VM_PARAMS` to further control its memory usage.