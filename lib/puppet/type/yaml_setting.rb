Puppet::Type.newtype(:yaml_setting) do
  @doc = "Manage settings in yaml configuration files"
  desc <<-EOT
    Ensures that a given yaml hash key and value exists within a yaml file.
    Nested hash keys can be specified by a key-delimited string. Existing
    data in the target yaml file will be preserved. No guarantees about
    comments or other formatting/non-functional details.

    Example:

      yaml_setting { 'simple_example':
        target => '/etc/example.yaml',
        key    => 'greeting',
        value  => 'hello',
      }

      yaml_setting { 'nested_key_example1':
        target  => '/etc/example.yaml',
        key     => 'database/username',
        value   => 'console',
      }

      yaml_setting { 'nested_key_example2':
        target  => '/etc/example.yaml',
        key     => 'database/password',
        value   => 'passw0rd',
      }

      yaml_setting { 'nested_key_example3':
        target  => '/etc/example.yaml',
        key     => 'one/two/three',
        value   => [ 'a', 'b', 'c' ],
      }

    Result (/etc/example.yaml):

      --- 
        greeting: hello
        database:
          username: console
          password: passw0rd

    In this example, several yaml_settings were specified and the resulting
    merged hash was created in /etc/example.yaml. If /etc/example.yaml had
    already contained data, any keys not specified in a yaml_setting resource
    would be preserved.

  EOT

  ensurable

  newproperty(:target) do
    desc "The configuration file in which to place settings"
    isrequired
    isnamevar
  end

  newproperty(:key) do
    desc "The yaml key"
    isrequired
    isnamevar
  end

  newparam(:name) do
    desc "The name"
    munge do |discard|
      target = @resource.original_parameters[:target]
      key    = @resource.original_parameters[:key]
      "#{target.to_s}:#{key.to_s}"
    end
  end

  newparam(:type) do
    desc "The data type"
  end

  newproperty(:value) do
    desc "The value to give the configuration key"
  end

  # Our title_patterns method for mapping titles to namevars for supporting
  # composite namevars.
  def self.title_patterns
    identity = lambda {|x| x}
    [
      [
        /^([^:]+)$/,
        [
          [ :name, identity ]
        ]
      ],
      [
        /^((.*):(.*))$/,
        [
          [ :name, identity ],
          [ :key, identity ],
          [ :value, identity ]
        ]
      ]
    ]
  end
end
