<#
.SYNOPSIS
    Checks the status of Microsoft Defender Antivirus on the system.

.DESCRIPTION
    This script checks if Microsoft Defender Antivirus is enabled or disabled.
    If the antivirus is disabled, it will output a message and exit with code 1.
    If the antivirus is enabled, it will exit with code 0.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11 with Microsoft Defender Antivirus
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script checks the `AntivirusEnabled` property of the `Get-MpComputerStatus` cmdlet to determine if the antivirus is enabled.
#>

# Check the antivirus status
$antivirusStatus = Get-MpComputerStatus
if ($antivirusStatus.AntivirusEnabled -eq $false) {
    Write-Output "Antivirus is disabled"
    exit 1
} else {
    exit 0
}
