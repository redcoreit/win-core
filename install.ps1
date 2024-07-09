$Winget = {
    $progressPreference = 'silentlyContinue'
    Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
    Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.8.6/Microsoft.UI.Xaml.2.8.x64.appx -OutFile Microsoft.UI.Xaml.2.8.x64.appx
    Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
    Add-AppxPackage Microsoft.UI.Xaml.2.8.x64.appx
    Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
}

$Core = {
    winget install --id Microsoft.Powershell --source winget
    winget install --id Git.Git --source winget
}

$Terminal = {
    winget install --id Microsoft.WindowsTerminal --source winget
}

$Core_Config = {
    # reload path
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

    # git
    git config --global user.email (Read-Host -Prompt 'Enter email address').Trim()
    git config --global init.defaultBranch "master" 
    git config --global credential.helper "manager" 
    git config --global merge.conflictstyle "diff3" 
    git config --global rebase.autosquash "true" 
    git config --global http.sslVerify "true" 
    git config --global diff.colorMoved "zebra" 
    git config --global core.autocrlf "true" 
    git config --global core.whitespace "cr-at-eol" 
    git config --global core.symlinks "true" 
}

$Dotnet = {
    winget install --id Microsoft.DotNet.SDK.6 --source winget
    # winget install --id Microsoft.DotNet.Framework.DeveloperPack_4 --source winget
}

$Vs = {
    winget install --id Microsoft.VisualStudio.2022.Professional --source winget 
}

$Vs_Config = {
    $RepoUrl = "https://github.com/redcoreit/win-core/raw/master"
    $VsInstallerPath = "C:\Program Files (x86)\Microsoft Visual Studio\Installer"
    $VsPath = "C:\Program Files\Microsoft Visual Studio\2022\Professional"

    Invoke-WebRequest -Uri "$RepoUrl/.vsconfig" -OutFile ".\.vsconfig"
    Invoke-Expression "& '$VsInstallerPath\setup.exe' modify --installPath '$VsPath' --config '.\.vsconfig' --quiet"
}

$MSVC22Win10 = {
    $Override = "--wait --passive --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK"
    winget install Microsoft.VisualStudio.2022.BuildTools --force --override $Override
}

$MSVC22Win10_Config = {
    # Write-Host "PATH: $($env:PATH)`n`nINCLUDE: $($env:INCLUDE)`n`nLIB: $($env:LIB)"
    # echo PATH: %PATH% && echo. && echo INCLUDE: %INCLUDE% && echo. && echo LIB: %LIB%

    $AddPath = "`$Env:PATH += ';C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.40.33807\bin\HostX86\x86;C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\MSBuild\Current\bin\Roslyn;C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\\MSBuild\Current\Bin\amd64;C:\Windows\Microsoft.NET\Framework\v4.0.30319;C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\IDE\;C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\Tools\'"
    $AddInclude = "`$Env:INCLUDE += ';C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.40.33807\include;C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\VS\include'"
    $AddLib = "`$Env:LIB += ';C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\14.40.33807\lib\x86'"

    New-Item -Path (Split-Path $PROFILE -Parent) -ItemType Container -ErrorAction SilentlyContinue
    New-Item -Path $PROFILE -ItemType File -ErrorAction Stop

    Add-Content -Path $PROFILE -Value $AddPath
    Add-Content -Path $PROFILE -Value $AddInclude
    Add-Content -Path $PROFILE -Value $AddLib
}

$MSVC22Win11 = {
    $Override = "--wait --passive --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.22000"
    winget install Microsoft.VisualStudio.2022.BuildTools --force --override $Override
}

$MSVC22Win11_Config = {
}


Write-Host "Installing with tags '$Tags'..."
$Tags = $Tags.Split(" ")

if (-not $Tags.Contains("no-std")) {
    powershell -ExecutionPolicy Bypass -NoProfile -NoLogo $Winget
    powershell -ExecutionPolicy Bypass -NoProfile -NoLogo $Core
}

if ($Tags.Contains("terminal")) {
    powershell -ExecutionPolicy Bypass -NoProfile -NoLogo $Terminal
}

if ($Tags.Contains("dotnet")) {
    powershell -ExecutionPolicy Bypass -NoProfile -NoLogo $Dotnet
}

if ($Tags.Contains("vs")) {
    powershell -ExecutionPolicy Bypass -NoProfile -NoLogo $Vs
    powershell -ExecutionPolicy Bypass -NoProfile -NoLogo $Vs_Config
}

if ($Tags.Contains("msvc22-win10")) {
    powershell -ExecutionPolicy Bypass -NoProfile -NoLogo $MSVC22Win10

    pwsh -ExecutionPolicy Bypass -NoProfile -NoLogo $MSVC22Win10_Config
    powershell -ExecutionPolicy Bypass -NoProfile -NoLogo $MSVC22Win10_Config
}

if (-not $Tags.Contains("no-std")) {
    powershell -ExecutionPolicy Bypass -NoProfile -NoLogo $Core_Config
}
