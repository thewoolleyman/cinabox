#!/usr/local/bin ruby

class Cinabox
  def self.setup
    require 'fileutils'

    # SETTINGS
    build_dir = ENV['BUILD_DIR'] || "#{ENV['HOME']}/build"
    FileUtils.mkdir_p(build_dir)

    cc_dir = ENV['CC_DIR'] || "#{ENV['HOME']}/cc"
    
    rubygems_version = ENV['RUBYGEMS_VERSION'] || '1.2.0'
    
    ccrb_branch = ENV['CCRB_BRANCH'] || "git://rubyforge.org/cruisecontrolrb.git"
    
    FileUtils.cd(build_dir)

    # Install important packaages
    `sudo apt-get install -y subversion`
    `sudo apt-get install -y git-core git-svn`
    `sudo apt-get install -y ssh`

    # Download RubyGems if needed
    unless File.exist?("rubygems-#{rubygems_version}.tgz")
      `rm -rf rubygems-#{rubygems_version}.tgz`
      `wget http://rubyforge.org/frs/download.php/20989/rubygems-#{rubygems_version}.tgz`
    end

    # Force rubygems install/reinstall
    # TODO: Should try a gem update --system if RubyGems is already installed
    unless `gem --version` =~ /#{rubygems_version}/
      `rm -rf rubygems-#{rubygems_version}`
      `tar -zxvf rubygems-#{rubygems_version}.tgz`
      FileUtils.cd 'rubygems-#{rubygems_version}' do
        `sudo ruby setup.rb`
      end
    end

    # Install ccrb via git
    unless File.exist?(cc_dir)
      `git clone #{ccrb_branch} #{cc_dir}`
    end

    
  end
end

Cinabox.setup