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
    `sudo apt-get install -y subversion`
    `sudo apt-get install -y git-core git-svn`
    `sudo apt-get install -y ssh`

    # Download RubyGems if needed
    rubygems_mirror_id = '38646'
    unless File.exist?("rubygems-#{rubygems_version}.tgz")
      `rm -rf rubygems-#{rubygems_version}.tgz`
      `wget http://rubyforge.org/frs/download.php/#{rubygems_mirror_id}/rubygems-#{rubygems_version}.tgz`
    end

    # Force rubygems install/reinstall
    # TODO: Should try a gem update --system if RubyGems is already installed
    unless `gem --version` =~ /#{rubygems_version}/
      `rm -rf rubygems-#{rubygems_version}`
      `tar -zxvf rubygems-#{rubygems_version}.tgz`
      FileUtils.cd "rubygems-#{rubygems_version}" do
        `sudo ruby setup.rb`
      end
    end

    # Install ccrb via git
    unless File.exist?(ccrb_home)
      `git clone #{ccrb_branch} #{ccrb_home}`
      `sudo ln -s `
    end

    # Always update ccrb
    `cd #{ccrb_home} && git pull`
    
    # TODO: Get ccrb_daemon pushed into ccrb trunk, then remove this
    `cp #{cinabox_dir}/ccrb_daemon #{ccrb_home}/daemon/`
    
    # Handle daemon setup
    unless File.exist?('/etc/rc3.d/S20cruise')
      `sudo mkdir -p /etc/ccrb`
      `sudo chown #{current_user} /etc/ccrb`
      `echo "ENV['CCRB_USER']='#{current_user}'" > '/etc/ccrb/ccrb_daemon_config'`
      `echo "ENV['CCRB_HOME']='#{ccrb_home}'" >> '/etc/ccrb/ccrb_daemon_config'`
      `sudo ln -f #{ccrb_home}/daemon/ccrb_daemon /etc/init.d/ccrb_daemon`
      `sudo update-rc.d ccrb_daemon defaults`
    end

  end
end

Cinabox.setup