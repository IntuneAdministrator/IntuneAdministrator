<#
.SYNOPSIS
    Checks if cloud-delivered protection is enabled in Windows Defender.

.DESCRIPTION
    This script checks the status of cloud-delivered protection in Windows Defender by inspecting the `MAPSReporting` setting.
    If cloud-delivered protection is enabled (i.e., `MAPSReporting` is set to a value other than `0`), the script outputs "Cloud-delivered protection is enabled" and exits with code 0.
    If cloud-delivered protection is disabled (i.e., `MAPSReporting` is `0`), the script outputs "Cloud-delivered protection is disabled" and exits with code 1.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses the `Get-MpPreference` cmdlet to check the `MAPSReporting` setting.
        - Ensure that Windows Defender is installed and up-to-date on the system.
#>

# Check if cloud-delivered protection is enabled
$cloudProtection = Get-MpPreference | Select-Object -ExpandProperty MAPSReporting

if ($cloudProtection -ne 0) {
    Write-Output "Cloud-delivered protection is enabled."
    exit 0
} else {
    Write-Output "Cloud-delivered protection is disabled."
    exit 1
}
