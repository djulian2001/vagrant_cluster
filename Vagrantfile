# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

current_dir    = File.dirname(File.expand_path(__FILE__))
configs        = YAML.load_file("#{current_dir}/vagrant_config.yaml")
vm_configs = configs['configs'][configs['configs']['use']]

Vagrant.configure(2) do |config|
  hosts = 2
  (1..hosts).each do |var|
    config.vm.define vm_configs['node']['vagrant_name'] % { :hook => var } do |remote_vm|
      remote_vm.vm.box = vm_configs['box']
      remote_vm.vm.box_version = vm_configs['box_version']
      remote_vm.vm.hostname = vm_configs['node']['hostname'] % { :hook => var }
      remote_vm.vm.network "private_network", ip:vm_configs['node']['private_ip'] % { :hook => var }
      
      remote_vm.vm.provider vm_configs["vm_box_type"] do |virtbox|
        virtbox.name = vm_configs['node']['vbox_name'] % { :hook => var }
        virtbox.memory = 256
      end
      
      remote_vm.vm.provision vm_configs['node']['provision_label'] % { :hook => var }, type:"shell" do |shell_provision|
        shell_provision.path = vm_configs['node']['provision_path']
      end
    end
  end
  
  config.vm.define vm_configs['manage']['vagrant_name'] do |manage_vm|
    manage_vm.vm.box = vm_configs['box']
    manage_vm.vm.box_version = vm_configs['box_version']
    manage_vm.vm.hostname = vm_configs['manage']['hostname']
    manage_vm.vm.network "private_network", ip:vm_configs['manage']['private_ip']

    manage_vm.vm.provider vm_configs["vm_box_type"] do |virtbox_mg|
      virtbox_mg.name = vm_configs['manage']['vbox_name']
      virtbox_mg.memory = 512
    end

    # manage_vm.vm.provision vm_configs['manage']['provision_label'], type:"shell" do |shell_provision_mg|
    #   shell_provision_mg.path = vm_configs['manage']['provision_path']
    #   shell_provision_mg.args = [vm_configs['arg_user_name'],vm_configs['arg_user_pass'],vm_configs['node']['private_ip'],hosts]
    # end
  end

  # resolves issues that virtualbox just can't seem to get right
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  # set 
  # config.vbguest.auto_update = false
end
