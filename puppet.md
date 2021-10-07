# About Puppet

## Puppet components

- **Resources** : a way of defining a specific unit of configuration. For example a file or a system user would be single resource.

Ex:

```ruby
file { '/root/README':
    ensure => file,
    content => 'Hello World',
}
```

'/root/README': Name of the resource (a.k.a namevar)
'ensure => file,': Parameter
'=>' : hash rocket

Ex of a Package Resource:

```ruby
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

```ruby
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

```ruby
node default {
    class { 'dev_environment':
        ensure => present,
    }
}
```

### Classification with include keyword

```ruby
node default {
    include dev_environment
}
node 'grace.puppet.vm' {
    include dev_environment
}
```

### Nested Classes

```ruby
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
