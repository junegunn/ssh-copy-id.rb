require 'rubygems'
require 'ssh-copy-id/version'
require 'net/ssh'
require 'highline'

module SSHCopyID
  DEFAULT_IDENTITY_FILE = '~/.ssh/id_rsa.pub'

  def self.grant options
    execute options, true do |identity|
      %[
      /bin/bash -cl '
      umask 077;
      test -d ~/.ssh || mkdir ~/.ssh;
      if [ ! -f ~/.ssh/authorized_keys -o `grep "#{identity}" ~/.ssh/authorized_keys 2> /dev/null | wc -l` -eq 0 ]; then
        echo "#{identity}" >> ~/.ssh/authorized_keys
        echo "Key added."
      else
        echo "Key already exists."
      fi
      '
      ]
    end
  end

  def self.revoke options
    execute options, false do |identity|
      %[
      /bin/bash -cl '
      umask 077;
      if [ -f ~/.ssh/authorized_keys -a `grep "#{identity}" ~/.ssh/authorized_keys 2> /dev/null | wc -l` -ge 1 ]; then
        grep -v "#{identity}" ~/.ssh/authorized_keys | cat > ~/.ssh/authorized_keys.ruby-ssh-copy-id
        mv -f ~/.ssh/authorized_keys.ruby-ssh-copy-id ~/.ssh/authorized_keys
        echo "Key removed."
      else
        echo "Key not found."
      fi
      '
      ]
    end
  end

  def self.execute options, ask_password
    identity_file = options[:identity] || DEFAULT_IDENTITY_FILE
    identity = File.readlines(File.expand_path identity_file).first.chomp
    passwords = {}
    output = options[:output] || Class.new { def method_missing *args; end }.new

    options[:hosts].each do |host|
      host, user = host.split('@').reverse
      user, pass = user.split(':') if user
      user ||= options[:username] || ENV['USER']
      output.print "#{user}@#{host}: "
      password =
        if pass
          pass
        elsif options[:password]
          options[:password]
        elsif passwords[user]
          passwords[user]
        elsif ask_password || options.has_key?(:password)
          passwords[user] = HighLine.new.ask($/ + "Password: ") { |q| q.echo = '*' }
        else
          nil
        end

      host, port = host.split(':')
      Net::SSH.start(host, user, :port => port || 22, :password => password) do |ssh|
        result = ssh.exec!(yield identity)
        output.puts result
      end
    end
  rescue Net::SSH::AuthenticationFailed
    output.puts "Authentication failed."
    exit 1
  end

  def self.parse_options filename, argv
    {}.tap { |options|
      opts = OptionParser.new { |opts|
        opts.banner =
          "usage: #{File.basename filename} [-i IDENDITY] [-u USER] [-p PASSWORD] [USER[:PASSWORD]@]HOSTNAME[:PORT] ..."
        opts.separator ''

        opts.on('-i', '--identity=IDENTITY', 'Identity file. Default: ~/.ssh/id_rsa.pub') do |v|
          options[:identity] = v
        end

        opts.on('-u', '--username=USERNAME', 'Username') do |v|
          options[:username] = v
        end

        opts.on('-p', '--password=PASSWORD', 'Password. Ask password if not given.') do |v|
          options[:password] = v
        end

        opts.separator ''
        opts.on_tail('-h', '--help', "Show this message") do
          puts opts
          exit
        end
      }
      begin
        opts.parse!(argv)
      rescue SystemExit => e
        exit e.status
      rescue Exception => e
        puts e.to_s
        puts opts
        exit 1
      end

      if argv.empty?
        puts opts
        exit 1
      end
    }
  end
end
