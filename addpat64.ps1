[CmdletBinding(DefaultParametersetName="setgh")]                  
Param(
    [parameter(ParameterSetName="setgh", Mandatory=$true)]
    [switch]
    $Gh,

    [parameter(ParameterSetName="setaz", Mandatory=$true)]
    [switch]
    $Az 
)

$IncludePath = "$HOME\.gitpat64"

# Ensure include path in .gitconfig file
git config --global include.path $IncludePath

# Prompt for URL
$URL = Read-Host -Prompt "URL"

# Prompt for PAT (Personal Access Token) 
$SecurePAT = Read-Host -Prompt "PAT" -AsSecureString

# Convert SecureString to Base64 encoded string
$PAT64 = $SecurePAT | ConvertFrom-SecureString -AsPlainText

if ($Gh) {
    $PAT64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($PAT64))
}
elseif ($Az) {
    $PAT64 = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":" + $PAT64))
}

# Write to ~/.gitpat64
Add-Content -Path $IncludePath -Value "`n[http `"$URL`"]`n    extraHeader = `"Authorization: Basic $PAT64`""
