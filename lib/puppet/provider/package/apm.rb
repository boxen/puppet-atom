require "puppet/provider/package"

Puppet::Type.type(:package).provide :apm, :parent => Puppet::Provider::Package do
  desc "Atom packages via `apm`."

  has_feature :installable, :uninstallable, :upgradeable, :versionable

  commands :apm => "apm"

  def self.parse(line)
    if line.chomp =~ /── (\S+)@(\d+\.\d+\.\d+)/
      {:ensure => $2, :name => $1, :provider => :apm}
    else
      nil
    end
  end

  def self.instances
    command = [command(:apm), :list, "--no-color"]

    begin
      output = execute(command, command_opts)
      Array.new.tap do |a|
        output.lines.each do |line|
          next unless package = parse(line)
          a << new(package)
        end
      end.compact
    rescue Puppet::ExecutionFailure => e
      raise Puppet::Error, "Could not list atom packages: #{e}"
    end
  end

  def query
    self.class.instances.each do |pkg|
      return pkg.properties if @resource.name == pkg.name
    end
    nil
  end

  def latest
    command = [command(:apm), :upgrade, "--list", "--no-color"]
    output = execute(command, self.class.command_opts)

    if output =~ /── #{Regexp.escape @resource[:name]} (\d+\.\d+\.\d+) -> (\d+\.\d+\.\d+)/
      $2
    else
      @property_hash[:ensure]
    end
  end

  def install
    command = [command(:apm), :install]

    should = @resource.should(:ensure)
    if [:latest, :installed, :present].include?(should)
      command << @resource[:name]
    else
      command << "#{@resource[:name]}@#{should}"
    end

    command << "--no-color"

    execute command, self.class.command_opts
  end

  def update
    self.install
  end

  def uninstall
    command = [command(:apm), :uninstall, @resource[:name], "--no-color"]
    execute(command, self.class.command_opts)
  end

  def self.default_user
    Facter.value(:boxen_user) || Facter.value(:id) || "root"
  end

  def self.home
    if boxen_home = Facter.value(:boxen_home)
      "#{boxen_home}/homebrew"
    else
      "/usr/local/homebrew"
    end
  end

  def self.homedir_prefix
    case Facter[:osfamily].value
    when "Darwin" then "Users"
    when "Linux" then "home"
    else
      raise "unsupported"
    end
  end

  def self.command_opts
    @command_opts ||= {
      :combine            => true,
      :custom_environment => {
        "HOME"            => "/#{homedir_prefix}/#{default_user}",
        "PATH"            => "#{home}/bin:/usr/bin:/usr/sbin:/bin:/sbin",
      },
      :failonfail         => true,
      :uid                => default_user
    }
  end
end
