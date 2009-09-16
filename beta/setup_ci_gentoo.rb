#!/usr/bin/env ruby

class Cinabox
  def self.setup
    require 'fileutils'
    require 'socket'

    # Settings
    cruise_user = ENV['CRUISE_USER'] || ENV['USER']
    cruise_home = ENV['CRUISE_HOME'] || "#{ENV['HOME']}/ccrb"
    cruise_branch = ENV['CRUISE_BRANCH'] || "git://github.com/thoughtworks/cruisecontrol.rb.git"
    # cruise_tag = ENV['CRUISE_TAG']
    cruise_tag = ENV['CRUISE_TAG'] if ENV['CRUISE_TAG']
    cinabox_dir = File.expand_path(File.dirname(__FILE__))
    cruise_daemon_template = ENV['CRUISE_DAEMON_TEMPLATE'] || "#{cruise_home}/daemon/cruise"
    
    # Detect distro, only Gentoo and Debian currently supported
    distro = system('which emerge') ? 'gentoo' : 'debian'
    
    # Build/download dir
    build_dir = ENV['BUILD_DIR'] || "#{ENV['HOME']}/build"
    FileUtils.mkdir_p(build_dir)

    # warning - the '--force' option will blow away any existing settings
    force = ARGV[0] == '--force' ? true : false

    # Install important packages
    if distro == 'gentoo'
      # Ignore force flag because emerge takes forever
      run "sudo emerge dev-util/subversion" unless system("qlist -I | grep 'subversion'")
      run "sudo emerge dev-util/git" unless system("qlist -I | grep 'git'")
    else
      run "sudo aptitude install -y subversion"  if !((run "dpkg -l subversion", false) =~ /ii  subversion/) || force
      run "sudo aptitude install -y git-core" if !((run "dpkg -l git-core", false) =~ /ii  git-core/) || force
      run "sudo aptitude install -y git-svn" if !((run "dpkg -l git-svn", false) =~ /ii  git-svn/) || force
    end

    # Install cruisecontrol.rb via git and dependencies
    if !File.exist?(cruise_home) || force
      run "rm -rf #{cruise_home}"
      run "git clone #{cruise_branch} #{cruise_home}"
      run "cd #{cruise_home} && git checkout -b #{cruise_tag} refs/tags/#{cruise_tag}" if cruise_tag
      run "sudo gem install --bindir /usr/bin rake rack thin"
      unless RUBY_VERSION =~ /^1.9/
        run "sudo gem install --bindir /usr/bin mongrel mongrel_cluster"
      end
    end

    # Always update cruisecontrol.rb
    # TODO: disabled for now, it will break if we are on a tag
    # run "cd #{cruise_home} && git pull"
    
    # Write out init script daemon based on template
    if !File.exist?('/etc/init.d/cruise') || force
      run "sudo rm -f /etc/init.d/cruise"
      run "sudo touch /etc/init.d/cruise"
      run "sudo chown #{cruise_user} /etc/init.d/cruise"
      run "chmod a+x /etc/init.d/cruise"
      File.open(cruise_daemon_template, "r") do |input|
        File.open("/etc/init.d/cruise", "w") do |output|
          input.each_line do |line|
            line = "CRUISE_USER = '#{cruise_user}'\n" if line =~ /CRUISE_USER =/
            line = "CRUISE_HOME = '#{cruise_home}'\n" if line =~ /CRUISE_HOME =/
            output.print(line)
          end
        end
      end
    end
    
    # Enable on system reboot
    if !File.exist?('/etc/rc3.d/S20cruise') || force
      if distro == 'gentoo'
        run 'sudo rc-update add cruise default'
      else
        run "sudo update-rc.d -f cruise defaults"
      end
    end
    
    # Install and configure postfix
    if distro == 'gentoo'
      puts "Mail daemon setup is not yet automated on Gentoo, please set up CCRB with a working mail delivery option"
    else
      if !((run "dpkg -l postfix", false) =~ /ii  postfix/) || force
        run "sudo aptitude install debconf-utils -y"
        run "echo 'postfix\tpostfix/mailname\tstring\t#{Socket.gethostbyname(Socket.gethostname)[0]}' > #{build_dir}/postfix-selections"
        run "echo 'postfix\tpostfix/main_mailer_type\tselect\tInternet Site' >> #{build_dir}/postfix-selections"
        run "sudo debconf-set-selections #{build_dir}/postfix-selections"
        run "sudo aptitude install postfix -y"
      end
    end
    
    # TODO: when run via 'su -l ci' from another user, this doesn't always drop a pid file, even though it starts
    run "/etc/init.d/cruise start" unless ENV['NO_DAEMON_START']

    print "\n\nSetup script completed.\n"
  end
  
  def self.run(cmd, fail_on_error = true)
    puts "Running command: #{cmd}"
    output = `#{cmd}`
    puts output
    if !$?.success? and fail_on_error
      print "\n\nCommand failed: #{cmd}\n"
      exit $?.to_i
    end
    output
  end
end

Cinabox.setup