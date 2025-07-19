<#
.SYNOPSIS
    Sets the corporate wallpaper for the current user.

.DESCRIPTION
    Updates the Windows registry to set the desktop wallpaper path for the current user.
    Refreshes the user system parameters to apply the wallpaper change immediately.
    Designed for Windows 11 24H2 and newer.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Runs under the context of the user whose wallpaper is being changed.
#>

# Set the corporate wallpaper
$wallpaperPath = "C:\Path\To\CorporateWallpaper.jpg"
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\" -Name Wallpaper -Value $wallpaperPath
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
Write-Output "Wallpaper set"
