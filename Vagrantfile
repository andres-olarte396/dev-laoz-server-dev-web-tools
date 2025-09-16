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
  # Forward port 443 for HTTPS
  config.vm.network "forwarded_port", guest: 443, host: 8443
  # Forward port 3002 for Jupyter
  config.vm.network "forwarded_port", guest: 3002, host: 3210  
  # Set up resources for the virtual machine
  config.vm.provider "virtualbox" do |vb|
    # Nombre de la máquina virtual
    vb.name = "web-server"
    # Memoria RAM (1/4 de la memoria total del host)
    vb.memory = 1024
    # Número de CPUs
    vb.cpus = 2
  end
  # Provisión para instalar Jupyter y dependencias
  config.vm.provision "shell", path: "scripts/provision.sh"
  # Sync folder from host to guest
  config.vm.synced_folder ".", "/vagrant"
end