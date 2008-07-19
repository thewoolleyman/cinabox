#!/usr/local/bin ruby

class Cinabox
  def self.setup
    require 'fileutils'
    
    # warning - the '--force' option will blow away any existing settings
    force = ARGV[0] == '--force' ? true : false

    # SETTINGS
    build_dir = ENV['BUILD_DIR'] || "#{ENV['HOME']}/build"
    FileUtils.mkdir_p(build_dir)

    current_user = "#{ENV['USER']}"
    ccrb_home = ENV['CCRB_HOME'] || "#{ENV['HOME']}/ccrb"
    rubygems_version = ENV['RUBYGEMS_VERSION'] || '1.2.0'
    ccrb_branch = ENV['CCRB_BRANCH'] || "git://rubyforge.org/cruisecontrolrb.git"
    
    cinabox_dir = File.expand_path(File.dirname(__FILE__))
    
    FileUtils.cd(build_dir)

    # Install important packaages
    run "sudo aptitude install -y subversion"
    run "sudo aptitude install -y git-core git-svn"
    run "sudo aptitude install -y ssh"

    # Download RubyGems if needed
    rubygems_mirror_id = '38646'
    if !File.exist?("rubygems-#{rubygems_version}.tgz") || force
      run "rm -rf rubygems-#{rubygems_version}.tgz"
      run "wget http://rubyforge.org/frs/download.php/#{rubygems_mirror_id}/rubygems-#{rubygems_version}.tgz"
    end

    # rubygems install/reinstall
    # TODO: Should try a gem update --system if RubyGems is already installed
    if !((run "gem --version") =~ /#{rubygems_version}/) || force
      run "rm -rf rubygems-#{rubygems_version}"
      run "tar -zxvf rubygems-#{rubygems_version}.tgz"
      FileUtils.cd "rubygems-#{rubygems_version}" do
        run "sudo ruby setup.rb"
      end
    end

    # Install ccrb via git and dependencies
    if !File.exist?(ccrb_home) || force
      run "rm -rf #{ccrb_home}"
      run "git clone #{ccrb_branch} #{ccrb_home}"
      run "sudo gem install rake mongrel_cluster"
    end

    # Always update ccrb
    run "cd #{ccrb_home} && git pull"
    
    # TODO: Get ccrb_daemon pushed into ccrb trunk, then remove this
    run "cp #{cinabox_dir}/ccrb_daemon #{ccrb_home}/daemon/"
    
    # Make dir for ccrb daemon config
    if !File.exist?('/etc/ccrb') || force
      run "sudo mkdir -p /etc/ccrb"
      run "sudo chown #{current_user} /etc/ccrb"
    end

    # Create ccrb daemon config file
    if !File.exist?('/etc/ccrb/ccrb_daemon_config') || force
      run "echo \"ENV['CCRB_USER']='#{current_user}'\" > '/etc/ccrb/ccrb_daemon_config'"
      run "echo \"ENV['CCRB_HOME']='#{ccrb_home}'\" >> '/etc/ccrb/ccrb_daemon_config'"
    end
    
    # Create init script symlink to daemon
    if !File.exist?('/etc/init.d/ccrb_daemon') || force
      run "sudo ln -f #{ccrb_home}/daemon/ccrb_daemon /etc/init.d/ccrb_daemon"
    end
    
    # Enable on system reboot
    if !File.exist?('/etc/rc3.d/S20cruise') || force
      run "sudo update-rc.d ccrb_daemon defaults"
    end
    
  end
  
  def self.run(cmd)
    puts "Running command: #{cmd}"
    output = `#{cmd}`
    puts output
    raise "Command failed: #{cmd}" unless $?.success?
    output
  end
end

Cinabox.setup