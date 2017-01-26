# -*- mode: ruby -*-
# vi: set ft=ruby :
# Vagrantfile API/syntax version. Don't touch this!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.ssh.forward_agent = true

  # hostmanager will auto update /etc/hosts file
  if Vagrant.has_plugin?("vagrant-hostmanager")
    config.hostmanager.enabled     = true
    config.hostmanager.manage_host = true
  end

  config.vm.define "piwik" do |piwik|
    piwik.vm.box      = "bento/centos-7.2"
    piwik.vm.hostname = "piwik"
    piwik.vm.network :forwarded_port, host: 8888, guest: 80

    piwik.vm.synced_folder "../piwik/", "/usr/share/nginx/piwik/", mount_options: ["dmode=777,fmode=666"]

    piwik.vm.provision "salt" do |salt|
      salt.install_args  = "-D git v2015.5.1"
      salt.minion_config = "salt-minion-configs/piwik-dev-local.conf"
      salt.run_highstate = true
      salt.colorize      = true
      salt.log_level     = "warning"
    end

    config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end
  end

  config.vm.define "api" do |api|
    api.vm.box      = "bento/centos-7.2"
    api.vm.hostname = "api.local"
    api.vm.network :forwarded_port, host: 8891, guest: 80
    api.vm.network :forwarded_port, host: 8892, guest: 443

    api.vm.synced_folder "../api/", "/usr/share/nginx/api/"

    api.vm.provision "salt" do |salt|
      salt.install_args  = "-D git v2015.5.1"
      salt.minion_config = "salt-minion-configs/api-dev-local.conf"
      salt.run_highstate = true
      salt.colorize      = true
      salt.log_level     = "warning"
    end

    config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end
  end

  config.vm.define "tracktor" do |tracktor|
    tracktor.vm.box      = "bento/centos-7.2"
    tracktor.vm.hostname = "tracktor"
    tracktor.vm.network :forwarded_port, host: 8893, guest: 80
    tracktor.vm.network :forwarded_port, host: 8894, guest: 443

    tracktor.vm.provision "salt" do |salt|
      salt.install_args  = "-D git v2015.5.1"
      salt.minion_config = "salt-minion-configs/tracktor-dev-local.conf"
      salt.run_highstate = true
      salt.colorize      = true
      salt.log_level     = "warning"
    end

    config.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end
  end

end

