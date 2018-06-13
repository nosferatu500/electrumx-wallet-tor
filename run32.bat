sc create tor binPath= "C:\Program Files\Electrum\tor\Tor\tor.exe -nt-service -f %userprofile%\AppData\Roaming\tor\torrc" DisplayName= "TOR" start= auto
sc start tor
