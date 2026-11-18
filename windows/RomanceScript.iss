#define LayoutKey "SYSTEM\CurrentControlSet\Control\Keyboard Layouts"
#define LayoutCode "A39A0C0A"
#define LayoutId "039A"
#define LayoutDll "kbdromsc.dll"

[Setup]
AppId={{91D9CF61-EF5A-4301-9283-ADAE235552D2}
AppName=RomanceScript
AppVersion={#LayoutVersion}
AppPublisher=Emilianowv
DefaultDirName={autopf}\RomanceScript
DisableDirPage=yes
DisableProgramGroupPage=yes
PrivilegesRequired=admin
ArchitecturesAllowed=x64os
ArchitecturesInstallIn64BitMode=x64os
MinVersion=10.0
OutputBaseFilename=RomanceScript-{#LayoutVersion}-Windows-x64
Compression=lzma2
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"

[Files]
Source: "{#LayoutBuild}\x64\ROM.dll"; DestDir: "{sys}"; DestName: "{#LayoutDll}"; Flags: ignoreversion restartreplace uninsrestartdelete
Source: "{#LayoutBuild}\wow64\ROM.dll"; DestDir: "{syswow64}"; DestName: "{#LayoutDll}"; Flags: ignoreversion restartreplace uninsrestartdelete
Source: "..\COPYRIGHT"; DestDir: "{app}"

[Registry]
Root: HKLM; Subkey: "{#LayoutKey}\{#LayoutCode}"; Flags: uninsdeletekeyifempty
Root: HKLM; Subkey: "{#LayoutKey}\{#LayoutCode}"; ValueType: string; ValueName: "Layout File"; ValueData: "{#LayoutDll}"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "{#LayoutKey}\{#LayoutCode}"; ValueType: string; ValueName: "Layout Text"; ValueData: "RomanceScript"; Flags: uninsdeletevalue
Root: HKLM; Subkey: "{#LayoutKey}\{#LayoutCode}"; ValueType: string; ValueName: "Layout Id"; ValueData: "{#LayoutId}"; Flags: uninsdeletevalue

[Code]
function InitializeSetup(): Boolean;
var
  Layouts: TArrayOfString;
  Index: Integer;
  Existing: String;
begin
  Result := False;
  if not RegGetSubkeyNames(HKLM64, '{#LayoutKey}', Layouts) then
    Exit;
  for Index := 0 to GetArrayLength(Layouts) - 1 do
  begin
    if CompareText(Layouts[Index], '{#LayoutCode}') = 0 then
    begin
      if not RegQueryStringValue(HKLM64, '{#LayoutKey}\' + Layouts[Index], 'Layout File', Existing)
        or (CompareText(Existing, '{#LayoutDll}') <> 0) then
      begin
        MsgBox('The RomanceScript keyboard code is already in use.', mbError, MB_OK);
        Exit;
      end;
    end
    else if RegQueryStringValue(HKLM64, '{#LayoutKey}\' + Layouts[Index], 'Layout Id', Existing)
      and (CompareText(Existing, '{#LayoutId}') = 0) then
    begin
      MsgBox('The RomanceScript keyboard identifier is already in use.', mbError, MB_OK);
      Exit;
    end;
  end;
  Result := True;
end;
