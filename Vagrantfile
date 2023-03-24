Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/focal64'

  config.vm.define 'es_master_01' do |es_master_01|
    es_master_01.vm.hostname = 'la-stack-es-master-01'
    es_master_01.vm.network 'private_network', ip: '10.0.100.10'
  end

  config.vm.define 'es_data_01' do |es_data_01|
    es_data_01.vm.hostname = 'la-stack-es-data-01'
    es_data_01.vm.network 'private_network', ip: '10.0.100.20'
  end

  config.vm.define 'es_data_02' do |es_data_02|
    es_data_02.vm.hostname = 'la-stack-es-data-02'
    es_data_02.vm.network 'private_network', ip: '10.0.100.30'
  end

  config.vm.define 'grafana' do |grafana|
    grafana.vm.hostname = 'la-stack-grafana-web-00'
    grafana.vm.network 'private_network', ip: '10.0.150.10'
  end

  config.vm.define 'ralph' do |ralph|
    ralph.vm.hostname = 'la-stack-ralph-00'
    ralph.vm.network 'private_network', ip: '10.0.200.10'
  end

  config.vm.provider 'virtualbox' do |v|
    v.memory = 2048
    v.cpus = 2
  end

  # config.ssh.insert_key = false
  # config.ssh.private_key_path = '~/.ssh/id_rsa_arkops'

  ## Copy personal public ssh key to the VMs to allow Ansible to connect to them
  public_key = File.read('id_rsa_arkops.pub')
  config.vm.provision 'shell', inline: <<-SCRIPT
      echo 'Copying ansible-vm public SSH Keys to the VM'
      mkdir -p /home/vagrant/.ssh
      chmod 700 /home/vagrant/.ssh
      echo '#{public_key}' >> /home/vagrant/.ssh/authorized_keys
      chmod -R 600 /home/vagrant/.ssh/authorized_keys
      echo 'Host 10.0.*.*' >> /home/vagrant/.ssh/config
      echo 'StrictHostKeyChecking no' >> /home/vagrant/.ssh/config
      echo 'UserKnownHostsFile /dev/null' >> /home/vagrant/.ssh/config
      chmod -R 600 /home/vagrant/.ssh/config
  SCRIPT

  ## This will not work in our case, we need to run vagrant up --no-provision first then vagrant provision
  ## but the provisioner will use only the first vagrant private key to connect and fail with the other VMs
  ## Even when we force set the private key in the ansible inventory file
  # config.vm.provision 'ansible' do |ansible|
  #   ansible.playbook = 'bootstrap.yml'
  #   ansible.inventory_path = 'inventories/vagrant.yaml'
  #   ansible.config_file = 'ansible.cfg'
  #   ansible.limit = 'all'
  #   ansible.verbose = '-vvv'
  # end
end
