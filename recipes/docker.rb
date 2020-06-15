docker_installation_package 'default' do
  version node['bubble']['docker']['version'] if node['bubble']['docker']['version']
  action :create
  only_if { node['bubble']['docker']['install'] }
end

# Add docker service.
interfaces = shell_out('/usr/sbin/ip a')
docker_service 'default' do
  host ['unix:///var/run/docker.sock', 'tcp://127.0.0.1:2375']
  group node['bubble']['group_name']
  bridge 'virbr0'
  fixed_cidr '192.168.22.224/27'
  action [:create, :start]
  notifies :create, 'cookbook_file[/opt/coredns/dnsthing.py]'
  notifies :create, 'cookbook_file[/etc/systemd/system/dnsthing.service]'
  only_if { interfaces.stdout.include? 'virbr0' }
end

# Add dnsthing binary
cookbook_file '/opt/coredns/dnsthing.py' do
  source 'coredns/dnsthing.py'
  owner 'coredns'
  group node['bubble']['group_name']
  mode '0755'
  action :nothing
  notifies :restart, 'service[dnsthing]', :delayed
end

# Install systemd service for dnsthing server
cookbook_file '/etc/systemd/system/dnsthing.service' do
  source 'coredns/dnsthing.service'
  owner 'root'
  owner 'root'
  mode '0644'
  action :nothing
  notifies :restart, 'service[dnsthing]', :delayed
end

package 'python-docker-py'

# Enable and start the dnsthing server service
service 'dnsthing' do
  action [:enable, :start]
  only_if { ::File.exist?('/etc/systemd/system/dnsthing.service') }
end
