# Override sudo attributes
default['authorization']['sudo']['groups'] = 'bubble', 'sysadmin'
default['authorization']['sudo']['users'] = []
default['authorization']['sudo']['passwordless'] = true
default['authorization']['sudo']['include_sudoers_d'] = false
default['authorization']['sudo']['agent_forwarding'] = true
default['authorization']['sudo']['sudoers_defaults'] = ['!lecture,tty_tickets,!fqdn']
default['authorization']['sudo']['command_aliases'] = []

# DNS
default['resolver']['nameservers'] = ['192.168.22.1']
default['resolver']['search'] = 'cloud.lan'
default['bubble']['coredns']['name_server'] = '8.8.8.8:53 8.8.4.4:53'

# Customize chef-run
default['bubble']['users_databag'] = 'users'
default['bubble']['group_name'] = 'bubble'
default['bubble']['users'] = true
default['bubble']['sudo'] = true

default['bubble']['toolkit']['branch'] = 'master'
default['bubble']['toolkit']['git_sync'] = true

default['bubble']['packages'] = true
default['bubble']['data_disk'] = false
default['bubble']['data_disk_device'] = 'vdb'
default['bubble']['nfs'] = true

default['bubble']['softethervpn-server'] = true
default['bubble']['softethervpn-config'] = 'vpn_normal.batch'
default['bubble']['softethervpn-psk'] = 'softether'

default['bubble']['community-templates'] = true

default['bubble']['cloudinit-metaserv'] = true
default['bubble']['cloudinit-password'] = 'password'

default['bubble']['docker']['install'] = false
default['bubble']['docker']['version'] = '18.09.5'

default['bubble']['coredns']['version'] = '1.6.9'
coredns_version = node['bubble']['coredns']['version']
default['bubble']['coredns']['url'] = "https://github.com/coredns/coredns/releases/download/v#{coredns_version}/coredns_#{coredns_version}_linux_amd64.tgz"

default['bubble']['systemvm_template']['jenkins_url']  = 'https://beta-jenkins.mcc.schubergphilis.com/job/cosmic-systemvm/job/packer-build/lastSuccessfulBuild/artifact/packer_output/'
default['bubble']['systemvm_template']['jenkins_md5']  = 'md5.txt'
default['bubble']['systemvm_template']['internal_md5'] = 'cosmic-systemvm_md5.txt'
default['bubble']['systemvm_template']['name'] = 'cosmic-systemvm'

default['bubble']['minikube'] = false
default['bubble']['kubectl_download_url'] = 'https://storage.googleapis.com/kubernetes-release/release/v1.6.2/bin/linux/amd64/kubectl'
default['bubble']['docker-machine-driver-kvm_download_url'] = 'https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.7.0/docker-machine-driver-kvm'
default['bubble']['minikube_download_url'] = 'https://storage.googleapis.com/minikube/releases/v0.18.0/minikube-linux-amd64'

default['bubble']['helm'] = false
default['bubble']['helm_download_url'] = 'https://storage.googleapis.com/kubernetes-helm/helm-v2.2.2-linux-amd64.tar.gz'

default['bubble']['terraform'] = false
default['bubble']['terraform_download_url'] = 'https://releases.hashicorp.com/terraform/0.9.8/terraform_0.9.8_linux_amd64.zip'

default['bubble']['npm_packages'] = false

# Keep settings default and allow settting at project level
force_default['maven']['mavenrc']['opts'] = ''

# setting required when also running openssh cookbook
default['openssh']['client'] = {
  'strict_host_key_checking': 'no',
  'user_known_hosts_file': '/dev/null',
  'forward_agent': 'yes',
  "cs*": {
    "user": 'root',
  },
  "xen*": {
    "user": 'root',
  },
  "kvm*": {
    "user": 'root',
  },
  "nsx*": {
    "user": 'admin',
  },
}
