#!/bin/bash

NAME_ROOT=electrum
PYTHON_VERSION=2.7.14

# These settings probably don't need any change
export WINEPREFIX=/opt/wine64
export PYTHONDONTWRITEBYTECODE=1
export PYTHONHASHSEED=22

PYHOME=c:/python$PYTHON_VERSION
PYTHON="wine $PYHOME/python.exe -OO -B"

NSIS_FILENAME=nsis-3.02.1-setup.exe
NSIS_URL=https://prdownloads.sourceforge.net/nsis/$NSIS_FILENAME?download
NSIS_SHA256=736c9062a02e297e335f82252e648a883171c98e0d5120439f538c81d429552e

ZBAR_FILENAME=zbarw-20121031-setup.exe
ZBAR_URL=https://sourceforge.net/projects/zbarw/files/$ZBAR_FILENAME/download
ZBAR_SHA256=177e32b272fa76528a3af486b74e9cb356707be1c5ace4ed3fcee9723e2c2c02

LIBUSB_FILENAME=libusb-1.0.21.7z
LIBUSB_URL=https://prdownloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.21/$LIBUSB_FILENAME?download
LIBUSB_SHA256=acdde63a40b1477898aee6153f9d91d1a2e8a5d93f832ca8ab876498f3a6d2b8

# Install ZBar
wget -O $ZBAR_FILENAME "$ZBAR_URL"
wine "$ZBAR_FILENAME" /S

# Upgrade setuptools (so Electrum can be installed later)
$PYTHON -m pip install setuptools --upgrade

# Install NSIS installer
wget -O $NSIS_FILENAME "$NSIS_URL"
wine "$NSIS_FILENAME" /S

wget -O $LIBUSB_FILENAME "$LIBUSB_URL"
7z x -olibusb $LIBUSB_FILENAME -aos

# Let's begin!
cd `dirname $0`
set -e

mkdir -p tmp
cd tmp

for repo in electrumx-wallet-tor; do
    if [ -d $repo ]; then
	cd $repo
	git pull
	git checkout master
	cd ..
    else
	URL=https://github.com/nosferatu500/$repo.git
	git clone -b master $URL $repo
    fi
done

for repo in electrum-locale electrum-icons; do
    if [ -d $repo ]; then
	cd $repo
	git pull
	git checkout master
	cd ..
    else
	URL=https://github.com/spesmilo/$repo.git
	git clone -b master $URL $repo
    fi
done

pushd electrum-locale
for i in ./locale/*; do
    dir=$i/LC_MESSAGES
    mkdir -p $dir
    msgfmt --output-file=$dir/electrum.mo $i/electrum.po || true
done
popd

pushd electrumx-wallet-tor
if [ ! -z "$1" ]; then
    git checkout $1
fi

VERSION=`git describe --tags`
echo "Last commit: $VERSION"
find -exec touch -d '2000-11-11T11:11:11+00:00' {} +
popd

rm -rf $WINEPREFIX/drive_c/electrum
cp -r electrumx-wallet-tor $WINEPREFIX/drive_c/electrum
cp electrumx-wallet-tor/LICENCE .
cp -r electrum-locale/locale $WINEPREFIX/drive_c/electrum/lib/
cp electrum-icons/icons_rc.py $WINEPREFIX/drive_c/electrum/gui/qt/

# Install frozen dependencies
$PYTHON -m pip install -r ../../deterministic-build/requirements.txt

$PYTHON -m pip install -r ../../deterministic-build/requirements-hw.txt

pushd $WINEPREFIX/drive_c/electrum
$PYTHON setup.py install
popd

cd ..

rm -rf dist/

# build standalone and portable versions
 wine "C:/python$PYTHON_VERSION/scripts/pyinstaller.exe" --noconfirm --ascii --name $NAME_ROOT-$VERSION -w deterministic_new.spec
# wine "C:/python$PYTHON_VERSION/scripts/pyinstaller.exe" --noconfirm --ascii --name $NAME_ROOT-$VERSION -w deterministic.spec

# set timestamps in dist, in order to make the installer reproducible
pushd dist
find -exec touch -d '2000-11-11T11:11:11+00:00' {} +
popd

# build NSIS installer
# $VERSION could be passed to the electrum.nsi script, but this would require some rewriting in the script iself.
wine "$WINEPREFIX/drive_c/Program Files/NSIS/makensis.exe" /DPRODUCT_VERSION=$VERSION electrum.nsi

cd dist
mv electrum-setup.exe $NAME_ROOT-$VERSION-setup.exe
cd ..

echo "Done."
md5sum dist/electrum*exe