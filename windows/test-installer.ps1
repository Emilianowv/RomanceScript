# Run only on the disposable Windows CI runner.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$version = (Get-Content (Join-Path $root 'VERSION') -Raw).Trim()
$setup = Join-Path $root "dist/RomanceScript-$version-Windows-x64.exe"
$app = Join-Path $env:ProgramFiles 'RomanceScript'
$key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layouts\A39A0C0A'
$dll = Join-Path $env:SystemRoot 'System32\kbdromsc.dll'
$wow = Join-Path $env:SystemRoot 'SysWOW64\kbdromsc.dll'
$flags = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART'

function Run-Setup($File) {
    $result = Start-Process $File -ArgumentList $flags -Wait -PassThru
    if ($result.ExitCode -ne 0) { throw "$File failed: $($result.ExitCode)" }
}

Add-Type @'
using System;
using System.Runtime.InteropServices;
using System.Text;

public static class KeyboardProbe {
    [DllImport("user32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    public static extern IntPtr LoadKeyboardLayout(string klid, uint flags);
    [DllImport("user32.dll")]
    public static extern bool UnloadKeyboardLayout(IntPtr layout);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    private static extern uint MapVirtualKeyEx(uint code, uint mode, IntPtr layout);
    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    private static extern int ToUnicodeEx(uint key, uint scan, byte[] state,
        StringBuilder output, int length, uint flags, IntPtr layout);

    public static void Expect(IntPtr layout, uint key, bool shift, bool altGr, int count, string text) {
        var state = new byte[256];
        if (shift) state[0x10] = 0x80;
        if (altGr) {
            state[0x11] = state[0x12] = 0x80;
            state[0xa2] = state[0xa5] = 0x80;
        }
        var output = new StringBuilder(16);
        uint scan = MapVirtualKeyEx(key, 0, layout);
        int actual = ToUnicodeEx(key, scan, state, output, output.Capacity, 0, layout);
        if (actual != count || (actual > 0 && output.ToString() != text))
            throw new Exception(String.Format("VK {0:X}: expected {1} '{2}', got {3} '{4}'",
                key, count, text, actual, output));
    }
}
'@

if ((Test-Path $key) -or (Test-Path $dll) -or (Test-Path $wow) -or (Test-Path $app)) {
    throw 'Use a clean Windows runner.'
}
Run-Setup $setup
Run-Setup $setup
$layout = [IntPtr]::Zero
try {
    $entry = Get-ItemProperty $key
    if ($entry.'Layout File' -ne 'kbdromsc.dll' -or $entry.'Layout Text' -ne 'RomanceScript') {
        throw 'Incorrect keyboard registration'
    }
    if (-not (Test-Path $dll) -or -not (Test-Path $wow)) { throw 'Missing installed DLL' }
    $layout = [KeyboardProbe]::LoadKeyboardLayout('A39A0C0A', 0)
    if ($layout -eq [IntPtr]::Zero) { throw 'Windows could not load RomanceScript' }
    [KeyboardProbe]::Expect($layout, 0xBC, $false, $true, 1, '<')
    [KeyboardProbe]::Expect($layout, 0xBE, $false, $true, 1, '>')
    [KeyboardProbe]::Expect($layout, 0xBC, $true, $true, 1, '•')
    [KeyboardProbe]::Expect($layout, 0xBE, $true, $true, 1, '·')
    [KeyboardProbe]::Expect($layout, 0xBB, $false, $true, 1, '×')
    [KeyboardProbe]::Expect($layout, 0xBB, $true, $true, 1, '÷')
    [KeyboardProbe]::Expect($layout, 0xDB, $false, $false, -1, '')
    [KeyboardProbe]::Expect($layout, 0x20, $false, $false, 1, "'")
    [KeyboardProbe]::Expect($layout, 0xDB, $false, $false, -1, '')
    [KeyboardProbe]::Expect($layout, 0x45, $false, $false, 1, 'è')
    [KeyboardProbe]::Expect($layout, 0xDD, $true, $false, -1, '')
    [KeyboardProbe]::Expect($layout, 0x53, $false, $false, 1, 'ș')
} finally {
    if ($layout -ne [IntPtr]::Zero) { [void][KeyboardProbe]::UnloadKeyboardLayout($layout) }
    Run-Setup (Join-Path $app 'unins000.exe')
}
if ((Test-Path $key) -or (Test-Path $dll) -or (Test-Path $wow)) {
    throw 'The uninstaller left a registry entry or a layout DLL'
}
Write-Host 'Windows installation, reinstall, character translation and uninstall passed.'
