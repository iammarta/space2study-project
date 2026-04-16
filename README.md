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
In this task, I automated the deployment of the web application using **Ansible** and **Kubernetes (k3s)**. The playbook provisions the runtime environment, installs required tools (Docker, k3s, Helm), configures access to AWS, and deploys the application using Kubernetes manifests.

The deployment process includes:
- Rendering templated Kubernetes manifests using Ansible (e.g., deployments, config maps, ingress)
- Creating Kubernetes resources via `kubectl apply -k`
- Authenticating with AWS ECR and creating image pull secrets
- Installing monitoring components via Helm

# Orchestration Web Application via k8s
In this task, I migrated the application to **Kubernetes (k3s)** and implemented container orchestration using **Deployments, Services, and Ingress**.

The application is deployed with multiple replicas for both backend and frontend, enabling **horizontal scaling** and **high availability**. I configured a **RollingUpdate strategy** to ensure zero-downtime deployments.

Traffic routing is handled via **Traefik Ingress Controller**, which routes requests to the appropriate services based on URL paths.

# Implement Secret Management Strategies
In this task, I implemented a multi-layered secret management approach to securely handle sensitive data.

The solution includes:
- **Ansible Vault** for encrypting sensitive variables (e.g., AWS credentials)
- **AWS Secrets Manager** for storing external secrets (e.g., Grafana credentials)
- **Kubernetes Secrets** for securely injecting runtime configuration into pods (e.g., image pull secrets)

Secrets are not stored in plain text in the repository and are dynamically retrieved and injected during deployment. This approach improves security and aligns with best practices for handling sensitive data in cloud-native environments.

# Migrate an Application to the Cloud
In this task, I migrated the application from a local environment to **AWS cloud infrastructure**.

Using **Terraform**, I provisioned cloud resources including:
- VPC and networking components
- EC2 instance for runtime
- Security groups
- Elastic IP for stable public access
- Amazon ECR for container image storage
- S3 bucket for remote Terraform state storage

The application is now accessible via a custom domain (`space2study.online`) and deployed on a cloud-based Kubernetes cluster (k3s).

