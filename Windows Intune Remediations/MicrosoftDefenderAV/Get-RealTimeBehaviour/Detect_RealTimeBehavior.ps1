<#
.SYNOPSIS
    Checks if behavior monitoring is enabled on the device.

.DESCRIPTION
    This script checks the status of Windows Defender's behavior monitoring.
    If behavior monitoring is enabled, the script considers the device compliant and exits with code 0.
    If behavior monitoring is disabled, the script considers the device non-compliant and exits with code 1.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses the `Get-MpComputerStatus` cmdlet to check the behavior monitoring status.
        - Ensure that Windows Defender is installed and the system is up-to-date.
#>

if((Get-MpComputerStatus).BehaviorMonitorEnabled  -eq "True") {
    Write-Output "Device Compliant"
    exit 0
} else {
    Write-Output "Device Non-Compliant"
    exit 1
}
