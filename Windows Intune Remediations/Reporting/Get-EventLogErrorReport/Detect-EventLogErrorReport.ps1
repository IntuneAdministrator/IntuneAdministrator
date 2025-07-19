<#
.SYNOPSIS
    Retrieves and exports error events from the system event log.

.DESCRIPTION
    This script checks the system event log for any error events (EntryType "Error") in the most recent 100 entries.
    It retrieves key event details such as TimeGenerated, Source, EventID, and Message, and exports the information to a CSV file for reporting.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses the `Get-EventLog` cmdlet to query the system event log for error entries.
        - The most recent 100 error events are processed and exported.
        - Administrative privileges may be required to access event logs.
#>

# Check for errors in the event log
$eventErrors = Get-EventLog -LogName System -EntryType Error -Newest 100 | Select-Object TimeGenerated, Source, EventID, Message

# Output the event log errors
# Write-Output $eventErrors

$csvPath = "C:\temp\EventLogErrorStatus.csv"

$eventErrors | Export-Csv -Path $csvPath -NoTypeInformation
Write-Output "Event Log Error status exported to $csvPath"

Exit 0
