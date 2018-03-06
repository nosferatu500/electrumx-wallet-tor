#!/bin/bash

# You probably need to update only this link
ELECTRUM_URL=https://github.com/nosferatu500/electrumx-wallet-tor/archive/v0.1.1.zip
NAME_ROOT=electrum-0.1.1

# These settings probably don't need any change
export WINEPREFIX=/opt/wine-electrum
PYHOME=c:/python26
PYTHON="wine $PYHOME/python.exe -OO -B"

# Let's begin!
cd `dirname $0`
set -e

cd tmp

# Download and unpack Electrum
wget -O electrum-xvg.tgz "$ELECTRUM_URL"
unzip electrum-xvg.tgz
#mv Electrum-* electrum
rm -rf $WINEPREFIX/drive_c/electrumx-wallet-tor-0.1.1
cp electrumx-wallet-tor-0.1.1/LICENCE .
mv electrumx-wallet-tor-0.1.1 $WINEPREFIX/drive_c

# Copy ZBar libraries to electrum
#cp "$WINEPREFIX/drive_c/Program Files (x86)/ZBar/bin/"*.dll "$WINEPREFIX/drive_c/electrum/"

cd ..

rm -rf dist/$NAME_ROOT
rm -f dist/$NAME_ROOT.zip
rm -f dist/$NAME_ROOT.exe
rm -f dist/$NAME_ROOT-setup.exe

# For building standalone compressed EXE, run:
$PYTHON "C:/pyinstaller/pyinstaller.py" --noconfirm --ascii -w --onefile "C:/electrum-xvg/electrumx-wallet-tor-0.1.1"

# For building uncompressed directory of dependencies, run:
$PYTHON "C:/pyinstaller/pyinstaller.py" --noconfirm --ascii -w deterministic.spec

# For building NSIS installer, run:
#wine "$WINEPREFIX/drive_c/Program Files/NSIS/makensis.exe" electrum.nsi
wine $WINEPREFIX/drive_c/Program\ Files\ \(x86\)/NSIS/makensis.exe electrum.nsis

cd dist
mv electrum-xvg.exe $NAME_ROOT.exe
mv electrum-xvg $NAME_ROOT
mv electrum-xvg-setup.exe $NAME_ROOT-setup.exe
zip -r $NAME_ROOT.zip $NAME_ROOT
