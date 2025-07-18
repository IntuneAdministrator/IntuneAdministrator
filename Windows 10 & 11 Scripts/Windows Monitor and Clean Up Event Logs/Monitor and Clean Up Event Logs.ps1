<#
.SYNOPSIS
    Clears all non-critical Windows event logs and logs the cleanup process to a file.

.DESCRIPTION
    This script enumerates all available Windows event logs except the critical 'System', 'Application', 
    and 'Security' logs. It clears these non-critical logs to free disk space and writes an audit trail 
    to a log file for troubleshooting and auditing purposes. After completion, it shows a user-friendly 
    message box notification.

.NOTES
    - Requires running with administrator privileges.
    - Compatible with Windows 11 24H2 and later.
    - Uses native PowerShell cmdlets: Get-WinEvent and Clear-WinEvent.
    - Logs cleanup details to C:\ProgramData\OzarkTechTeam\EventLogs_Cleanup_log.txt.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-18
#>

# Step 1: Define log file path to store event log cleanup process details
# We will store the log of the cleanup process in a specific file for auditing and troubleshooting.
$logFile = "C:\ProgramData\OzarkTechTeam\EventLogs_Cleanup_log.txt"

# Step 2: Log the start of the event log cleanup process with the current timestamp
# This provides an audit trail of when the cleanup process was initiated.
"Starting event logs cleanup at $(Get-Date)" | Out-File -FilePath $logFile -Append

# Step 3: Retrieve a list of all event logs except for 'System', 'Application', and 'Security'
# We want to clean up only the non-critical event logs to free up disk space.
$eventLogs = Get-WinEvent -ListLog * | Where-Object {
    # Filter out 'System', 'Application', and 'Security' logs which are critical for system operations
    $_.LogDisplayName -notin @("System", "Application", "Security")
}

# Step 4: Loop through each event log and clear it if it's not one of the critical logs
foreach ($log in $eventLogs) {
    # Output the log name being cleared for user feedback and auditing
    Write-Host "Clearing log: $($log.LogDisplayName)"
    
    # Clear the log using the Clear-WinEvent cmdlet
    # This command will remove the events in the specified log to free up space
    Clear-WinEvent -LogName $log.LogDisplayName
    
    # Log the clearing action to the event log cleanup log file with the current timestamp
    "$($log.LogDisplayName) cleared at $(Get-Date)" | Out-File -FilePath $logFile -Append
}

# Step 5: Show a message box to notify the user that the cleanup is complete
# This provides a clear, user-friendly notification that the event logs have been cleared.
Add-Type -AssemblyName "System.Windows.Forms"
[System.Windows.Forms.MessageBox]::Show(
    'Event logs have been cleared. Non-critical logs were deleted to free up space.',
    'Event Logs Cleaned',  # Title of the message box
    [System.Windows.Forms.MessageBoxButtons]::OK,  # Button options
    [System.Windows.Forms.MessageBoxIcon]::Information  # Icon to show information
)

# Step 6: Exit the script
# The script ends after showing the message box, ensuring a clean termination of the process.
exit
