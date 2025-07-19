<#
.SYNOPSIS
    Retrieves and calculates the system uptime since the last boot.

.DESCRIPTION
    This script checks the system's last boot time using the `Win32_OperatingSystem` CIM class, then calculates
    the system's uptime based on the current date and time. The result is outputted in a human-readable format 
    that shows the number of days, hours, and minutes the system has been up.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - This script retrieves system uptime by calculating the difference between the current date and the system's last boot time.
        - The output is shown in days, hours, and minutes for easier interpretation.
#>

# Get the last boot time
$lastBootTime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime

# Calculate the uptime
$uptime = (Get-Date) - $lastBootTime

# Output the uptime
Write-Output "The system has been up for: $($uptime.Days) days, $($uptime.Hours) hours, $($uptime.Minutes) minutes."

Exit 0
