<#
.SYNOPSIS
    Checks if the system drive has sufficient free disk space.

.DESCRIPTION
    Retrieves the free space on the C: drive.
    Compares the free space against a 10 GB threshold.
    Outputs status and returns exit code 1 if free space is below 10 GB, otherwise 0.
    Designed for Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution.
#>

# Check for low disk space
$freeSpace = (Get-PSDrive -Name C).Free
if ($freeSpace -lt 10GB) {
    Write-Output "Low disk space"
    exit 1
} else {
    Write-Output "Sufficient disk space"
    exit 0
}
