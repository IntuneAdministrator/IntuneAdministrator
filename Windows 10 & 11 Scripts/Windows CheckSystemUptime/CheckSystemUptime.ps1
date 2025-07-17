<#
.SYNOPSIS
    Displays the system uptime based on the last boot event in Windows event logs.

.DESCRIPTION
    Retrieves the most recent Event ID 6005 ("Event Log service started") from the System event log.
    Calculates the uptime duration by comparing the boot time with the current time.
    Formats and displays this uptime information in a Windows Forms message box.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above  
    Requires     : Access to event logs and Windows Forms assemblies
#>

Add-Type -AssemblyName System.Windows.Forms

# Get the most recent boot event (Event ID 6005 is "Event Log service started")
$bootEvent = Get-WinEvent -FilterHashtable @{
    LogName = 'System';
    ID = 6005
} -MaxEvents 1

# Extract timestamp
$bootTime = $bootEvent.TimeCreated
$currentTime = Get-Date
$uptime = $currentTime - $bootTime

# Format uptime
$uptimeFormatted = "{0} days, {1} hours, {2} minutes, {3} seconds" -f $uptime.Days, $uptime.Hours, $uptime.Minutes, $uptime.Seconds

# Create message
$message = @"
System Uptime Based on Event Logs:

Boot Time       : $bootTime
Current Time    : $currentTime
Uptime Duration : $uptimeFormatted
"@

# Show in message box
[System.Windows.Forms.MessageBox]::Show($message, "Uptime Status",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information)
