mount '/tmp' do
  device 'tmpfs'
  action :disable
  notifies :reboot_now, 'reboot[Reboot for unmounting tmpfs]', :immediately
end

reboot 'Reboot for unmounting tmpfs' do
  action :nothing
  reason 'Reboot for unmounting tmpfs'
end
