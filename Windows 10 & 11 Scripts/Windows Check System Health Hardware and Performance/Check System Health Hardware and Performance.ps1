<#
.SYNOPSIS
    Performs a system health check by logging CPU, memory, and disk usage to a file.

.DESCRIPTION
    Collects current CPU load percentage, memory usage, and disk space usage for all local drives.
    Logs this information with timestamps into a persistent log file for monitoring and auditing purposes.
    After completion, notifies the user with a GUI message box to review the log file for detailed results.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above  
    Requires     : Permissions to access WMI and display Windows Forms message boxes
    Log file location: C:\ProgramData\OzarkTechTeam\SystemHealth_log.txt
#>

# Begin script to perform and log system health check

# Step 1: Define the path to the log file
# This log file will store all health check data for future reference
$logFile = "C:\ProgramData\OzarkTechTeam\SystemHealth_log.txt"

# Step 2: Log the start time of the health check to the log file
# This is helpful for tracking when the health check was performed
"Starting system health check at $(Get-Date)" | Out-File -FilePath $logFile -Append

# Step 3: Check CPU usage
# We use the Win32_Processor class to get CPU load percentage
# This will help us monitor how much CPU is being used at the moment
$cpuUsage = Get-WmiObject -Class Win32_Processor | Select-Object LoadPercentage

# Log the CPU usage to the log file with the current date and time
"CPU Usage: $($cpuUsage.LoadPercentage)% at $(Get-Date)" | Out-File -FilePath $logFile -Append

# Step 4: Check Memory usage
# The Win32_OperatingSystem class provides memory data, including free and total memory
$memory = Get-WmiObject -Class Win32_OperatingSystem

# Calculate memory usage as a percentage
# Formula: (TotalMemory - FreeMemory) / TotalMemory * 100
# The result is rounded to two decimal places
$memoryUsage = [math]::round(($memory.TotalVisibleMemorySize - $memory.FreePhysicalMemory) / $memory.TotalVisibleMemorySize * 100, 2)

# Log the memory usage to the log file with the current date and time
"Memory Usage: $memoryUsage% at $(Get-Date)" | Out-File -FilePath $logFile -Append

# Step 5: Check Disk usage
# We use Win32_LogicalDisk class to get disk space info
# We filter to only include local hard drives (DriveType=3)
$disk = Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"

# Loop through each disk and calculate disk usage
foreach ($d in $disk) {
    # Calculate disk usage as a percentage
    # Formula: (DiskSize - FreeSpace) / DiskSize * 100
    $diskUsage = [math]::round(($d.Size - $d.FreeSpace) / $d.Size * 100, 2)
    
    # Log the disk usage to the log file with the current date and time
    "Disk $($d.DeviceID): $diskUsage% used at $(Get-Date)" | Out-File -FilePath $logFile -Append
}

# Step 6: Show message box to the user indicating the health check is complete
# The message box will prompt the user to check the log file for detailed results
# We use the System.Windows.Forms assembly to display the message box
Add-Type -AssemblyName "System.Windows.Forms"

# Display the message box with a confirmation message
[System.Windows.Forms.MessageBox]::Show(
    'System health check is complete. Please review the log for details.',
    'System Health Check Complete',
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)

# Step 7: Exit the script cleanly after completion
# Exiting ensures that the script stops executing and resources are freed
exit
