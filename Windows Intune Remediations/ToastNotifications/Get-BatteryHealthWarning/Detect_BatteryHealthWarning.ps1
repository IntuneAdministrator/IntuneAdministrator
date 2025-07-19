<#
.SYNOPSIS
    Checks the battery health and outputs a warning if the battery charge is below 25%.

.DESCRIPTION
    This script queries the battery status using WMI and checks the estimated remaining charge.
    If the battery charge is below 25%, the script outputs a warning message and exits with code 1.
    If the charge is 25% or above, the script exits with code 0.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses `Get-WmiObject` to query battery information from the `Win32_Battery` class.
        - If the battery charge is below 25%, a warning is shown and the script exits with code 1.
        - If the battery charge is 25% or above, the script exits with code 0.
#>

# Get battery status
$batteryStatus = Get-WmiObject -Query "Select * from Win32_Battery"

# Check if battery charge is below 25%
if ($batteryStatus.EstimatedChargeRemaining -lt 25) {
    Write-Output "Battery health warning"
    exit 1
} else {
    exit 0
}
