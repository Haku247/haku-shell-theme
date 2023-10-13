# Get the path to the user's profile
$profilePath = $PROFILE

# Path to the directory containing this script
$scriptDir = $PSScriptRoot

# The PowerShell theme
$themeContent = Get-Content "$scriptDir\haku-shell-theme.ps1"

# Check if the profile file exists
if (!(Test-Path -Path $profilePath)) {
    # The profile file does not exist, create it
    New-Item -ItemType File -Path $profilePath -Force
}

# Add the theme to the profile file
Add-Content -Path $profilePath -Value $themeContent

# Load the new profile
. $profilePath

Write-Host "The haku-shell-theme has been installed!"
