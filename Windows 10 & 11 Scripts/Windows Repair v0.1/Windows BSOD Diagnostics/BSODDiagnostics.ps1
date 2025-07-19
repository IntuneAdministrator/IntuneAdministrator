<#
.SYNOPSIS
    Scans system event logs for the most recent Blue Screen (BSOD) error and displays the report.

.DESCRIPTION
    Retrieves the latest Event ID 1001 from the WER-SystemErrorReporting provider, which indicates a BugCheck (BSOD).
    If found, formats and presents the crash time and details in a Windows Forms message box along with recommended actions.
    If no BSOD events are found, notifies the user. Errors during execution are caught and reported via GUI.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-16
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2 and above  
    Requires     : Access to the System event log and Windows Forms support
#>

# Load the Windows Forms assembly to allow GUI message boxes
Add-Type -AssemblyName System.Windows.Forms

# Define a reusable function to display message boxes with customizable title and text
function Show-MessageBox {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Text,

        [string]$Title = "Blue Screen Error Report"
    )

    # Display a message box with OK button and Information icon
    [System.Windows.Forms.MessageBox]::Show(
        $Text,
        $Title,
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    ) | Out-Null
}

try {
    # Query the System event log for the most recent BSOD event
    # Event ID 1001 from the WER-SystemErrorReporting provider indicates a BugCheck (BSOD)
    $bsodEvent = Get-WinEvent -FilterHashtable @{
        LogName      = 'System'
        ProviderName = 'Microsoft-Windows-WER-SystemErrorReporting'
        Id           = 1001
    } -MaxEvents 1 -ErrorAction SilentlyContinue

    # Check if an event was retrieved successfully
    if ($null -ne $bsodEvent) {
        # Extract the event creation time and message details
        $eventTime = $bsodEvent.TimeCreated.ToLocalTime()
        $eventMessage = $bsodEvent.Message.Trim()

        # Prepare a clean, formatted multi-line report string
        $report = @"
Last Blue Screen Error Detected:

Time: $eventTime

Details:
$eventMessage

Recommended Actions:
- Review the STOP code shown in the details
- Update device drivers and Windows patches
- Run memory diagnostics (e.g., Windows Memory Diagnostic)
- Check disk integrity (e.g., chkdsk)
- Review Windows Update history for recent changes
"@

        # Show the formatted BSOD report to the user
        Show-MessageBox -Text $report -Title "Last BSOD Report"
    }
    else {
        # Inform the user that no BSOD events were found in the logs
        Show-MessageBox -Text "No Blue Screen errors have been detected in the system logs." -Title "BSOD Status"
    }
}
catch {
    # Handle unexpected errors gracefully by showing the error message
    $errorMessage = $_.Exception.Message
    Show-MessageBox -Text "An error occurred while scanning for BSOD events:`n$errorMessage" -Title "Error"
}
