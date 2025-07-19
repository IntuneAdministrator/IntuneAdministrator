<#
.SYNOPSIS
    Checks if tamper protection is enabled in Windows Defender.

.DESCRIPTION
    This script checks the status of tamper protection in Windows Defender.
    If tamper protection is enabled (value `$false`), the script outputs "Tamper protection is enabled" and exits with code 0.
    If tamper protection is disabled (value `$true`), the script outputs "Tamper protection is disabled" and exits with code 1.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses the `Get-MpPreference` cmdlet to check the tamper protection status.
        - Ensure that Windows Defender is installed and the system is up-to-date.
#>

# Check if tamper protection is enabled
$tamperProtection = Get-MpPreference | Select-Object -ExpandProperty DisableTamperProtection

if ($tamperProtection -eq $false) {
    Write-Output "Tamper protection is enabled."
    exit 0
} else {
    Write-Output "Tamper protection is disabled."
    exit 1
}
