# Puppet Module

## What is Puppet Module

### /manifests

- Puppet code for your module
- One class per manifest
- The class named after the module is in init.pp
- Example: the nginx class in the nginx module is in manifests/init.pp

### /files

- Static files

### /templates

- Dynamic templates to create config files based on the parameters provided to the module

### /lib

- Additional codes to extend the functionality of Puppet

### /tasks

- Extemporary tasks

    - Ad-hoc tasks related to their applications
    - They are executed by Puppet Bolt

### Other directories

Commonly used in modules. Provided by community.

- /examples: include examples of your code how to use your module.
- /spec: include automated tests of the code.

### metadata.json

This file is used by the Forge to fill in the details about that module. It includes things like the module dependencies, supported operating systems, the author name, and the current version.

### README.md

The documentation about that module. When the module is posted to the Forge, the README will be displayed on the module page. Puppet offers a helper tool for writing modules, called the Puppet Development Kit. It will set up all the essentials we just went over and a lot more. To learn more, go to github.com/puppetlabs/pdk.
