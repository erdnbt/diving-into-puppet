# Installation

# add repo
rpm -Uvh https://yum.puppet.com/puppet7-release-el-7.noarch.rpm
# install puppet-agent
yum install -y puppet-agent
# add puppet binary to the PATH
echo 'export PATH=/opt/puppetlabs/bin/:$PATH' >> ~/.bashrc
# reload bash shell
source ~/.bashrc

puppet resource file /tmp/test
puppet resource file /tmp/test content='Hello Puppet!'
cat /tmp/test

# Apache HTTP Server
root@linux:~# puppet resource package httpd
package { 'httpd':
  ensure   => 'purged',
  provider => 'yum',
}

root@linux:~# puppet resource package httpd ensure=present
Notice: /Package[httpd]/ensure: created
package { 'httpd':
  ensure   => '2.4.6-97.el7.centos',
  provider => 'yum',
}


root@linux:~# puppet resource package bogus-package ensure=present
Error: Execution of '/usr/bin/yum -d 0 -e 0 -y install bogus-package' returned 1: Error: Nothing to do
Error: /Package[bogus-package]/ensure: change from 'purged' to 'present' failed: Execution of'/usr/bin/yum -d 0 -e 0 -y install bogus-package' returned 1: Error: Nothing to do
package { 'bogus-package':
  ensure   => 'purged',
  provider => 'yum',
}
root@linux:~# puppet resource package bogus-package ensure=present provider=gem
Error: /Package[bogus-package]: Could not evaluate: Provider gem package command is not functional on this host
Error: Could not run: Provider gem package command is not functional on this host
root@linux:~#
