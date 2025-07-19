<#
.SYNOPSIS
    Checks if there is low disk space on the C: drive.

.DESCRIPTION
    This script checks the available free space on the C: drive. If the free space is less than 10 GB, 
    it will output "Low disk space" and exit with a status code of 1 to indicate an issue. 
    If the free space is 10 GB or more, the script will exit with a status code of 0.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script checks the free space on the C: drive and outputs a message if the space is low.
        - The low space threshold is set to 10 GB.
#>

# Get free space on C: drive
$freeSpace = (Get-PSDrive -Name C).Free
$freeSpaceGB = [math]::round($freeSpace / 1GB, 2)

# Check if free space is less than 10 GB
if ($freeSpaceGB -lt 10) {
    Write-Output "Low disk space"
    exit 1
} else {
    exit 0
}
