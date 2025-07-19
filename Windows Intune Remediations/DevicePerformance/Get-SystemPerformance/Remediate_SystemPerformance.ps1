<#
.SYNOPSIS
    Performs system performance optimizations including cleanup and defragmentation.

.DESCRIPTION
    Deletes all files in the user’s Temp folder to free up space.
    Clears the Windows Update cache to remove downloaded update files.
    Runs Disk Cleanup with a predefined profile.
    Checks if the system drive is an HDD and defragments it (skips SSDs).
    Designed for Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges. Defragmentation is skipped for SSDs.
#>

# Clear temporary files
$TempFolder = "$env:Temp"
Remove-Item "$TempFolder\*" -Recurse -Force -ErrorAction SilentlyContinue

# Clear Windows Update cache
$WindowsUpdateCache = "C:\Windows\SoftwareDistribution\Download"
Remove-Item "$WindowsUpdateCache\*" -Recurse -Force -ErrorAction SilentlyContinue

# Optimize disk space using Disk Cleanup
Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -NoNewWindow -Wait

# Check disk type and defragment if it is an HDD (skip SSDs)
$diskType = Get-PhysicalDisk | Where-Object MediaType -eq "HDD"
if ($diskType) {
    Optimize-Volume -DriveLetter C -Defrag -Verbose
}

Write-Output "System performance optimization tasks completed."
