Cinabox: Continuous Integration - in a Box

Watch the Screencast! - http://s3.amazonaws.com/assets.pivotallabs.com/99/original/cinabox_screencast.mov

Chad Woolley - http://thewoolleyweb.com - http://pivotallabs.com
http://github.com/thewoolleyman/cinabox/tree/master/README.txt

SUMMARY:
  
* CI in a Box automates the setup of a Continuous Integration (CI) system by
  doing The Simplest Thing That Could Possibly Work.
* It consists of two simple scripts to set up a cruisecontrolrb (ccrb) CI server
  from scratch on an Ubuntu 8.04 system: one script to bootstrap Ruby, and
  another script to setup CI.

DESCRIPTION:

* Simplicity Rules. Cinabox is only tested on Ubuntu 8.04.  It may work on 
  other Debian-based systems. If it doesn't work, hack it up yourself
  or try running the commands manually - the scripts are intended to be
  easily readable and easily changed.
* Support: http://thewoolleyweb.lighthouseapp.com/projects/14441-cinabox
* For more detailed and advanced info on Continuous Integration and
  Ubuntu/VMWare setup, see my RailsConf tutorial:
  http://www.thewoolleyweb.com/ci_for_the_rails_guy_or_gal/presentation/ci_for_the_rails_guy_or_gal.pdf

REQUIREMENTS:

* Ubuntu 8.04 and an internet connection

INSTRUCTIONS:

* DISCLAIMER: Cinabox is intended to be run on a clean/dedicated system.  If you
  run it on an existing system, it may blow away some existing configuration. 
* Install Ubuntu 8.04, manually or as a virtual machine:
  * http://www.ubuntu.com/getubuntu/download
  * VMWare Player (win): http://www.vmware.com/products/player/
  * VMWare Fusion (mac): http://www.vmware.com/download/fusion/
  * Ubuntu 8.04 VMWare image: 
    * Here's one: http://symbiosoft.net/UbuntuServerMinimalVA
    * Or search for an "Ubuntu 8.04" Operating System VMs that works for you:
      http://www.vmware.com/appliances/directory/cat/45
    * 7-Zip archiver: http://www.7-zip.org/ ('7za x <file>' to extract) 
* Log in
* wget http://github.com/thewoolleyman/cinabox/tarball/master
* tar -zxvf thewoolleyman-cinabox-<COMMIT_ID>.tar.gz
* cd thewoolleyman-cinabox-<COMMIT_ID>
* ./bootstrap_ruby.sh
* Ensure Ruby got installed by typing 'ruby --version'
* ./setup_ci.rb
* Review the output.  If there were errors, fix and rerun './setup_ci.rb'.
  Pass the '--force' param to redo already-completed steps
* sudo /etc/init.d/cruise start
* Go to http://ubuntu-host:3333
* Configure ccrb and add your projects
* For help with cinabox, open a ticket:
  http://thewoolleyweb.lighthouseapp.com/projects/14441-cinabox
* For help with ccrb, try the cruisecontrolrb homepage and users mailing list:
  http://cruisecontrolrb.thoughtworks.com/
  http://rubyforge.org/mailman/listinfo/cruisecontrolrb-users

LICENSE:

(The MIT License)

Copyright (c) 2008 Chad Woolley

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
