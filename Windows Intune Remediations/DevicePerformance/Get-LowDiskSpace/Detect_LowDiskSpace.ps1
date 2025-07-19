<#
.SYNOPSIS
    Detects if the system drive has low free disk space based on a specified threshold.

.DESCRIPTION
    Retrieves the free space on the C: drive in gigabytes.
    Compares the free space against a defined threshold (default 10 GB).
    Outputs the current free space and returns exit code 1 if below threshold, otherwise 0.
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

# Define the threshold for low disk space in GB
$thresholdGB = 10

# Get the free space on the system drive in GB (rounded to 2 decimals)
$freeSpaceGB = [math]::Round((Get-PSDrive -Name C).Free / 1GB, 2)

if ($freeSpaceGB -lt $thresholdGB) {
    Write-Output "Low disk space detected: $freeSpaceGB GB free"
    exit 1
} else {
    Write-Output "Sufficient disk space: $freeSpaceGB GB free"
    exit 0
}
