name 'bubble'
maintainer 'Schuberg Philis'
maintainer_email 'fneubauer@schubergphilis.com'
license 'Apache-2.0'
description 'Installs/Configures the "bubble" for developing'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url 'https://github.com/MissionCriticalCloud/bubble-cookbook'
issues_url 'https://github.com/MissionCriticalCloud/bubble-cookbook/issues'
chef_version '~> 14.0'
version '0.3.0'

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
