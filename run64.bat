sc create tor binPath= "C:\Program Files (x86)\Electrum\tor\Tor\tor.exe -nt-service -f %userprofile%\AppData\Roaming\tor\torrc" DisplayName= "TOR" start= auto
sc start tor