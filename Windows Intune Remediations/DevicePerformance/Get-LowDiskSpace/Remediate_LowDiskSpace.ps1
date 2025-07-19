<#
.SYNOPSIS
    Frees up disk space by cleaning temporary files, Windows Update cache, and Recycle Bin.

.DESCRIPTION
    Deletes all files and folders within the user's Temp directory.
    Clears the Windows Update download cache.
    Empties the Recycle Bin.
    Designed to recover disk space on Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges. Run with caution as files are permanently deleted.
#>

# Clear temporary files
$TempFolder = "$env:Temp"
Remove-Item "$TempFolder\*" -Recurse -Force -ErrorAction SilentlyContinue

# Clear Windows Update cache
$WindowsUpdateCache = "C:\Windows\SoftwareDistribution\Download"
Remove-Item "$WindowsUpdateCache\*" -Recurse -Force -ErrorAction SilentlyContinue

# Clear Recycle Bin
Clear-RecycleBin -Force -ErrorAction SilentlyContinue

Write-Output "Disk space cleanup completed."
