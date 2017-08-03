Bubble cookbook
==============================
This cookbook installs all components to run a Cosmic/ACS Cloudstack development environment based on KVM nested virtualization.

This "bubble" is the base for using all tools that are located in the bubble-toolkit to do development on Cosmic and Apache Cloudstack. It gives the developer the opportunity to write, run and test his code against "real" hardware.

![bubble running](https://cloud.githubusercontent.com/assets/1392945/13878645/09e3e1ee-ed13-11e5-9119-c7dc595e5cbb.png)
![bubble nuc](https://cloud.githubusercontent.com/assets/1392945/13878657/1e19cb2e-ed13-11e5-8dff-0f4f3855196a.png)

Requirements
------------
The "bubble" has been developed on CentOS 7.x and has no plans to support other distributions yet.

The following requirements need to be met:

* Intel based processor that supports virtualization (Haswell or better recommended)
* 100+GB Harddrive (for templates and sourcecode)
* Centos 7(.2) Minimal installation (adjust disk layout to provide /data dir)
* `/tmp` MUST be larger then 1GB (e.g. when using tmpfs), due to download of images >1GB

Attributes
----------
* `node['bubble']['users_databag']` - The databag that contains the users created (users)
* `node['bubble']['group_name']` - The groupname of the user(s) to allow users to create/delete virtual machines (bubble)
* `node['bubble']['packages']` - This enables/disables the packages recipe (true)
* `node['bubble']['users']` - This enables/disables the user creation recipe (true)
* `node['bubble']['sudo']` - This enables/disables the sudo recipe to give the created users sudo rights (true)
* `node['bubble']['data_disk']` - This allows for the addition of an extra disk that contains /data (false)
* `node['bubble']['data_disk_device']` - This is the name of the device (e.g /dev/hdb) (vdb)
* `node['bubble']['nfs']` - This enables/disables the nfs recipe that provides the nfs server in the bubble (true)
* `node['bubble']['softethervpn-server']` - This enables/disables the softethervpn server to reach the vm's in virbr0 (true)
* `node['bubble']['softethervpn-config']` - The configuration file used for softethervpn
* `node['bubble']['softethervpn-psk']` - The preshared key used in the L2TP vpn confuguration (softether)
* `node['bubble']['community-templates']` - This enables/disables the download of templates in the community (true)
* `node['bubble']['cloudinit-metaserv']` - This enables/disables the metaserver to serve cloud-init configuration (true)
* `node['bubble']['cloudinit-password']` - This password sent to the virtual machines via cloud-init (password)

Usage
-----
This cookbook is provided with a set of default attributes which will result in a working system.

For easy passwordless access to the nested VMs it is recommended to configure your SSH public-key in the "bubble", or let the cookbook provision an account by altering [`test/fixtures/data_bags/users/example.json`](test/fixtures/data_bags/users/example.json) with your credentials.

To just provision a single machine without the presence of Chef server, either use:
* Chef client; uses only Chef client and the bubble-blueprint repository: [MissionCriticalCloud/bubble-blueprint] (https://github.com/MissionCriticalCloud/bubble-blueprint)
* Test-Kitchen; uses Chef client and provides tests to check the configuration: [README](test/localinstall/README.md)

The following video gives a demonstration on deploying a bubble with test-kitchen:
[![Demo of Bubble provisioned with Kitchen](https://cloud.githubusercontent.com/assets/2699104/14817345/fa6611c0-0bb6-11e6-8b2f-1aef41189e06.png)](https://youtu.be/gNYIarrXIyE "Demo of Bubble provisioned with Kitchen")

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors:
* Fred Neubauer
* Remi Bergsma
* Bob van den Heuvel
* Boris Schrijver
* Miguel Ferreira
* Wilder Rodrigues

```text
Copyright 2016, Schuberg Philis

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
