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

### Built-In Resource Types

Docs: https://docs.puppet.com/puppet/latest/type.html
