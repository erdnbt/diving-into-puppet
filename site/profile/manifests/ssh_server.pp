class profile::ssh_server {
    package {'openssh-server':
        ensure  => present,
    }
    service {'sshd':
        ensure  => 'running',
        enable  => 'true',
    }
    ssh_authorized_key {'root@master.puppet.vm':
        ensure  => present,
        user    => 'root',
        type    => 'ssh-rsa',
        key     => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQDJbyPcN+oKC8GV7+90F24pUHrOphvKiXMJgjNVrfqIosEGwJD7CdtBjUYl40vGiysuxWYTpqvEjdGT/f1fDQAQrLX8gF47cAmPDb57SnIDUG93jk15IqiGAn8Tqqdd2J/+IHNsDo5riuhwaZdR2XA9qZlDzdO+JCqI6hd50ugZy9WQQDjj1m6TejUkq10R2mLCL808HXS7kesiHOEJBLYrD4DyWa0Kb7Uxw+mrhO2EQBjUN3wDzK3aWG0gtBmeiQUM9MsXQefnrTjdBUgs8duanMwYT/IFHjG3bGS9kjmZyc/+Oj8nK94FxyGy+JBaXf0RzYJlZT7QDIjkzVIvz7MH',
    }
}