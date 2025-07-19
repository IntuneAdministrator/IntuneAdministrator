<#
.SYNOPSIS
    Maps a network drive to a specified drive letter.

.DESCRIPTION
    Defines the network share path and drive letter.
    Uses New-PSDrive to map the network share as a persistent drive.
    Suitable for Windows 11 24H2 and later environments.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires network access and appropriate permissions. Runs under user context.
#>

# Define the network drive letter and path
$driveLetter = "Z:"
$networkPath = "\\server\share"

# Map the network drive
New-PSDrive -Name $driveLetter -PSProvider FileSystem -Root $networkPath -Persist

Write-Output "Network drive has been mapped: $driveLetter"
