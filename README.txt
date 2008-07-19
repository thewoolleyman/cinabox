cinabox
    by Chad Woolley (http://thewoolleyweb.com)
    http://github.com/thewoolleyman/cinabox/tree/master/README.txt

== DESCRIPTION:
  
Continuous Integration - in a Box

== FEATURES/PROBLEMS:
  
* The purpose of CI in a Box is to automate the setup of a Continuous Integration system by doing The Simplest Thing That Could Possibly Work.

== SYNOPSIS:

* Simplicity Rules.  CINABOX is only tested on Ubuntu 8.04.  If it works on anything else, it is by coincidence.  If it doesn't work, hack it up yourself or try running the commands manually - the scripts are intended to be easily readable and easily changed.

Questions/Comments?  Email me at thewoolleyman@gmail.com

== REQUIREMENTS:

* Ubuntu 8.04 and an internet connection
* The ability to be patient, read instructions, pay attention to details, and use Google/Mailing Lists to find additional info and solve unexpected problems.  There will be many.  They will never stop.

== INSTALL:

* Install Ubuntu 8.04
  * Get VMWare Player: http://www.vmware.com/products/player/
  * Download and Run Ubuntu: 
    * http://www.vmware.com/appliances/directory/1258 or 
    * http://www.visoracle.com/download/ubuntu/
* cd ~
* wget -O cinabox.tar.gz http://github.com/thewoolleyman/cinabox/tree/master%2Fcinabox.tar.gz?raw=true
* tar -zxvf cinabox.tar.gz  # see History.txt for version
* cd cinabox
* ./bootstrap_ruby.sh
* ruby setup_ci.rb
* Add your projects to cruisecontrolrb (http://cruisecontrolrb.thoughtworks.com/)

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
