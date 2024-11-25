# Vagrantfile

Vagrant.configure("2") do |config|
  # Base Ubuntu 20.04 box
  config.vm.box = "ubuntu/focal64"
  # Nombre de la máquina virtual
  config.vm.hostname = "web-server"
  # Configurar la red privada con IP fija
  config.vm.network "private_network", ip: "192.168.56.12"
  # Forward port 80 for HTTP
  config.vm.network "forwarded_port", guest: 80, host: 8080
  # Set up resources for the virtual machine
  config.vm.provider "virtualbox" do |vb|
    # Nombre de la máquina virtual
    vb.name = "web-server"
    vb.memory = 1024/2
    vb.cpus = 1
  end
  # Provisión para instalar Jupyter y dependencias
  config.vm.provision "shell", path: "scripts/provision.sh"
  # Sync folder from host to guest
  config.vm.synced_folder ".", "/vagrant"
end