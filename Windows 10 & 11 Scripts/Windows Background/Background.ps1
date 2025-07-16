<#
.SYNOPSIS
    Prompts the user to open the Background personalization settings page on Windows 11 24H2.

.DESCRIPTION
    Displays a Windows Forms message box asking the user if they want to open the Background settings page.
    If the user agrees, the script opens the settings page and logs the action in the Application event log.
    It ensures the event log source exists, handles user cancellation gracefully, and captures errors if they occur.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-16

.NOTES
    Compatibility: Windows 11 24H2 and above  
    Requires     : Permissions to write to the event log and start processes
#>

# Load Windows Forms assembly for GUI dialogs
Add-Type -AssemblyName System.Windows.Forms

# Define the event log source name
$eventSource = "Background Settings"

try {
    # Show confirmation dialog with Yes and No buttons
    $dialogResult = [System.Windows.Forms.MessageBox]::Show(
        "Do you want to open the Background personalization settings page?",
        "Open Background Settings",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question
    )

    # Proceed only if user clicked 'Yes'
    if ($dialogResult -eq [System.Windows.Forms.DialogResult]::Yes) {

        # Ensure the event log source exists before logging
        if (-not [System.Diagnostics.EventLog]::SourceExists($eventSource)) {
            New-EventLog -LogName Application -Source $eventSource
        }

        # Open the Background personalization page
        Start-Process "ms-settings:personalization-background"

        # Log the action to Application event log for auditing
        Write-EventLog -LogName Application -Source $eventSource -EntryType Information -EventId 1000 -Message "User opened Background personalization settings page."

    } else {
        # User chose 'No' - optionally log or just exit silently
        Write-Host "User canceled opening Background settings."
    }
}
catch {
    # Handle unexpected errors gracefully and log them
    $errorMessage = "Error occurred: $($_.Exception.Message)"
    Write-Error $errorMessage

    if ([System.Diagnostics.EventLog]::SourceExists($eventSource)) {
        Write-EventLog -LogName Application -Source $eventSource -EntryType Error -EventId 1001 -Message $errorMessage
    }
}
