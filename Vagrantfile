# -*- mode: ruby -*-
# vim: set ft=ruby :

vms_path = %x(VBoxManage list systemproperties |
  grep "Default machine folder:" | awk '{print $4}' | tr -d '\n')
name_machine = "mdadm-012020"

MACHINES = {
  :"#{name_machine}" => {
    :box_name => "centos/7",
    :ip_addr => "192.168.11.101",
    :disks => {
      :sata1 => {
        :dfile => "#{vms_path}/#{name_machine}/sata1.vdi",
        :size => 40960,
        :port => 1
      },
      :sata2 => {
        :dfile => "#{vms_path}/#{name_machine}/sata2.vdi",
        :size => 250, # Megabytes
        :port => 2
      },
      :sata3 => {
        :dfile => "#{vms_path}/#{name_machine}/sata3.vdi",
        :size => 250,
        :port => 3
      },
      :sata4 => {
        :dfile => "#{vms_path}/#{name_machine}/sata4.vdi",
        :size => 250, # Megabytes
        :port => 4
      },
      :sata5 => {
        :dfile => "#{vms_path}/#{name_machine}/sata5.vdi",
        :size => 250, # Megabytes
        :port => 5
      },
      :sata6 => {
        :dfile => "#{vms_path}/#{name_machine}/sata6.vdi",
        :size => 250, # Megabytes
        :port => 6
      }
    }
  },
}

Vagrant.configure("2") do |config|
  MACHINES.each do |boxname, boxconfig|
    config.vm.define boxname do |box|
      box.vm.box = boxconfig[:box_name]
      box.vm.host_name = boxname.to_s

      # box.vm.network "forwarded_port", guest: 3260, host: 3260+offset

      box.vm.network "private_network", ip: boxconfig[:ip_addr]
      
      box.vm.provider "virtualbox" do |vb|
        vb.name = name_machine
        vb.customize ['modifyvm', :id, '--memory', '1024']
        needsController = false
        boxconfig[:disks].each do |dname, dconf|
          unless File.exist?(dconf[:dfile])
            vb.customize ['createhd', '--filename', dconf[:dfile], '--variant', 'Standard', '--size', dconf[:size]]
            needsController = true
                 end
        end
        if needsController == true
          vb.customize ['storagectl', :id, '--name', 'SATA', '--add', 'sata']
          boxconfig[:disks].each do |dname, dconf|
            vb.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', dconf[:port], '--device', 0, '--type', 'hdd', '--medium', dconf[:dfile]]
          end
        end
      end
      box.vm.provision 'shell', inline: <<-SHELL
          mkdir -p ~root/.ssh
          cp ~vagrant/.ssh/auth* ~root/.ssh
          yum install -y mdadm
      SHELL
      box.vm.provision 'shell', path: 'scripts/build_raid.sh'
    end
  end
end
