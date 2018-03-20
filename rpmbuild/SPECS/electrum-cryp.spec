Name:           electrum-cryp
Version:        0.1.1
Release:        1%{?dist}
Summary:        Electrum-CRYP Wallet

License:        GPL
Source0:        electrum-cryp-0.1.1.tar.gz

%description
Electrum-CRYP Wallet

%prep
%setup -q

%install
rm -rf $RPM_BUILD_ROOT
install -d $RPM_BUILD_ROOT/usr/bin/electrum-cryp-0.1.1
cp -a ./*  $RPM_BUILD_ROOT/usr/bin/electrum-cryp-0.1.1

%clean
rm -rf $RPM_BUILD_ROOT

%files
/usr/bin/electrum-cryp-0.1.1

%post
echo " "
echo "Instalation complete."
