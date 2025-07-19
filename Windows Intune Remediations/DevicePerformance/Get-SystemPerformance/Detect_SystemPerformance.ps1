<#
.SYNOPSIS
    Detects high system resource usage based on predefined CPU, memory, and disk thresholds.

.DESCRIPTION
    Collects current CPU, memory, and disk utilization percentages using performance counters.
    Compares each metric against specified thresholds.
    If any metric exceeds its threshold, outputs details and exits with code 1.
    Otherwise, confirms system resource usage is within acceptable limits and exits with code 0.
    Designed for Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution. Requires permissions to access performance counters.
#>

# Define thresholds for high usage (percent)
$cpuThreshold = 80
$memoryThreshold = 80
$diskThreshold = 80

# Get current CPU usage (% processor time)
$cpuUsage = Get-Counter '\Processor(_Total)\% Processor Time' | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue

# Get current memory usage (% committed bytes in use)
$memoryUsage = (Get-Counter '\Memory\% Committed Bytes In Use').CounterSamples.CookedValue

# Get current disk usage (% disk time)
$diskUsage = Get-Counter '\LogicalDisk(_Total)\% Disk Time' | Select-Object -ExpandProperty CounterSamples | Select-Object -ExpandProperty CookedValue

# Check if any usage exceeds the threshold
if ($cpuUsage -gt $cpuThreshold -or $memoryUsage -gt $memoryThreshold -or $diskUsage -gt $diskThreshold) {
    Write-Output "High system resource usage detected: CPU=$([math]::Round($cpuUsage,2))%, Memory=$([math]::Round($memoryUsage,2))%, Disk=$([math]::Round($diskUsage,2))%"
    exit 1
} else {
    Write-Output "System resource usage is within acceptable limits: CPU=$([math]::Round($cpuUsage,2))%, Memory=$([math]::Round($memoryUsage,2))%, Disk=$([math]::Round($diskUsage,2))%"
    exit 0
}
