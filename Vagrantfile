Vagrant.configure("2") do |config|
  is_arm = RUBY_PLATFORM =~ /arm64|aarch64/
  config.vm.box = is_arm ? "utm/bookworm" : "debian/bookworm64"

  nodes = {
    "app_node"     => { hostname: "app-node",     ssh: 2221, g_port: 80,   h_port: 8080, mem: 1536, cpu: 1 },
    "monitor_node" => { hostname: "monitor-node", ssh: 2222, g_port: 3000, h_port: 3001, mem: 1536, cpu: 1 },
    "devops_node"  => { hostname: "devops-node",  ssh: 2223, g_port: 8080, h_port: 8085, mem: 4096, cpu: 2 }
  }

  nodes.each do |name, conf|
    config.vm.define name do |node|
      node.vm.hostname = conf[:hostname]

      node.vm.network "forwarded_port", guest: 22, host: conf[:ssh], id: "ssh", auto_correct: true
      node.vm.network "forwarded_port", guest: conf[:g_port], host: conf[:h_port], auto_correct: true

      node.ssh.host = "127.0.0.1"
      node.ssh.port = conf[:ssh]
      node.ssh.username = "vagrant"
      node.ssh.insert_key = false

      node.vm.provider "utm" do |v|
        v.memory = conf[:mem]
        v.cpus = conf[:cpu]
      end

      node.vm.provision "shell", inline: <<-SHELL

        if ! command -v docker >/dev/null 2>&1; then
          apt-get update -y
          apt-get install -y docker.io docker-compose curl rsync
          usermod -aG docker vagrant
          systemctl enable --now docker
        fi

        sed -i '/app-node\\|monitor-node\\|devops-node/d' /etc/hosts

        echo "# Vagrant nodes" >> /etc/hosts
      SHELL
    end
  end
end