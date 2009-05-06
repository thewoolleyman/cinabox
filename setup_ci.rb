#!/usr/bin/env ruby

class Cinabox
  def self.setup
    require 'fileutils'
    require 'socket'

    # Settings
    current_user = "#{ENV['USER']}"
    ccrb_home = ENV['CCRB_HOME'] || "#{ENV['HOME']}/ccrb"
    ccrb_branch = ENV['CCRB_BRANCH'] || "git://github.com/thoughtworks/cruisecontrol.rb.git"
    cinabox_dir = File.expand_path(File.dirname(__FILE__))
    ccrb_daemon_template = ENV['CCRB_DAEMON_TEMPLATE'] || "#{ccrb_home}/daemon/cruise.sample"
    
    # Build/download dir
    build_dir = ENV['BUILD_DIR'] || "#{ENV['HOME']}/build"
    FileUtils.mkdir_p(build_dir)

    # warning - the '--force' option will blow away any existing settings
    force = ARGV[0] == '--force' ? true : false

    FileUtils.cd(build_dir)

    # Install important packaages
    run "sudo aptitude install -y subversion"  if !((run "dpkg -l subversion", false) =~ /ii  subversion/) || force
    run "sudo aptitude install -y git-core" if !((run "dpkg -l git-core", false) =~ /ii  git-core/) || force
    run "sudo aptitude install -y git-svn" if !((run "dpkg -l git-svn", false) =~ /ii  git-svn/) || force
    run "sudo aptitude install -y ssh" if !((run "dpkg -l ssh", false) =~ /ii  ssh/) || force

    # Install ccrb via git and dependencies
    if !File.exist?(ccrb_home) || force
      run "rm -rf #{ccrb_home}"
      run "git clone #{ccrb_branch} #{ccrb_home}"
      run "sudo gem install --bindir /usr/bin rake mongrel mongrel_cluster"
    end

    # Always update ccrb
    run "cd #{ccrb_home} && git pull"
    
    
    # Write out init script daemon based on template
    if !File.exist?('/etc/init.d/cruise') || force
      run "sudo touch /etc/init.d/cruise"
      run "sudo chown #{current_user} /etc/init.d/cruise"
      run "chmod a+x /etc/init.d/cruise"
      File.open(ccrb_daemon_template, "r") do |input|
        File.open("/etc/init.d/cruise", "w") do |output|
          input.each_line do |line|
            line = "CRUISE_USER = '#{current_user}'\n" if line =~ /CRUISE_USER =/
            line = "CRUISE_HOME = '#{ccrb_home}'\n" if line =~ /CRUISE_HOME =/
            output.print(line)
          end
        end
      end
    end
    
    # Enable on system reboot
    if !File.exist?('/etc/rc3.d/S20cruise') || force
      run "sudo update-rc.d cruise defaults"
    end
    
    # Install and configure postfix
    if !((run "dpkg -l postfix", false) =~ /ii  postfix/) || force
      run "sudo aptitude install debconf-utils -y"
      run "echo 'postfix\tpostfix/mailname\tstring\t#{Socket.gethostbyname(Socket.gethostname)[0]}' > #{cinabox_dir}/postfix-selections"
      run "echo 'postfix\tpostfix/main_mailer_type\tselect\tInternet Site' >> #{cinabox_dir}/postfix-selections"
      run "sudo debconf-set-selections #{cinabox_dir}/postfix-selections"
      run "sudo aptitude install postfix -y"
    end

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