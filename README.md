# Setup a Webapp
In this task, I prepared a local **multi-node** environment using **Vagrant** and **UTM**. I defined separate virtual machines for the application/monitoring node and the CI/CD node, and automated Docker installation and basic node provisioning through the Vagrantfile.

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
- Solution: Assigned a higher memory limit (2.2GB) to Nexus due to its Java-based nature.

# Implement a Continuous Integration / Continuous Delivery
In this task, I implemented a CI/CD pipeline using **Jenkins**. The pipeline automates source code checkout, container image build, and publishing images to a container registry, reducing manual work and preparing the project for automated delivery.

# Implement CCI (Continuous Code Inspection)
In this task, I integrated **SonarQube** into the Jenkins pipeline to perform Continuous Code Inspection for both backend and frontend. This setup allows automated code quality analysis during pipeline execution and helps detect issues early in the development process.

# Setup Load Balancing for Webapp
In this task, I configured **Nginx** as a load balancer and reverse proxy for the web application. It routes `/api/` requests to the backend and `/` requests to the frontend, while using the **least connections** algorithm and Docker **DNS resolver** for service discovery.

# Implement Infrastructure as Code
In this task, I implemented Infrastructure as Code using **Terraform** with a **modular structure**. I automated provisioning of AWS resources including **VPC, subnet, security group, EC2 instance, Elastic IP, and ECR repositories**, and also configured remote Terraform state storage in an **S3 bucket**.

# Scanning Images and Dependencies in CI/CD
In this task, I added security scanning to the Jenkins pipeline. **Snyk** is used to scan backend and frontend dependencies for known vulnerabilities, while **Trivy** is used to scan Docker images before they are pushed to the registry.

# Implement Automatisation Setup a Webapp
In this task, I automated web application deployment using **Ansible roles**. The playbook prepares the runtime server, installs the required tools, authenticates with AWS ECR, pulls the latest backend and frontend images, and starts the full application stack with Docker Compose. During this task, I also replaced the previously used local Nexus registry with AWS ECR to make deployment suitable for the cloud environment.