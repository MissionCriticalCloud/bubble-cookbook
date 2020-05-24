# Use Chef cache as tmp location
tmp_loc = Chef::Config[:file_cache_path]

# Copy KVM configuration files
remote_directory "/#{tmp_loc}/libvirt" do
  source 'libvirt'
end

cookbook_file '/etc/modprobe.d/kvm-nested.conf' do
  source 'kvm/kvm-nested.conf'
  owner 'root'
  group 'root'
  mode '0644'
end

# Copy virbr0.50 and vpn tap device vlan network configuration
remote_directory '/etc/sysconfig/network-scripts' do
  source 'network'
end

# Copy rc.local for delayed initialization of virbr0.50 and vpn interface
cookbook_file '/etc/rc.d/rc.local' do
  source 'rc.local/rc.local'
  owner 'root'
  group 'root'
  mode '0755'
end

# Copy dhclient.conf to resolve via the libvirt dns
cookbook_file '/etc/dhcp/dhclient.conf' do
  source 'dhcp/dhclient.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create_if_missing
end

# Copy polkit configurtion to let user use virt-manager
template '/etc/polkit-1/localauthority/50-local.d/50-libvirt.pkla' do
  source '50-libvirt.pkla.erb'
  variables(
    group_name: node['bubble']['group_name']
  )
end

# Set LIBVIRT environment to make a user use virsh
cookbook_file '/etc/profile.d/libvirt.sh' do
  source 'profile.d/libvirt.sh'
  owner 'root'
  group 'root'
  mode '0755'
  action :create_if_missing
end

# Restart network after libvirtd
service 'network' do
  action :nothing
end

# Enable and start libvirtd
service 'libvirtd' do
  action [:start, :enable]
  notifies :restart, 'service[network]'
end

# Import libvirt configurations
bash 'Configure_NAT_network' do
  user 'root'
  cwd "/#{tmp_loc}/libvirt"
  code <<-EOH
  virsh net-destroy default
  virsh net-undefine default
  virsh net-define net_NAT.xml
  virsh net-start NAT
  virsh net-autostart NAT
  EOH
  not_if { ::File.exist?('/etc/libvirt/qemu/networks/NAT.xml') }
end

bash 'Configure_ZONE2_network' do
  user 'root'
  cwd "/#{tmp_loc}/libvirt"
  code <<-EOH
  virsh net-define net_ZONE2.xml
  virsh net-start ZONE2
  virsh net-autostart ZONE2
  EOH
  not_if { ::File.exist?('/etc/libvirt/qemu/networks/ZONE2.xml') }
end

bash 'Configure_default_images_dir' do
  user 'root'
  cwd "#{tmp_loc}/libvirt"
  code <<-EOH
   virsh pool-destroy default
   virsh pool-undefine default
   virsh pool-define pool_images.xml
   virsh pool-build default
   virsh pool-start default
   virsh pool-autostart default
  EOH
  not_if { ::File.exist?('/etc/libvirt/storage/autostart/default.xml') }
end

bash 'Configure_default_iso_dir' do
  user 'root'
  cwd "/#{tmp_loc}/libvirt"
  code <<-EOH
   virsh pool-destroy iso
   virsh pool-define pool_iso.xml
   virsh pool-build iso
   virsh pool-start iso
   virsh pool-autostart iso
  EOH
  not_if { ::File.exist?('/etc/libvirt/storage/autostart/iso.xml') }
end

# Remove unwanted docker network if Docker is not installed
if !node['bubble']['docker']['install']
  bash 'Configure_docker-machines_network' do
    user 'root'
    code <<-EOH
    virsh net-destroy docker-machines
    virsh net-undefine docker-machines
    EOH
    only_if { ::File.exist?('/etc/libvirt/qemu/networks/docker-machines.xml') }
  end
end
