#!/bin/bash


#Clone project
if [ ! -d electrumx-wallet-tor ]; then
  git clone https://github.com/nosferatu500/electrumx-wallet-tor.git
fi
set -e

cd electrumx-wallet-tor


sudo easy_install pip

sudo python -m pip install protobuf dnspython pbkdf2 tlslite qrcode six requests ecdsa slowaes

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"


brew install cartr/qt4/pyqt

pyrcc4 icons.qrc -o gui/qt/icons_rc.py

sudo python -m pip install protobuf dnspython pbkdf2 tlslite qrcode six requests ecdsa slowaes

sudo python3 -m pip install protobuf dnspython pbkdf2 tlslite qrcode six requests ecdsa slowaes  pyaes jsonrpclib-pelix pysocks 

brew install pyqt5

pyrcc5 icons.qrc -o gui/qt/icons_rc.py

brew install tor

sudo cp -r /usr/local/Cellar/tor /usr/local/Cellar/tor2

echo "HiddenServiceDir $HOME/electrumx-wallet-tor/tor/" >>  torrc_el_mac 
echo "HiddenServicePort 50001 78.46.201.35:50001" >>  torrc_el_mac
echo "HiddenServicePort 50002 78.46.201.35:50002" >>  torrc_el_mac

sudo cp torrc_el_mac /usr/local/Cellar/tor2

sudo tor -f /usr/local/Cellar/tor2/torrc_el_mac --RunAsDaemon 1

./electrum-xvg

