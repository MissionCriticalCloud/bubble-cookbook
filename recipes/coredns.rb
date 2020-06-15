# Add a user for coredns
user 'coredns' do
  comment 'coredns user'
  gid node['bubble']['group_name']
  home '/home/coredns'
  shell '/bin/bash'
  manage_home true
end

# Create directory for coredns binary
directory '/opt/coredns' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# Add coredns binary from github releases
tar_extract node['bubble']['coredns']['url'] do
  action :extract
  target_dir '/opt/coredns/'
  creates '/opt/coredns/coredns'
end

file '/opt/coredns/coredns' do
  owner 'coredns'
  group node['bubble']['group_name']
  mode '0755'
end

# Add coredns config
name_server = node['bubble']['coredns']['name_server']

domain_list = []
domain_list = ['docker.cloud.lan'] if node['bubble']['docker']['install']
template '/etc/coredns/Corefile' do
  source 'coredns/Corefile.erb'
  owner 'coredns'
  group node['bubble']['group_name']
  mode '0755'
  variables(
    name_server: name_server,
    domain_list: domain_list
  )
  action :create
  notifies :restart, 'service[coredns]', :delayed
end

# Install systemd service for coredns server
cookbook_file '/etc/systemd/system/coredns.service' do
  source 'coredns/coredns.service'
  owner 'root'
  owner 'root'
  mode '0644'
  action :create
  notifies :restart, 'service[coredns]', :delayed
end

# Make sure a zone file exists.
file '/home/coredns/docker.cloud.lan' do
  content ''
  mode '0755'
  owner 'coredns'
  group node['bubble']['group_name']
  action :create_if_missing
end

# Enable and start the coredns server service
service 'coredns' do
  action [:enable, :start]
end
