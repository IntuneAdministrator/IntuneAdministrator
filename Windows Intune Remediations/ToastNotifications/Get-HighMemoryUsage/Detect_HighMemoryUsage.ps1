<#
.SYNOPSIS
This script checks the system's memory usage and triggers an alert if memory usage exceeds 80%.

.DESCRIPTION
This script retrieves the total memory usage of the system using the `Get-Counter` cmdlet, calculates the average memory usage, and checks if it exceeds 80%. If the memory usage is higher than the threshold, it will output a message indicating high memory usage and exit with a status code of `1`. If the memory usage is within normal limits, it will exit with a status code of `0`.

.AUTHOR
Name        : Allester Padovani
Title       : Senior IT Specialist
Script Ver. : 1.0
Date        : 2025-07-17

.NOTES
File Name      : HighMemoryUsageCheck.ps1
Version        : 1.0
Date Created   : 2025-07-19
Last Modified  : 2025-07-19
Change Log     : Initial version of the script to check memory usage.
#>

# Get the memory usage
$memoryUsage = Get-Counter '\Memory\% Committed Bytes In Use'
$averageMemoryUsage = [math]::round($memoryUsage.CounterSamples.CookedValue, 2)

# Check if memory usage is greater than 80%
if ($averageMemoryUsage -gt 80) {
    Write-Output "High memory usage"
    exit 1
} else {
    exit 0
}
