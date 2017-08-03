require 'spec_helper'

ssh_pass = 'sshpass -p password ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=quiet -t root@cs1 '
prepare_compile = ssh_pass + '"cd /data/shared/helper_scripts/cloudstack; ./prepare_cloudstack_compile.sh; ./prepare_cloudstack_compile.sh"'
build_run_deploy_test = ssh_pass + '"cd /data/shared/helper_scripts/cloudstack; ./build_run_deploy_test.sh -m /data/shared/marvin/mct-zone1-kvm1.cfg"'
keep_running = ssh_pass + '"cd /data/git/cs1/cloudstack; screen -dml mvn -pl :cloud-client-ui jetty:run > jetty.log 2>&1 ; sleep 3 "'

describe 'bubble::default' do
  include_examples 'bubble::default_tests'

  include_examples 'bubble::deploy_cs1'
  include_examples 'bubble::check_cs1'

  include_examples 'bubble::deploy_kvm1'
  include_examples 'bubble::check_kvm1'

  describe command(prepare_compile) do
    its(:stdout) {should contain('Git Apache CloudStack repo already found')}
    its(:stdout) {should contain('/data/git/cs1/cloudstack')}
  end

  describe command(build_run_deploy_test) do
    its(:stdout) {should contain('====Deploy DC Successful=====')}
    its(:stdout) {should contain('All templates are ready!')}
    its(:stdout) {should contain('Finished')}
  end

  describe command(keep_running) do
    its(:exit_status) { should eq 0 }
  end
end
