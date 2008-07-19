#!/usr/local/bin ruby

class Cinabox
  def self.setup
    require 'fileutils'

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
    run "sudo apt-get install -y subversion"
    run "sudo apt-get install -y git-core git-svn"
    run "sudo apt-get install -y ssh"

    # Download RubyGems if needed
    rubygems_mirror_id = '38646'
    unless File.exist?("rubygems-#{rubygems_version}.tgz")
      run "rm -rf rubygems-#{rubygems_version}.tgz"
      run "wget http://rubyforge.org/frs/download.php/#{rubygems_mirror_id}/rubygems-#{rubygems_version}.tgz"
    end

    # Force rubygems install/reinstall
    # TODO: Should try a gem update --system if RubyGems is already installed
    unless run "gem --version" =~ /#{rubygems_version}/
      run "rm -rf rubygems-#{rubygems_version}"
      run "tar -zxvf rubygems-#{rubygems_version}.tgz"
      FileUtils.cd "rubygems-#{rubygems_version}" do
        run "sudo ruby setup.rb"
      end
    end

    # Install ccrb via git and dependencies
    unless File.exist?(ccrb_home)
      run "git clone #{ccrb_branch} #{ccrb_home}"
      run "sudo gem install rake mongrel_cluster"
    end

    # Always update ccrb
    run "cd #{ccrb_home} && git pull"
    
    # TODO: Get ccrb_daemon pushed into ccrb trunk, then remove this
    run "cp #{cinabox_dir}/ccrb_daemon #{ccrb_home}/daemon/"
    
    # Handle daemon setup
    unless File.exist?('/etc/ccrb')
      run "sudo mkdir -p /etc/ccrb"
      run "sudo chown #{current_user} /etc/ccrb"
    end

    unless File.exist?('/etc/ccrb/ccrb_daemon_config')
      run "echo "ENV['CCRB_USER']='#{current_user}'" > '/etc/ccrb/ccrb_daemon_config'"
      run "echo "ENV['CCRB_HOME']='#{ccrb_home}'" >> '/etc/ccrb/ccrb_daemon_config'"
    end
    
    unless File.exist?('/etc/init.d/ccrb_daemon')
      run "sudo ln -f #{ccrb_home}/daemon/ccrb_daemon /etc/init.d/ccrb_daemon"
    end
    
    unless File.exist?('/etc/rc3.d/S20cruise')
      run "sudo update-rc.d ccrb_daemon defaults"
    end

  end
  
  def run(cmd)
    puts "Running command: #{cmd}"
    puts run "#{cmd}"
    raise "Command failed: #{cmd}" unless $?.success?
  end
end

Cinabox.setup