# About Puppet

## Puppet components

- **Resources** : a way of defining a specific unit of configuration. For example a file or a system user would be single resource.

Ex:

```
file { '/root/README':
    ensure => file,
    content => 'Hello World',
}
```

'/root/README': Name of the resource (a.k.a namevar)
'ensure => file,': Parameter
'=>' : hash rocket

Ex of a Package Resource:

```
service { 'crond':
    ensure => running,
    enable => true,
}
```

'ensure => running,': running/stopped/absent
'enable => true,': Start at boot

Built-In Resource Types: https://docs.puppet.com/puppet/latest/type.html

- **Classes** : a set of resources by name.

Ex:

```
class dev_environment{
    user { 'grace':
        ensure => present,
        manage_home => true,
        group => ['wheel']
    }
    package { 'vim':
        ensure => present,
    }
    file { '/home/grace/.vimrc':
        ensure => file,
        source => 'puppet:///modules/dev_environment/vimrc',
    }
}

```

### Classification in site.pp

```
node default {
    class { 'dev_environment':
        ensure => present,
    }
}
```

### Classification with include keyword

```
node default {
    include dev_environment
}
node 'grace.puppet.vm' {
    include dev_environment
}
```

### Nested Classes

```
class foo{
    include dev_environment
    class { 'another_class':
        ensure => present,
    }
    file { '/some/file.txt':
        ensure => file,
        content => 'some content',
    }
}
```

## Sharing puppet code

Link: https://forge.puppet.com

### nginx module

- Start using this module:

    - Add this declaration to your Puppetfile:

    ```
    mod 'puppet-nginx', '1.0.0'
    ```

    - Then run:

    ```
    bolt puppetfile install
    ```

### Bolt

Bolt is an orchestration tool that works with Puppet and is written by Puppet. Bolt lets you do more ad hoc or one time tasks with your infrastructure as opposed to the typical Puppet approach of managing the system state. They can work together, for example using Bolt to trigger a sequence of database scripts, and then writing Puppet to manage the final state after the intermediate changes are done.

Manual installation:

```
puppet module install puppet-nginx --version
```

## Roles and Profiles

In addition to the modules from the Forge, you'll want to make some of your own modules.
You can put these inside a directory called site in the root of your control-repo.
The first two modules we'll create in the site directory are our roles and profiles.
The roles and profiles pattern is a best practice for keeping your Puppet code organized.

### Profile

Profiles are the building blocks of your configuration. You define a profile as a wrapper for a subset of configuration.
Profile should be limited as single unit of configuration like the NGINX web server. If you're managing a database, that configuration would go in another profile.

### Role

Roles define the business role of a machine. There should be one role per machine and roles should be made up only of profiles. This keeps your configuration simple and composable. Roles like "That's a production app server", "That's a developer's workstation"
