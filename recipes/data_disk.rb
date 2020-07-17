# The device of the external disk (e.g. /dev/hdb)
disk_device = node['bubble']['data_disk_device']

group = node['bubble']['group_name']
# Create Data directory to mount
directory '/data' do
  owner 'root'
  group group
  mode '0775'
  recursive true
  action :create
end

# Partition and format the Data disk
parted_disk "/dev/#{disk_device}" do
  label_type 'gpt'
  part_type 'primary'
  file_system 'ext4'
  action [:mklabel, :mkpart]
end

parted_disk "/dev/#{disk_device}1" do
  file_system 'ext4'
  action :mkfs
end

include_recipe 'parted'

# Mount Data
mount '/data' do
  device "/dev/#{disk_device}1"
  fstype 'ext4'
  action [:mount, :enable]
end

execute "chown-chmod-data" do
  command "chown -R root:#{group} /data;chmod -R g=u /data"
  user "root"
  action :run
end
