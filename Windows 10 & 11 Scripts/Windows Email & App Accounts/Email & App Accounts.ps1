<#
.SYNOPSIS
    Prompts the user to open the 'Email & App Accounts' settings page on Windows 11 24H2.

.DESCRIPTION
    Displays a Yes/No message box asking the user if they want to open the 'Email & App Accounts' settings.
    If the user clicks Yes, the script opens the settings page and logs the action in the Application event log.
    Automatically creates the event source if it does not exist.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.1
    Date        : 2025-07-18

.NOTES
    Requires Administrator privileges to create event source.
    Uses Windows Forms for the message box UI.
#>

Add-Type -AssemblyName System.Windows.Forms

$source = "Email & App Accounts"
$logName = "Application"

# Check if the event source exists; if not, create it (requires admin rights)
if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
    try {
        [System.Diagnostics.EventLog]::CreateEventSource($source, $logName)
        Write-Host "Created event source: $source"
        # Event source creation requires time to register properly; a short delay helps avoid errors immediately after.
        Start-Sleep -Seconds 2
    }
    catch {
        Write-Warning "Failed to create event source: $_. Exception: $($_.Exception.Message)"
    }
}

$result = [System.Windows.Forms.MessageBox]::Show(
    "Do you want to open the 'Email & App Accounts' settings page?",
    "Open Settings",
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Question
)

if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
    Start-Process "ms-settings:emailandaccounts"

    # Write to event log only if the source exists
    if ([System.Diagnostics.EventLog]::SourceExists($source)) {
        Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message "Opened Email & App Accounts settings."
    } else {
        Write-Warning "Event source '$source' does not exist. Skipping event log write."
    }
}
