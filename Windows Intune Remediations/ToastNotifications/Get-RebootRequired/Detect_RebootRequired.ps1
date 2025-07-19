<#
.SYNOPSIS
    Checks if the system has been running for more than 7 days and triggers a reboot notification.

.DESCRIPTION
    This script calculates the system uptime and checks if the system has been running for more than 7 days.
    If the system uptime exceeds 7 days, the script outputs "Reboot required" and exits with code 1 to indicate that a reboot is necessary.
    If the uptime is less than 7 days, the script exits with code 0.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses `Get-CimInstance` to retrieve the LastBootUpTime from the `Win32_OperatingSystem` class.
        - The system uptime is calculated by subtracting the LastBootUpTime from the current date.
        - The script exits with code 1 if a reboot is required, otherwise exits with code 0.
#>

# Get system uptime
$uptime = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
$daysUptime = (Get-Date) - $uptime

# Check if the system has been up for 7 days or more
if ($daysUptime.Days -ge 7) {
    Write-Output "Reboot required"
    exit 1
} else {
    exit 0
}
