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
sudo python3.5 -m pip install pyasn1 pyasn1-modules pbkdf2 tlslite qrcode

sudo add-apt-repository ppa:webupd8team/tor-browser
sudo apt-get update
sudo apt-get install tor -y

sudo cp -r /var/lib/tor /var/lib/tor2

sudo cp torrc_el /etc/tor

pyrcc4 icons.qrc -o gui/qt/icons_rc.py

chmod 775 electrum-xvg

sudo cp -r .electrum-xvg-tor $HOME

sudo chown -R $USER:$USER $HOME/.electrum-xvg-tor/

sudo tor -f /etc/tor/torrc_el  &

./electrum-xvg
