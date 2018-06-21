Electrum-CRYP for TOR - 
------------------------------------------------
lightweight CrypticCoin client for connecting 
------------------------------------------------
to the CRYP Tor Electrum Server
------------------------------------------------
![Electrum-CRYP](https://raw.githubusercontent.com/vergecurrency/electrum-xvg-tor/master/electrumlogo.png)

[![Build Status](https://travis-ci.org/vergecurrency/electrum-xvg-tor.svg?branch=master)](https://travis-ci.org/vergecurrency/electrum-xvg-tor)

Licence: GNU GPL v3

Authors: sunerok, bitspill & whit3water

Language: Python

Homepage: http://CrypticCoin.io/

Download TOR: https://www.torproject.org/download/download

For binary windows release, just run Tor, and then run the electrum .exe

![electrum-windows](http://i.imgur.com/E4zj9JL.png)

1.a) GETTING STARTED WITH UBUNTU/LINUX
------------------
sudo apt-get update

sudo apt-get install tor

sudo service tor start && sudo service tor stop

now go to /etc/tor/ and edit the torrc file. (you can use sudo nano torrc)

you just need to remove the # before the line that starts with SocksPort 9050

then save torrc, and go back to command prompt and type sudo service tor restart.

now we install the electrum wallet!

sudo apt-get install git pyqt4-dev-tools python-pip python-dev python-slowaes python-pip

sudo pip install pyasn1 pyasn1-modules pbkdf2 tlslite qrcode

git clone https://github.com/nosferatu500/electrumx-wallet-tor && cd electrumx-wallet-tor

pyrcc4 icons.qrc -o gui/qt/icons_rc.py

sudo python setup.py install

chmod +x ./electrum-xvg

To run Electrum from this directory, just do:
---------------------------------------------
  ./electrum-xvg

To start Electrum from your web browser, see
--------------------------------------------
http://electrum-cryticcoin.xyz/cryticcoin.html

To update your copy of the electrum client:
-------------------------------------------
cd electrum-xvg

git pull

sudo python setup.py install

1.b) GETTING STARTED WITH WINDOWS
------------------

-download this repo as a zip and extract it to where you would like it to run from. 
https://github.com/nosferatu500/electrumx-wallet-tor/archive/master.zip

-download python 2.7 for windows here: https://www.python.org/ftp/python/2.7.10/python-2.7.10.msi

-download Microsoft Visual C++ Compiler for Python 2.7 here: http://www.microsoft.com/en-us/download/confirmation.aspx?id=44266

-download python qt4: http://sourceforge.net/projects/pyqt/files/PyQt4/PyQt-4.11.3/PyQt4-4.11.3-gpl-Py2.7-Qt4.8.6-x64.exe

-then in ms visual studio command prompt, go into the directory electrum-xvg:

pyrcc4 icons.qrc -o gui/qt/icons_rc.py

py -m pip install pip pyasn1 pyasn1-modules pbkdf2 tlslite qrcode ecdsa ltc_scrypt pyrcc

py setup.py install

py electrum-xvg

1c) INSTALLING WITH MAC OSX
-----------------

install python if you dont already have it.

https://www.python.org/ftp/python/2.7.10/python-2.7.10-macosx10.6.pkg

pip intall slowaes

python setup.py build

Modify electrum-xvg and change python2 to python in the first line

sudo python setup.py install

then install tor and modify the torrc file, by removing the # from in front of SocksProxy, and change the 9150 to 9050.

restart tor, then launch wallet by 

py electrum-xvg


2. HOW OFFICIAL PACKAGES ARE CREATED
------------------------------------

python mki18n.py

pyrcc4 icons.qrc -o gui/qt/icons_rc.py

python setup.py sdist --format=zip,gztar

On Mac OS X:

  # On port based installs
  
  sudo python setup-release.py py2app

  # On brew installs
  
  ARCHFLAGS="-arch i386 -arch x86_64" sudo python setup-release.py py2app --includes sip

  sudo hdiutil create -fs HFS+ -volname "Electrum-CRYP" -srcfolder dist/Electrum-CRYP.app dist/electrum-xvg-VERSION-macosx.dmg


[![Visit our IRC Chat!](https://kiwiirc.com/buttons/irc.freenode.net/cryticcoin.png)](https://kiwiirc.com/client/irc.freenode.net/?nick=xvg|?&theme=cli#cryticcoin)
