<#
.SYNOPSIS
    Detects whether the `SoftwareDistribution.old` folder exists in the system directory.

.DESCRIPTION
    This script checks if the `SoftwareDistribution.old` folder exists in the `C:\Windows` directory. 
    If the folder exists, the script outputs "Folder Exist" and exits with code 1. 
    If the folder does not exist, it outputs "Folder Doesn't Exist" and exits with code 0.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - This script helps verify whether a folder (in this case, `SoftwareDistribution.old`) exists.
        - The script exits with code `1` if the folder exists and `0` if it doesn't.
        - Administrative privileges may be required to access system folders like `C:\Windows`.
#>

# Detect if the SoftwareDistribution.old folder exists
if (Test-Path C:\Windows\SoftwareDistribution.old) {
    Write-Output "Folder Exist"
    exit 1  # Folder exists, exit with code 1
} else {
    Write-Output "Folder Doesn't Exist"
    exit 0  # Folder does not exist, exit with code 0
}
