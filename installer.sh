#!/bin/sh

# only for FreeBSD!!
# you must run this script with superuser privileges.

pkg install ruby
pkg install git

cd ~
git clone https://github.com/setscript/openfort

mv openfort/fort.rb /bin/fort.rb
mv openfort/fort.sh /bin/fort
mv openfort/fort.config /bin/fort.config

cd /bin/
chmod +x fort

echo "The basic installation is complete, but you still need to open the fort.config file.(fort.sh)"
