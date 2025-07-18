<#
.SYNOPSIS
    Prompts user to open the 'Network & Internet' settings page with Yes/No options.

.DESCRIPTION
    Displays a Windows Forms message box asking the user whether to open the 
    'Network & Internet' settings page in Windows 11 24H2. Logs the user's choice 
    in the Application event log for auditing purposes.

.NOTES
    - Compatible with Windows 11 24H2 and later.
    - Requires permissions to write to the event log.
    - Uses native PowerShell cmdlets: Start-Process, Write-EventLog.
    - Uses Windows Forms for user interaction.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-18
#>

Add-Type -AssemblyName System.Windows.Forms

# Show a message box with Yes and No buttons
$userChoice = [System.Windows.Forms.MessageBox]::Show(
    "Do you want to open the Network & Internet settings page?",
    "Open Network Settings",
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Question
)

$source = "Network & Internet"
# Create event log source if it does not exist (admin required)
if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
    New-EventLog -LogName Application -Source $source
}

if ($userChoice -eq [System.Windows.Forms.DialogResult]::Yes) {
    # User chose Yes — open the settings page
    Start-Process "ms-settings:network-status"
    Write-EventLog -LogName Application -Source $source -EntryType Information -EventId 1000 -Message "User chose to open Network & Internet settings."
} else {
    # User chose No — just log and exit
    Write-EventLog -LogName Application -Source $source -EntryType Information -EventId 1001 -Message "User chose not to open Network & Internet settings."
}
