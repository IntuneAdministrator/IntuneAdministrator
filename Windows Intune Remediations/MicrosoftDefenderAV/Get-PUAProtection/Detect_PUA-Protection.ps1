<#
.SYNOPSIS
    Checks if PUA (Potentially Unwanted Application) protection is enabled on the device.

.DESCRIPTION
    This script checks the current status of PUA protection in Windows Defender.
    If PUA protection is enabled (value `1`), the script considers the device compliant and exits with code 0.
    If PUA protection is disabled (value `0`), the script considers the device non-compliant and exits with code 1.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses the `Get-MpPreference` cmdlet to check the PUA protection status.
        - Ensure that Windows Defender is installed and the system is up-to-date.
#>

if((Get-MpPreference).PUAProtection -eq 1) {
    Write-Output "Device Compliant"
    exit 0
} else {
    Write-Output "Device Non-Compliant"
    exit 1
}
