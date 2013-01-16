# ssh-copy-id.rb

A Ruby implementation of `ssh-copy-id` script. (Surprise!)
Supports copying to/removing from multiple servers.

## Installation

```bash
gem install ssh-copy-id.rb
```

## Usage

```
usage: ssh-copy-id.rb [-i IDENDITY] [-u USER] [-p PASSWORD] [USER[:PASSWORD]@]HOSTNAME[:PORT] ...

    -i, --identity=IDENTITY          Identity file. Default: ~/.ssh/id_rsa.pub
    -u, --username=USERNAME          Username. Default: current user.
    -p, --password[=PASSWORD]        Password. Ask password if not given.
```

## Examples

```ruby
ssh-copy-id.rb   server1 server2:9022 user@server{2..5} user:password@server{6..10}
ssh-remove-id.rb server1 server2:9022 user@server{2..5} user:password@server{6..10}
```

