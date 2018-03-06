#!/bin/bash

# You probably need to update only this link
ELECTRUM_GIT_URL=git://github.com/nosferatu500/electrumx-wallet-tor.git
BRANCH=master
NAME_ROOT=electrum

# These settings probably don't need any change
export WINEPREFIX=/opt/wine64
PYHOME=c:/python2.7.14
PYTHON="wine $PYHOME/python.exe -OO -B"

# Let's begin!
cd `dirname $0`
set -e

cd tmp

if [ -d "electrum-xvg-tor-git" ]; then
    # GIT repository found, update it
    echo "Pull"

    cd electrum-xvg-tor-git
    git pull
    cd ..

else
    # GIT repository not found, clone it
    echo "Clone"

    git clone -b $BRANCH $ELECTRUM_GIT_URL electrum-xvg-tor-git
fi

cd electrum-xvg-tor-git
COMMIT_HASH=`git rev-parse HEAD | awk '{ print substr($1, 0, 11) }'`
echo "Last commit: $COMMIT_HASH"
cd ..


rm -rf $WINEPREFIX/drive_c/electrum-xvg-tor
cp -r electrum-xvg-tor-git $WINEPREFIX/drive_c/electrum-xvg-tor
cp electrum-xvg-tor-git/LICENCE .

# Build Qt resources
wine $WINEPREFIX/drive_c/python2.7.14/Lib/site-packages/PyQt4/pyrcc4.exe C:/electrum/icons.qrc -o C:/electrum/lib/icons_rc.py

# Copy ZBar libraries to electrum
#cp "$WINEPREFIX/drive_c/Program Files (x86)/ZBar/bin/"*.dll "$WINEPREFIX/drive_c/electrum-xvg-tor-git/"

cd ..

rm -rf dist/

# For building standalone compressed EXE, run:
wine "C:/python2.7.14/scripts/pyinstaller.exe" --noconfirm --ascii -w --onefile "C:/electrum-xvg-tor/electrum-xvg"

# For building uncompressed directory of dependencies, run:
wine "C:/python2.7.14/scripts/pyinstaller.exe" --noconfirm --ascii -w deterministic.spec

# For building NSIS installer, run:
wine "$WINEPREFIX/drive_c/Program Files/NSIS/makensis.exe" electrum.nsi
#wine $WINEPREFIX/drive_c/Program\ Files\ \(x86\)/NSIS/makensis.exe electrum-xvg.nsis

DATE=`date +"%Y%m%d"`
cd dist
mv electrum-xvg.exe $NAME_ROOT-$DATE-$COMMIT_HASH.exe
mv electrum-xvg $NAME_ROOT-$DATE-$COMMIT_HASH
mv electrum-xvg-setup.exe $NAME_ROOT-$DATE-$COMMIT_HASH-setup.exe
zip -r $NAME_ROOT-$DATE-$COMMIT_HASH.zip $NAME_ROOT-$DATE-$COMMIT_HASH