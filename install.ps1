$Winget = {
    $progressPreference = 'silentlyContinue'
    Invoke-WebRequest -Uri https://aka.ms/getwinget -OutFile Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
    Invoke-WebRequest -Uri https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx -OutFile Microsoft.VCLibs.x64.14.00.Desktop.appx
    Invoke-WebRequest -Uri https://github.com/microsoft/microsoft-ui-xaml/releases/download/v2.7.3/Microsoft.UI.Xaml.2.7.x64.appx -OutFile Microsoft.UI.Xaml.2.7.x64.appx
    Add-AppxPackage Microsoft.VCLibs.x64.14.00.Desktop.appx
    Add-AppxPackage Microsoft.UI.Xaml.2.7.x64.appx
    Add-AppxPackage Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle
}

$Core = {
    winget install --id Microsoft.Powershell --source winget
    winget install --id Microsoft.WindowsTerminal --source winget
    winget install --id Git.Git --source winget
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

Write-Host "Installing with tags '$Tags'..."
$Tags = $Tags.Split(" ")

powershell -ExecutionPolicy Bypass -NoProfile -NoLogo $Winget
powershell -ExecutionPolicy Bypass -NoProfile -NoLogo $Core

if ($Tags.Contains("dotnet")) {
    powershell -ExecutionPolicy Bypass -NoProfile -NoLogo $Dotnet
}

if ($Tags.Contains("vs")) {
    powershell -ExecutionPolicy Bypass -NoProfile -NoLogo $Vs
    powershell -ExecutionPolicy Bypass -NoProfile -NoLogo $Vs_Config
}

powershell -ExecutionPolicy Bypass -NoProfile -NoLogo $Core_Config
