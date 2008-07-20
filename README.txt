cinabox
    by Chad Woolley (http://thewoolleyweb.com)
    http://github.com/thewoolleyman/cinabox/tree/master/README.txt

== DESCRIPTION:
  
Continuous Integration - in a Box

== FEATURES/PROBLEMS:
  
* CI in a Box automates the setup of a Continuous Integration system by doing The Simplest Thing That Could Possibly Work.

== SYNOPSIS:

* Simplicity Rules.  CINABOX is only tested on Ubuntu 8.04.  If it works on anything else, it is by coincidence.  If it doesn't work, hack it up yourself or try running the commands manually - the scripts are intended to be easily readable and easily changed.

* Support: http://thewoolleyweb.lighthouseapp.com/projects/14441-cinabox

* For more detailed and advanced info on Continuous Integration and Ubuntu/VMWare setup, see my RailsConf 2008 tutorial:  http://www.thewoolleyweb.com/ci_for_the_rails_guy_or_gal/presentation/ci_for_the_rails_guy_or_gal.pdf

== REQUIREMENTS:

* Ubuntu 8.04 and an internet connection
* The ability to be patient, read instructions, pay attention to details, and use Google/Mailing Lists to find additional info and solve unexpected problems.  There will be many.  They will never stop.  That is the nature of Continuous Integration.  Stop and take a breath.

== INSTALL:

* Install Ubuntu 8.04 manually or as a virtual machine:
  * http://www.ubuntu.com/getubuntu/download
  * VMWare Player (win): http://www.vmware.com/products/player/
  * VMWare Fusion (mac): http://www.vmware.com/download/fusion/
  * Ubuntu 8.04 VMWare image: 
    * Here's one: http://symbiosoft.net/UbuntuServerMinimalVA
    * Or search for "Ubuntu 8.04" Operating System VMs to find one that works for you: http://www.vmware.com/appliances/directory/cat/45
* cd
* wget http://github.com/thewoolleyman/cinabox/tarball/master
* tar -zxvf thewoolleyman-cinabox-<GUID>.tar.gz # <GUID> is the current git GUID
* cd thewoolleyman-cinabox-<GUID>
* ./bootstrap_ruby.sh
* ruby setup_ci.rb
* sudo /etc/init.d/ccrb_daemon start
* Go to http://ubuntu-host:3333
* Add your projects using ~/ccrb/cruise (See docs at http://cruisecontrolrb.thoughtworks.com/)

== LICENSE:

(The MIT License)

Copyright (c) 2007 Chad Woolley

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
