require 'serverspec'

set :backend, :exec

shared_examples 'bubble::default_tests' do
  describe service('libvirtd') do
    it { should be_enabled }
    it { should be_running }
  end

  describe command('curl -s http://127.0.0.1:8080') do
    its(:stdout) { should contain('password') }
  end

  describe command('curl -s http://127.0.0.1/latest/meta-data/instance-id') do
    its(:stdout) { should match(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/) }
  end

  describe command('virsh net-list') do
    its(:stdout) { should match(/NAT\s+active/)}
  end

  describe command('/usr/sbin/brctl show') do
    its(:stdout) { should contain('tap_vpn')}
    its(:stdout) { should contain('virbr0')}
  end

  describe file('/etc/resolv.conf') do
    its(:content) { should match /^search cloud.lan/ }
    its(:content) { should match /^nameserver 192.168.22.1$/ }
  end
end

shared_examples 'bubble::deploy_cs1' do
  describe command('cd /data/shared/deploy; sudo ./kvm_local_deploy.py --deploy-role cloudstack-mgt-dev -d 1 --force') do
    its(:stdout) {should contain('Examining the guest')}
    its(:stdout) {should contain('Installing firstboot script')}
    its(:stdout) {should contain('Finishing off')}
    its(:stdout) {should contain('Running postboot script')}
    its(:stdout) {should contain('Installing and configuring')}
    its(:stdout) {should contain('Ready for duty!')}
  end
end

shared_examples 'bubble::check_cs1' do
  describe command('sshpass -p password ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -t root@cs1 "mount | grep data"') do
    its(:stdout) {should contain('192.168.22.1:/data')}
  end
end


shared_examples 'bubble::deploy_kvm1' do
  describe command('cd /data/shared/deploy; sudo ./kvm_local_deploy.py --deploy-role  kvm --digit 1 --force') do
    its(:stdout) {should contain('Examining the guest')}
    its(:stdout) {should contain('Installing firstboot script')}
    its(:stdout) {should contain('Finishing off')}
    its(:stdout) {should contain('Running postboot script')}
    its(:stdout) {should contain('Installing and configuring')}
    its(:stdout) {should contain('Ready for duty!')}
  end
end

shared_examples 'bubble::check_kvm1' do
  describe command('sshpass -p password ssh -o PreferredAuthentications=password -o PubkeyAuthentication=no -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -t root@kvm1 "mount | grep data"') do
    its(:stdout) {should contain('192.168.22.1:/data')}
  end
end
