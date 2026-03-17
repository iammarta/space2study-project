Vagrant.configure("2") do |config|
  
  # Select box based on architecture (Apple Silicon vs Intel/AMD)
  if RUBY_PLATFORM =~ /arm64|aarch64/
    config.vm.box = "utm/bookworm" 
  else
    config.vm.box = "debian/bookworm64"
  end
  
  # Network forwarding for Frontend (3000) and Backend (5001)
  config.vm.network "forwarded_port", guest: 3000, host: 3000
  config.vm.network "forwarded_port", guest: 5001, host: 5001
  
  # Resources allocation for UTM (Apple Silicon)
  config.vm.provider "utm" do |utm|
    utm.cpus = 2
    utm.memory = 4096
  end
  
  # Resources allocation for VirtualBox (Intel/AMD)
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 2
    vb.memory = 4096
  end

  config.vm.provision "shell", inline: <<-SHELL
    set -e
    
    # Install Docker and necessary system utilities
    apt-get update -y
    apt-get install -y docker.io git rsync curl
    
    # Setup Docker permissions for vagrant user
    systemctl start docker
    systemctl enable docker
    usermod -aG docker vagrant
    
    # Install Nix Package Manager in multi-user mode
    rm -f /etc/bash.bashrc.backup-before-nix
    if ! command -v nix &> /dev/null; then
      curl -L https://nixos.org/nix/install | sh -s -- --daemon --yes
    fi
    
    # Enable Nix Flakes and experimental features
    mkdir -p /home/vagrant/.config/nix
    echo "experimental-features = nix-command flakes" > /home/vagrant/.config/nix/nix.conf
    chown -R vagrant:vagrant /home/vagrant/.config
    
    # Sync project files to the VM
    mkdir -p /home/vagrant/app
    rsync -av --exclude='.git' --exclude='node_modules' /vagrant/ /home/vagrant/app/
    chown -R vagrant:vagrant /home/vagrant/app
    
    # Automatically manage MongoDB container
    echo "Checking MongoDB container..."
    if ! docker ps -a --format '{{.Names}}' | grep -q '^mongodb$'; then
      echo "Creating and starting MongoDB container..."
      docker run -d --name mongodb -p 27017:27017 --restart always mongo:6.0
    else
      echo "Starting existing MongoDB container..."
      docker start mongodb
    fi
  SHELL
end