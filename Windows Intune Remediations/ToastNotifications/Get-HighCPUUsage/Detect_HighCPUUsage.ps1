<#
.SYNOPSIS
This script checks the system's CPU usage and triggers an alert if the CPU usage exceeds 80%.

.DESCRIPTION
This script retrieves the total CPU usage of the system using the `Get-Counter` cmdlet, calculates the average usage, and checks if it exceeds 80%. If the CPU usage is higher than the threshold, it will output a message indicating high CPU usage and exit with a status code of `1`. If the CPU usage is within normal limits, it will exit with a status code of `0`.

.AUTHOR
Name        : Allester Padovani
Title       : Senior IT Specialist
Script Ver. : 1.0
Date        : 2025-07-17

.NOTES
File Name      : HighCpuUsageCheck.ps1
Version        : 1.0
Date Created   : 2025-07-19
Last Modified  : 2025-07-19
Change Log     : Initial version of the script to check CPU usage.
#>

# Get the total CPU usage
$cpuUsage = Get-Counter '\Processor(_Total)\% Processor Time'
$averageCpuUsage = [math]::round($cpuUsage.CounterSamples.CookedValue, 2)

# Check if CPU usage is greater than 80%
if ($averageCpuUsage -gt 80) {
    Write-Output "High CPU usage"
    exit 1
} else {
    exit 0
}
