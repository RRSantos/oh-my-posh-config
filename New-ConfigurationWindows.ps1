#Requires -RunAsAdministrator

if ($Host.Version.Major -lt 7) {
    Write-Error "This script requires PowerShell 7 or higher."
    return
}

Write-Host "Installing OhMyPosh..."
winget install JanDeDobbeleer.OhMyPosh --silent --accept-package-agreements --accept-source-agreements
Write-Host "Installing PowerShellGet..."
pwsh -Command "Install-Module -Name PowerShellGet -Force" -RunAsAdministrator
Write-Host "Installing Terminal-Icons..."
Install-Module -Name Terminal-Icons  -Force
Write-Host "Installing PSReadLine..."
Install-Module -Name PSReadLine -AllowPrerelease -Repository PSGallery -Force

$baseConfigPath='C:\Ramos'
if (!(Test-Path -Path $baseConfigPath )) { New-Item -ItemType Directory -Path $baseConfigPath }
$ohMyPoshConfigPath="$baseConfigPath\oh-my-posh"
if (!(Test-Path -Path $ohMyPoshConfigPath )) { New-Item -ItemType Directory -Path $ohMyPoshConfigPath }

Copy-Item -Path ".\config\ramos-oh-my-posh-config.json" -Destination "$ohMyPoshConfigPath\ramos-oh-my-posh-config.json"
$profileContent = @"
oh-my-posh --init --shell pwsh --config $ohMyPoshConfigPath\ramos-oh-my-posh-config.json | Invoke-Expression

Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -EditMode Windows
Set-PSReadLineOption -PredictionViewStyle ListView

Import-Module -Name Terminal-Icons
"@

if(!(Test-Path "$Profile")) {
    New-Item -ItemType File "$Profile"
}

Add-Content -Path "$Profile" -Value "$profileContent"

$warningMessage=@"
Configuration successfuly completed.
Make sure to:
   1. Install Caskaydia Cove Fonts from https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/CascadiaCode.zip;
   2. Configure your Terminal to use 'Caskaydia Cove Nerd Font';
"@
Write-Warning $warningMessage