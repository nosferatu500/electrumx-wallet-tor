#!/bin/bash

cd $HOME

#Clone project
if [ ! -d electrumx-wallet-tor ]; then
  git clone https://github.com/nosferatu500/electrumx-wallet-tor.git
fi

set -e

#Install dependencies for build project
cd electrumx-wallet-tor

sudo apt-get install git pyqt4-dev-tools python-pip python-dev python-slowaes

wget https://bootstrap.pypa.io/get-pip.py
sudo python3.5 get-pip.py

sudo python3.5 -m pip install pyasn1 pyasn1-modules pbkdf2 tlslite qrcode

sudo python -m pip install protobuf dnspython pbkdf2 tlslite qrcode six requests ecdsa slowaes

sudo add-apt-repository ppa:webupd8team/tor-browser
sudo apt-get update
sudo apt-get install tor -y

sudo cp -r /var/lib/tor /var/lib/tor2

echo "HiddenServiceDir $HOME/electrumx-wallet-tor/tor/" >>  torrc_el 
echo "HiddenServicePort 50001 88.99.174.169:50001" >>  torrc_el 
echo "HiddenServicePort 50002 88.99.174.169:50002" >>  torrc_el 


sudo cp torrc_el /etc/tor

pyrcc4 icons.qrc -o gui/qt/icons_rc.py

chmod 775 electrum-xvg

sudo cp -r .electrum-xvg-tor $HOME

sudo chown -R $USER:$USER $HOME/.electrum-xvg-tor/

sudo tor -f /etc/tor/torrc_el --RunAsDaemon 1

#############################
########## WARNING ##########
#############################

# Save  your unique key for access to blockchain'

################################

sudo sed -n '1p' tor/hostname

################################

# Use upper line for  connect to server'


./electrum-xvg
