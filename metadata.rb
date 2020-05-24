name 'bubble'
maintainer 'Schuberg Philis'
maintainer_email 'fneubauer@schubergphilis.com'
license 'Apache-2.0'
description 'Installs/Configures the "bubble" for developing'
source_url 'https://github.com/MissionCriticalCloud/bubble-cookbook'
issues_url 'https://github.com/MissionCriticalCloud/bubble-cookbook/issues'
chef_version '~> 14.0'
version '0.3.1'

%w( centos fedora redhat ).each do |os|
  supports os
end

depends 'parted'
depends 'nfs'
depends 'users'
depends 'tar'
depends 'sudo'
depends 'chef-client'
depends 'docker'
depends 'maven'
depends 'nodejs'
depends 'openssh'
