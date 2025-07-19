<#
.SYNOPSIS
    Prompts the user to open the Sound settings page and logs the action.

.DESCRIPTION
    Displays a Windows Forms Yes/No message box asking the user whether to open the Sound settings.
    Opens the Sound settings page if the user agrees and logs the event to the Application event log.
    Logs user cancellation or any errors encountered during the process.
    Handles event log source creation and error reporting gracefully.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-16
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2 and above  
    Requires     : Permissions to write to the event log and start processes
#>

# Load Windows Forms assembly to enable MessageBox usage
Add-Type -AssemblyName System.Windows.Forms

# Define the event log source and log name
$eventSource = "SoundSettingsLauncher"
$logName = "Application"

# Ensure the event source exists (create it if not present)
if (-not [System.Diagnostics.EventLog]::SourceExists($eventSource)) {
    try {
        New-EventLog -LogName $logName -Source $eventSource
    } catch {
        Write-Warning "Failed to create event log source: $_"
    }
}

# Prompt user to open Sound settings
$userChoice = [System.Windows.Forms.MessageBox]::Show(
    "Would you like to open the Sound settings page?",
    "Open Sound Settings",
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Question
)

try {
    if ($userChoice -eq [System.Windows.Forms.DialogResult]::Yes) {
        # Open Sound settings page
        Start-Process "ms-settings:sound"

        # Log success event
        Write-EventLog -LogName $logName -Source $eventSource -EventId 2001 -EntryType Information -Message "User opened Sound settings via script."
    } else {
        # Log cancellation event
        Write-EventLog -LogName $logName -Source $eventSource -EventId 2002 -EntryType Information -Message "User declined to open Sound settings."
    }
} catch {
    # Log any errors
    Write-EventLog -LogName $logName -Source $eventSource -EventId 2003 -EntryType Error -Message "Error opening Sound settings: $_"

    # Inform user about error
    [System.Windows.Forms.MessageBox]::Show(
        "An error occurred while trying to open Sound settings.`nDetails: $_",
        "Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
}

exit
