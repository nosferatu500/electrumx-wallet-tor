#!/bin/bash

# You probably need to update only this link
ELECTRUM_GIT_URL=git://github.com/nosferatu500/electrumx-wallet-tor.git
BRANCH=master
NAME_ROOT=electrum-cryp-tor

# These settings probably don't need any change
export WINEPREFIX=/opt/wine-electrum
PYHOME=c:/python26
PYTHON="wine $PYHOME/python.exe -OO -B"

# Let's begin!
cd `dirname $0`
set -e

cd tmp

if [ -d "electrum-cryp-tor-git" ]; then
    # GIT repository found, update it
    echo "Pull"

    cd electrum-cryp-tor-git
    git pull
    cd ..

else
    # GIT repository not found, clone it
    echo "Clone"

    git clone -b $BRANCH $ELECTRUM_GIT_URL electrum-cryp-tor-git
fi

cd electrum-cryp-tor-git
COMMIT_HASH=`git rev-parse HEAD | awk '{ print substr($1, 0, 11) }'`
echo "Last commit: $COMMIT_HASH"
cd ..


rm -rf $WINEPREFIX/drive_c/electrum-cryp-tor
cp -r electrum-cryp-tor-git $WINEPREFIX/drive_c/electrum-cryp-tor
cp electrum-cryp-tor-git/LICENCE .

# Build Qt resources
wine $WINEPREFIX/drive_c/Python26/Lib/site-packages/PyQt4/pyrcc4.exe C:/electrum-cryp-tor-git/icons.qrc -o C:/electrum-cryp-tor-git/lib/icons_rc.py

# Copy ZBar libraries to electrum
#cp "$WINEPREFIX/drive_c/Program Files (x86)/ZBar/bin/"*.dll "$WINEPREFIX/drive_c/electrum-cryp-tor-git/"

cd ..

rm -rf dist/

# For building standalone compressed EXE, run:
$PYTHON "C:/pyinstaller/pyinstaller.py" --noconfirm --ascii -w --onefile "C:/electrum-cryp-tor-git/electrum-cryp"

# For building uncompressed directory of dependencies, run:
$PYTHON "C:/pyinstaller/pyinstaller.py" --noconfirm --ascii -w deterministic.spec

# For building NSIS installer, run:
wine "$WINEPREFIX/drive_c/Program Files (x86)/NSIS/makensis.exe" electrum-cryp.nsi
#wine $WINEPREFIX/drive_c/Program\ Files\ \(x86\)/NSIS/makensis.exe electrum-cryp.nsis

DATE=`date +"%Y%m%d"`
cd dist
mv electrum-cryp.exe $NAME_ROOT-$DATE-$COMMIT_HASH.exe
mv electrum-cryp $NAME_ROOT-$DATE-$COMMIT_HASH
mv electrum-cryp-setup.exe $NAME_ROOT-$DATE-$COMMIT_HASH-setup.exe
zip -r $NAME_ROOT-$DATE-$COMMIT_HASH.zip $NAME_ROOT-$DATE-$COMMIT_HASH
