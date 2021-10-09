# About Puppet

## Puppet components

### What is a resource?

Resources are the single units of a system that you want to manage, such as users, files, services, or packages.

One of Puppet's core concepts is the resource abstraction layer, whereby information about a resource is represented in Puppet code. To view and modify information about resources, run the puppet resource command, which becomes available after you install the agent.

#### Resource syntax

Let’s break down the output into its basic components:

```
type { 'title':
  parameter => 'value',
}
```

- **Type** — Describes what the resource is. In this case, a file.
- **Title** — A unique name that Puppet uses internally to identify the resource. In this case, it’s the file path and name, /tmp/test.
- **Attributes** — A bracketed list of parameter => value pairs that specifies the state of the resource and its relationship to the node. A resource can have many parameter values.

> The content hash
The content parameter value might not be what you expected for an empty file. When the resource tool interprets a file, it converts the content into an SHA256 hash. Puppet uses this hash to compare the content of the file to what it expects.

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

## Node classification

When the primary server receives a catalog request from an agent node with a valid certificate, it begins a process called node classification to determine what Puppet code to compile to generate a catalog for the agent. The primary server gets this information from the `site.pp` manifest.

### The site.pp manifest

The site.pp manifest is a file on the Puppet server where you can write node definitions and specify your nodes' desired states.

Node: In the context of Puppet, a node is any system or device in your infrastructure.

Node definition: Defines how the primary server should manage a given system. When an agent contacts the server, the server checks the site.pp manifest for node definitions that match the node name. Node definitions enable you to assign specific configurations to specific nodes.

For this example, working with site.pp is the easiest way to see how node classification works. You can also get node classification info in the PE console.

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

So far, you’ve explored the file resource type. However, Puppet manages many types of resources, including:

- user
- service
- package

Puppet can also manage custom types — for example, types specific to a service or application, such as Apache vhost or MySQL database.

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

## Puppet Orchestration

- MCollective
- Ansible or SSH in a for loop
- Puppet Bolt

### MCollective

Collective is a tool that's been bundled with Puppet for several years. The name stands for **Marionette Collective** and it's a way of triggering actions on nodes. This could be as simple as triggering a Puppet run or as complex as running sophisticated reports on every node in your infrastructure. MCollective operates on a publish-subscribe model where a single server, generally your Puppet master, maintains a queue such as **ActiveMQ** or **RabbitMQ**. Any other nodes publish and subscribe data to that queue server. This has the advantage of being tolerant of spotty network connections. If a node isn't able to reach the queue, it will still be able to receive any messages published to it once it was able to connect. The major downside is that it's impossible to ensure that a machine has actually received the message.

### Ansible

Ansible is another open source project that overlaps with Puppet functionality. Unlike Puppet, Ansible doesn't require the installation of an agent. It uses SSH to connect to nodes. But Ansible doesn't manage desired state quite as well as Puppet, so many users combine the tools, using Puppet for maintaining desired state and Ansible for orchestration and procedural tasks.

- Agentless
- Doesn't manage state as well as Puppet
- Ansible for Orchestration
- Puppet for a desired state

### SSH

One simple solution for a small infrastructure is to set up SSH keys and use a simple loop to connect to each node and trigger Puppet runs. Since Puppet runs every 30 minutes by default and can manage SSH keys, it's simple to configure this kind of orchestration. This solution isn't very robust but it does have the advantage of simplicity. All you need is a list of all your nodes by host name.

- Works for smaller installations
- Use Puppet to manage SSH keys
- Simple
- Requires a list of nodes in a flat file

```
for node in 'cat nodes.txt'
    do ssh $node puppet agent -t
end
```

### Bolt

Bolt is the newest orchestration option for Puppet. Like Ansible, it's also agent-less, using SSH on the backend. It's been around for a while but the Puppet community has been a bit slow to fully embrace it. I think partly it's because it's a bit difficult to learn and it doesn't offer a lot of advantages over the other options we just talked about. If it gains more support from the community, it will become a more viable option. The main reason to consider using Bolt is that it's made to integrate with Puppet. For example, module creators can create Bolt tasks that ship with their module. These are ad hoc actions that someone might want to take related to a particular application but that don't fall under the typical Puppet configuration management. The other aspect I find compelling about Bolt is the idea of integrating with PuppetDB.

- Agentless
- Newest Orchestration option
- Not widely used yet
- May become a more viable option in the future

Why use Puppet Bolt

- Tasks in Forge modules
- Extemporary actions related to the module
- PuppetDB
- Intelligently take action across multiple nodes
- Potentially powerful

### 

When the Puppet agent runs, first it triggers a program called factor to collect details about the system. The agent submits this information to the master. The master takes that information and uses it to look up what code is relevant to that machine. Then the master uses those details to compile what's called a catalog. The catalog doesn't contain any Puppet code, but it's the representation of what specifically needs to happen on that node and in what order. The catalog isn't meant to be human readable, but it's in a form that the Puppet agent can understand. The master responds to the agent's initial request with the catalog. Now the agent takes that catalog and enforces the changes on the node. For example, installing a software package and configuring a user. Finally, the agent generates a report of the Puppet run and submits it to the master.

What's in a report?

- Metadata
- Status
- Events
- Logs
- Metrics

## Facter

```bash
facter
facter system_uptime.uptime
facter uptime
# hostname
facter fqdn
```
