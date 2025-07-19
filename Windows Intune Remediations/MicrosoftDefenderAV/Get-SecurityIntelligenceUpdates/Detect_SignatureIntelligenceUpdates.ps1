<#
.SYNOPSIS
    Checks if security intelligence updates are up-to-date in Windows Defender.

.DESCRIPTION
    This script checks the last update timestamp for the antivirus signature.
    If the signature hasn't been updated in the last 24 hours, the script considers the updates outdated and exits with code 1.
    If the signature is updated within the last 24 hours, the script considers the updates up-to-date and exits with code 0.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses the `Get-MpComputerStatus` cmdlet to check the last antivirus signature update time.
        - Ensure that Windows Defender is installed and the system is up-to-date.
#>

# Check if security intelligence updates are up-to-date
$lastUpdate = Get-MpComputerStatus | Select-Object -ExpandProperty AntivirusSignatureLastUpdated

if ($lastUpdate -lt (Get-Date).AddDays(-1)) {
    Write-Output "Security intelligence updates are outdated."
    exit 1
} else {
    Write-Output "Security intelligence updates are up-to-date."
    exit 0
}
