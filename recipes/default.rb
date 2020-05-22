# Recipes controlled by attributes
include_recipe 'bubble::packages' if node['bubble']['packages']
group node['bubble']['group_name']
include_recipe 'bubble::users' if node['bubble']['users']
include_recipe 'bubble::data_disk' if node['bubble']['data_disk']
include_recipe 'bubble::nfs' if node['bubble']['nfs']
include_recipe 'bubble::community-templates' if node['bubble']['community-templates']
include_recipe 'bubble::softethervpn-server' if node['bubble']['softethervpn-server']
include_recipe 'bubble::internal-templates' if node['bubble']['internal-templates']
include_recipe 'bubble::cloudinit-metaserv' if node['bubble']['cloudinit-metaserv']
include_recipe 'sudo' if node['bubble']['sudo']
include_recipe 'bubble::docker' if node['bubble']['docker']['install']
include_recipe 'bubble::coredns'
include_recipe 'bubble::libvirt'
include_recipe 'bubble::minikube' if node['bubble']['minikube']
include_recipe 'bubble::helm' if node['bubble']['helm']
include_recipe 'bubble::terraform' if node['bubble']['terraform']
include_recipe 'bubble::npm_packages' if node['bubble']['npm_packages']

# Copy ssh_config to manage global SSH settings
cookbook_file '/etc/ssh/ssh_config' do
  source 'ssh/ssh_config'
  owner 'root'
  group 'root'
  mode '0644'
end

# Create base directory structure on /data
%w( /data/iso /data/images /data/git /data/shared ).each do |path|
  directory path do
    owner 'root'
    group node['bubble']['group_name']
    mode '0775'
    recursive true
    action :create
  end
end

# Sync the MCT shared repository
git '/data/shared' do
  repository 'https://github.com/MissionCriticalCloud/bubble-toolkit.git'
  # revision 'master'
  revision node['bubble']['toolkit']['branch']
  group node['bubble']['group_name']
  action :sync
end

# Install python clint for kvm_local_deploy
package 'python2-clint'

# Disable and stop firewalld
service 'firewalld' do
  action [ :disable, :stop ]
end
