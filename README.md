# win-core

## About

Standard component install scripts for Windows OS \
Standard components to be installed:
- WinGet
- PowerShell 7
- git

 What optional component will be installed is controlled by tags (space separated). \
 Available tags are:
 - no-std: Skip installation of standard components
 - terminal: Install Windows Terminal
 - dotnet: Install .NET 6 SDK
 - vs: Install Visual Studio 2022 Pro with desktop development workload

## Usage

1. Copy the command below, paste it in a PowerShell (admin mode) shell.
2. Edit tags before pressing enter if needed.
3. After installation is complete, your email address will be asked to set it in `.gitconfig` file.

```powershell
"https://github.com/redcoreit/win-core/raw/master/install.ps1" | % { $Tags = "terminal"; (New-Object Net.WebClient).DownloadString($_) | iex }
```

