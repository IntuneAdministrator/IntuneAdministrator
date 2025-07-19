<#
.SYNOPSIS
    Checks if network protection is enabled on the device.

.DESCRIPTION
    This script checks the status of network protection in Windows Defender.
    If network protection is enabled (value `1`), the script outputs "Network protection is enabled" and exits with code 0.
    If network protection is disabled (value `0`), the script outputs "Network protection is disabled" and exits with code 1.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses the `Get-MpPreference` cmdlet to check the network protection status.
        - Ensure that Windows Defender is installed and the system is up-to-date.
#>

# Check if network protection is enabled
$networkProtection = Get-MpPreference | Select-Object -ExpandProperty EnableNetworkProtection

if ($networkProtection -eq 1) {
    Write-Output "Network protection is enabled."
    exit 0
} else {
    Write-Output "Network protection is disabled."
    exit 1
}
