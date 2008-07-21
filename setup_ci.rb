#!/usr/local/bin ruby

class Cinabox
  def self.setup
    require 'fileutils'
    require 'socket'

    # Settings
    current_user = "#{ENV['USER']}"
    ccrb_home = ENV['CCRB_HOME'] || "#{ENV['HOME']}/ccrb"
    rubygems_version = ENV['RUBYGEMS_VERSION'] || '1.2.0'
    ccrb_branch = ENV['CCRB_BRANCH'] || "git://rubyforge.org/cruisecontrolrb.git"
    cinabox_dir = File.expand_path(File.dirname(__FILE__))
    
    # Build/download dir
    build_dir = ENV['BUILD_DIR'] || "#{ENV['HOME']}/build"
    FileUtils.mkdir_p(build_dir)

    # warning - the '--force' option will blow away any existing settings
    force = ARGV[0] == '--force' ? true : false

    FileUtils.cd(build_dir)

    # Install important packaages
    run "sudo aptitude install -y subversion"  unless ((run "dpkg -l subversion", false) =~ /ii  subversion/) || force
    run "sudo aptitude install -y git-core" unless ((run "dpkg -l git-core", false) =~ /ii  git-core/) || force
    run "sudo aptitude install -y git-svn" unless ((run "dpkg -l git-svn", false) =~ /ii  git-svn/) || force
    run "sudo aptitude install -y ssh" unless ((run "dpkg -l ssh", false) =~ /ii  ssh/) || force

    # Download RubyGems if needed
    rubygems_mirror_id = '38646'
    unless File.exist?("rubygems-#{rubygems_version}.tgz") || force
      run "rm -rf rubygems-#{rubygems_version}.tgz"
      run "wget http://rubyforge.org/frs/download.php/#{rubygems_mirror_id}/rubygems-#{rubygems_version}.tgz"
    end

    # rubygems install/reinstall
    # TODO: Should try a gem update --system if RubyGems is already installed
    unless ((run "gem --version", false) =~ /#{rubygems_version}/) || force
      run "rm -rf rubygems-#{rubygems_version}"
      run "tar -zxvf rubygems-#{rubygems_version}.tgz"
      FileUtils.cd "rubygems-#{rubygems_version}" do
        run "sudo ruby setup.rb"
      end
    end

    # Install ccrb via git and dependencies
    unless File.exist?(ccrb_home) || force
      run "rm -rf #{ccrb_home}"
      run "git clone #{ccrb_branch} #{ccrb_home}"
      run "sudo gem install rake mongrel_cluster"
    end

    # Always update ccrb
    run "cd #{ccrb_home} && git pull"
    
    # TODO: Get ccrb_daemon pushed into ccrb trunk, then remove this
    run "cp #{cinabox_dir}/ccrb_daemon #{ccrb_home}/daemon/"
    
    # Make dir for ccrb daemon config
    unless File.exist?('/etc/ccrb') || force
      run "sudo mkdir -p /etc/ccrb"
      run "sudo chown #{current_user} /etc/ccrb"
    end

    # Create ccrb daemon config file
    unless File.exist?('/etc/ccrb/ccrb_daemon_config') || force
      run "echo \"ENV['CCRB_USER']='#{current_user}'\" > '/etc/ccrb/ccrb_daemon_config'"
      run "echo \"ENV['CCRB_HOME']='#{ccrb_home}'\" >> '/etc/ccrb/ccrb_daemon_config'"
    end
    
    # Create init script symlink to daemon
    unless File.exist?('/etc/init.d/ccrb_daemon') || force
      run "sudo ln -f #{ccrb_home}/daemon/ccrb_daemon /etc/init.d/ccrb_daemon"
    end
    
    # Enable on system reboot
    unless File.exist?('/etc/rc3.d/S20cruise') || force
      run "sudo update-rc.d ccrb_daemon defaults"
    end
    
    # Install and configure postfix
    unless ((run "dpkg -l postfix", false) =~ /ii  postfix/) || force
      run "sudo aptitude install debconf-utils -y"
      run "echo 'postfix\tpostfix/mailname\tstring\t#{Socket.gethostbyname(Socket.gethostname)[0]}' > #{cinabox_dir}/postfix-selections"
      run "echo 'postfix\tpostfix/main_mailer_type\tselect\tInternet Site' >> #{cinabox_dir}/postfix-selections"
      run "sudo debconf-set-selections #{cinabox_dir}/postfix-selections"
      run "sudo aptitude install postfix -y"
    end
  end
  
  def self.run(cmd, fail_on_error = true)
    puts "Running command: #{cmd}"
    output = `#{cmd}`
    puts output
    raise "Command failed: #{cmd}" unless $?.success? if fail_on_error
    output
  end
end

Cinabox.setup