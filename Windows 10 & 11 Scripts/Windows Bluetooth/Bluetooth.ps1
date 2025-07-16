<#
.SYNOPSIS
    Prompts the user to open the Bluetooth settings page and logs the action if confirmed.

.DESCRIPTION
    Displays a Windows Forms confirmation dialog asking the user whether they want to open the Bluetooth settings page.
    If confirmed, it launches the Bluetooth settings and writes an informational entry to the Application event log.
    Handles event source creation and errors gracefully, displaying any issues to the user.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-16

.NOTES
    Compatibility: Windows 11 24H2 and above  
    Requires     : Permissions to write to the event log and start processes
#>

# Load the assembly required for GUI message boxes
Add-Type -AssemblyName System.Windows.Forms

# Prompt the user with a Yes/No confirmation dialog
$userChoice = [System.Windows.Forms.MessageBox]::Show(
    "Do you want to open the Bluetooth settings page?",
    "Confirmation",
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Question
)

if ($userChoice -eq [System.Windows.Forms.DialogResult]::Yes) {
    try {
        # Launch the Bluetooth settings page
        Start-Process "ms-settings:bluetooth"

        $eventSource = "Bluetooth Settings"

        # Check if the event source exists; if not, create it (requires admin privileges)
        if (-not [System.Diagnostics.EventLog]::SourceExists($eventSource)) {
            New-EventLog -LogName Application -Source $eventSource
        }

        # Write an informational event to the Application log
        Write-EventLog -LogName Application -Source $eventSource -EntryType Information -EventId 1000 -Message "Opened Bluetooth settings page."

    } catch {
        # Display error information in a message box
        [System.Windows.Forms.MessageBox]::Show(
            "An error occurred while trying to open Bluetooth settings:`n$($_.Exception.Message)",
            "Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
    }
} else {
    # User declined to open the settings page
    # Optionally log or silently exit
    # Write-Host "User canceled the operation."
}
