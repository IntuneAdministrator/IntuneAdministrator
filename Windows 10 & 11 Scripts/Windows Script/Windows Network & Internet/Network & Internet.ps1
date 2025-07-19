<#
.SYNOPSIS
    Prompts user to open the 'Network & Internet' settings page with Yes/No options, logging the response.

.DESCRIPTION
    Displays a Windows Forms message box asking the user whether to open the 
    'Network & Internet' settings page in Windows 11 24H2. Logs the user's choice 
    in the Application event log for auditing purposes.
    Ensures the event log source exists, creating it if necessary.

.NOTES
    - Compatible with Windows 11 24H2 and later.
    - Requires administrator privileges to create event log source.
    - Requires permissions to write to the event log.
    - Uses native PowerShell cmdlets: Start-Process, Write-EventLog.
    - Uses Windows Forms for user interaction.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-17
    Version     : 1.0
#>

Add-Type -AssemblyName System.Windows.Forms

# Prompt message
$message = "Do you want to open the Network & Internet settings page?"
$title = "Open Network Settings"

# Show Yes/No message box
$userChoice = [System.Windows.Forms.MessageBox]::Show(
    $message,
    $title,
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Question
)

$source = "Network & Internet"
$logName = "Application"

# Check if event source exists, create if it doesn't
if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
    try {
        New-EventLog -LogName $logName -Source $source
        Write-Host "Event log source '$source' created successfully."
        Write-Host "Please restart PowerShell and run this script again."
        exit 1
    }
    catch {
        Write-Warning "Failed to create event log source '$source'. Please run this script as Administrator."
        exit 1
    }
}

# Try to write event log entry and open settings if user chose Yes
try {
    if ($userChoice -eq [System.Windows.Forms.DialogResult]::Yes) {
        Start-Process "ms-settings:network-status"
        Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message "User chose to open Network & Internet settings."
    }
    else {
        Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1001 -Message "User chose NOT to open Network & Internet settings."
    }
}
catch {
    Write-Warning "Failed to write to the event log: $_"
}
