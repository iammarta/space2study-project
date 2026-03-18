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
