# Setup a Webapp
In this task, I implemented a robust, cross-platform development environment. The setup utilizes **Vagrant** to provide a consistent virtualized Debian base, **Docker** for containerized services like MongoDB, and **Nix** for deterministic environment management.

By using **Nix flakes**, I've pinned the versions of Node.js and NPM, ensuring that every developer works with the exact same toolchain regardless of their host OS.

**To run the project:**
- Start the VM: `vagrant up`
- Log in: `vagrant ssh`
- Backend: `cd app/backend`, then `nix develop` → `npm install` → `npm start`
- Frontend: `cd app/frontend`, then `nix develop` → `npm install` → `npm start -- --no-open`
- Open `http://localhost:3000` in a browser to see the working web interface.