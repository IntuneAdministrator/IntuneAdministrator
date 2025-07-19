<#
.SYNOPSIS
    Checks if a specific network drive is mapped.

.DESCRIPTION
    Defines the expected drive letter and network share path.
    Uses Get-PSDrive to verify if the drive is mapped to the correct network path.
    Outputs the mapping status and returns exit code 0 if correctly mapped, otherwise 1.
    Designed for Windows 11 24H2 and newer.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Runs under user context with necessary permissions.
#>

# Define the network drive letter and path
$driveLetter = "Z:"
$networkPath = "\\server\share"

# Check if the drive is mapped
$drive = Get-PSDrive -Name $driveLetter -ErrorAction SilentlyContinue

if ($null -eq $drive -or $drive.Root -ne $networkPath) {
    Write-Output "Network drive not mapped: $driveLetter"
    exit 1
} else {
    Write-Output "Network drive is mapped: $driveLetter"
    exit 0
}
