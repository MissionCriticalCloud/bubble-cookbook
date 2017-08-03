require 'spec_helper'

build_run_deploy_01_maven_and_infra_build = 'sudo /data/shared/helper_scripts/cosmic/build_run_deploy.sh -w -x -m /data/shared/marvin/mct-zone1-cs1-kvm1-basic.cfg -H'
build_run_deploy_02_setup_infra = 'sudo /data/shared/helper_scripts/cosmic/build_run_deploy.sh -t -v -x -m /data/shared/marvin/mct-zone1-cs1-kvm1-basic.cfg -H'
build_run_deploy_03_deploy_dc = 'sudo /data/shared/helper_scripts/cosmic/build_run_deploy.sh -t -v -w -m /data/shared/marvin/mct-zone1-cs1-kvm1-basic.cfg -H'

describe 'bubble::default' do
  include_examples 'bubble::default_tests'

  describe command(build_run_deploy_01_maven_and_infra_build) do
    its(:stdout) {should contain('BUILD SUCCESS')}
    its(:stdout) {should contain('Note: cs1: Ready for duty!')}
    its(:stdout) {should contain('Note: kvm1: Ready for duty!')}
    its(:stdout) {should contain('Finished')}
  end

  include_examples 'bubble::check_cs1'
  include_examples 'bubble::check_kvm1'

  describe command(build_run_deploy_02_setup_infra) do
    its(:stdout) {should contain('==> Cosmic DB deployed at 192.168.22.61')}
    its(:stdout) {should contain('==> SystemVM templates installed')}
    its(:stdout) {should contain('==> WAR deployed')}
    its(:stdout) {should contain('==> Cosmic KVM Agent installed in kvm1')}
    its(:stdout) {should contain('==> Agent configured')}
    its(:stdout) {should contain('Finished')}
  end

  describe command(build_run_deploy_03_deploy_dc) do
    its(:stdout) {should contain('=== Deploy DC Successful ===')}
    its(:stdout) {should contain('All systemvms are Running, good!')}
    its(:stdout) {should contain('All templates are ready!')}
    its(:stdout) {should contain('Finished')}
  end

end
