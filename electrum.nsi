;--------------------------------
;Include Modern UI

  !include "MUI2.nsh"

;--------------------------------
;General

  ;Name and file
  Name "Electrum"
  OutFile "dist/electrum-setup.exe"

  ;Default installation folder
  InstallDir "$PROGRAMFILES\Electrum"

  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\Electrum" ""

  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin

;--------------------------------
;Variables

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING

;--------------------------------
;Pages

  ;!insertmacro MUI_PAGE_LICENSE "tmp/LICENCE"
  ;!insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY

  ;Start Menu Folder Page Configuration
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU"
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\Electrum"
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"

  ;!insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder

  !insertmacro MUI_PAGE_INSTFILES

  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section

  SetOutPath "$INSTDIR"

  ;ADD YOUR OWN FILES HERE...
  file /r build\electrum-xvg\*.*

  ;Store installation folder
  WriteRegStr HKCU "Software\Electrum" "" $INSTDIR

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\Uninstall.exe"


  CreateShortCut "$DESKTOP\Electrum.lnk" "$INSTDIR\electrum-xvg.exe" ""

  ;create start-menu items
  CreateDirectory "$SMPROGRAMS\Electrum"
  CreateShortCut "$SMPROGRAMS\Electrum\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\Electrum\Electrum.lnk" "$INSTDIR\electrum-xvg.exe" "" "$INSTDIR\electrum-xvg.exe" 0

  CopyFiles "C:\Program files\Electrum\torrc" "C:\Users\user\AppData\Roaming\tor\torrc"
  Exec "C:\Program files\Electrum\tor\Tor\tor.exe --service install"
  Exec "C:\Program files\Electrum\tor\Tor\tor.exe --service start"

SectionEnd

;--------------------------------
;Descriptions

  ;Assign language strings to sections
  ;!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  ;  !insertmacro MUI_DESCRIPTION_TEXT ${SecDummy} $(DESC_SecDummy)
  ;!insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  ;ADD YOUR OWN FILES HERE...
  RMDir /r "$INSTDIR\*.*"

  RMDir "$INSTDIR"

  Delete "$DESKTOP\Electrum.lnk"
  Delete "$SMPROGRAMS\Electrum\*.*"
  RmDir  "$SMPROGRAMS\Electrum"

  DeleteRegKey /ifempty HKCU "Software\Electrum"

SectionEnd