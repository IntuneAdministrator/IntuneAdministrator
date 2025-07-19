<#
.SYNOPSIS
    Checks for the presence of a specific compliance file.

.DESCRIPTION
    Verifies if the designated compliance file exists at the specified path.
    Outputs a message indicating the presence or absence of the file.
    Designed for Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Local execution or remote deployment via Intune/GPO. Requires filesystem read permissions.
#>

# Check if a specific file exists
$filePath = "C:\Company\Compliance\requiredfile.txt"

if (Test-Path $filePath) {
    Write-Output "Compliance file is present."
} else {
    Write-Output "Compliance file is missing."
}
