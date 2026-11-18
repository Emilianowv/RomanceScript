param([string]$OutputDirectory)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$version = (Get-Content (Join-Path $root 'VERSION') -Raw).Trim()
if ($version -notmatch '^\d+\.\d+\.\d+$') { throw 'Invalid VERSION' }
if (-not $OutputDirectory) { $OutputDirectory = Join-Path $root 'dist' }
$OutputDirectory = [IO.Path]::GetFullPath($OutputDirectory)
$work = Join-Path ([IO.Path]::GetTempPath()) ('romancescript-' + [guid]::NewGuid())
$inno = Join-Path ${env:ProgramFiles(x86)} 'Inno Setup 6\ISCC.exe'
if (-not (Test-Path $inno)) { throw 'Install Inno Setup 6.3 or later before building.' }

function Invoke-Tool($File, [string[]]$Arguments) {
    & $File @Arguments
    if ($LASTEXITCODE -ne 0) { throw "$File exited with code $LASTEXITCODE" }
}

New-Item -ItemType Directory -Path $work | Out-Null
try {
    $download = Join-Path $work 'MSKLC.exe'
    $url = 'https://download.microsoft.com/download/6/f/5/6f5ce43a-e892-4fd1-b9a6-1a0cbb64e6e2/MSKLC.exe'
    Invoke-WebRequest -Uri $url -OutFile $download
    $sha256 = 'cd12a6b08066133dc4ad71bdcaccf1492e3d9a1de93cf84b7b2824309f0d7255'
    if ((Get-FileHash $download -Algorithm SHA256).Hash.ToLowerInvariant() -ne $sha256) {
        throw 'The Microsoft MSKLC download did not match the expected SHA256.'
    }
    Invoke-Tool '7z.exe' @('x', '-y', "-o$work", $download)
    $msi = Join-Path $work 'MSKLC\MSKLC.msi'
    $sdk = Join-Path $work 'sdk'
    $result = Start-Process msiexec.exe -ArgumentList "/a `"$msi`" /qn TARGETDIR=`"$sdk`"" -Wait -PassThru
    if ($result.ExitCode -ne 0) { throw "MSKLC extraction failed: $($result.ExitCode)" }
    $compiler = Join-Path $sdk 'bin\i386\kbdutool.exe'

    foreach ($target in @(@{ Name = 'x64'; Switch = '-m' }, @{ Name = 'wow64'; Switch = '-o' })) {
        $directory = Join-Path $work $target.Name
        New-Item -ItemType Directory -Path $directory | Out-Null
        Copy-Item (Join-Path $PSScriptRoot 'RomanceScript.klc') $directory
        Push-Location $directory
        try {
            Invoke-Tool $compiler @('-u', $target.Switch, 'RomanceScript.klc')
            if (-not (Test-Path 'ROM.dll' -PathType Leaf)) { throw 'kbdutool did not produce ROM.dll' }
        } finally {
            Pop-Location
        }
    }
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
    Invoke-Tool $inno @("/DLayoutVersion=$version", "/DLayoutBuild=$work", "/O$OutputDirectory", (Join-Path $PSScriptRoot 'RomanceScript.iss'))
} finally {
    Remove-Item -LiteralPath $work -Recurse -Force
}
