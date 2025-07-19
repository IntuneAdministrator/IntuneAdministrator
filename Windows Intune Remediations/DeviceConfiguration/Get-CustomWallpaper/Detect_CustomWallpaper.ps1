<#
.SYNOPSIS
    Checks if the corporate wallpaper is set for the current user.

.DESCRIPTION
    Retrieves the current wallpaper path from the registry.
    Compares it to the expected corporate wallpaper path.
    Outputs status and returns exit code 0 if set, otherwise 1.
    Designed for Windows 11 24H2 and newer.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Runs under the context of the user whose wallpaper is being checked.
#>

# Check if the corporate wallpaper is set
$wallpaperPath = "C:\Path\To\CorporateWallpaper.jpg"
$currentWallpaper = Get-ItemProperty -Path "HKCU:\Control Panel\Desktop\" -Name Wallpaper
if ($currentWallpaper.Wallpaper -ne $wallpaperPath) {
    Write-Output "Wallpaper needs to be set"
    exit 1
} else {
    Write-Output "Wallpaper is already set"
    exit 0
}
