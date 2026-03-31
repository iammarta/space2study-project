Vagrant.configure("2") do |config|
  config.vm.box = "utm/bookworm"

  nodes = {
    "app-monitor-node" => { hostname: "app-monitor-node", ssh: 2221, mem: 4096, cpu: 2 },
    "cicd-node" => { hostname: "cicd-node", ssh: 2222, mem: 8192, cpu: 2 }
  }

  nodes.each do |name, conf|
    config.vm.define name do |node|
      node.vm.hostname = conf[:hostname]
      node.vm.network "forwarded_port", guest: 22, host: conf[:ssh], id: "ssh"

      node.vm.provider "utm" do |v|
        v.memory = conf[:mem]
        v.cpus = conf[:cpu]
      end

      node.vm.provision "shell", inline: <<-SHELL
        set -e

        apt-get update -y
        apt-get install -y curl rsync docker.io docker-compose

        if getent group docker >/dev/null 2>&1; then
          usermod -aG docker vagrant
        fi

        systemctl enable docker
        systemctl start docker
      SHELL
    end
  end
end