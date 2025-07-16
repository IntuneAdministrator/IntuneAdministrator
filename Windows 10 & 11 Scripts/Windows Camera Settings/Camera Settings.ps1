<#
.SYNOPSIS
    Prompts the user to open the Camera settings page and logs the action if confirmed.

.DESCRIPTION
    Displays a Windows Forms confirmation dialog asking the user whether to open the Camera settings page.
    If confirmed, it launches the settings page and writes an informational entry to the Application event log.
    Handles the creation of the event source if needed and displays errors using a message box.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-16

.NOTES
    Compatibility: Windows 11 24H2 and above  
    Requires     : Permissions to write to the event log and start processes
#>

# Load the necessary assembly for GUI message boxes
Add-Type -AssemblyName System.Windows.Forms

# Show a confirmation message box asking the user to proceed
$result = [System.Windows.Forms.MessageBox]::Show(
    "Do you want to open the Camera Settings page?",
    "Confirmation",
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Question
)

# If the user clicked 'Yes', proceed to open settings and log
if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
    try {
        # Start the Camera Settings page
        Start-Process "ms-settings:camera"

        # Define the event log source
        $source = "Camera Settings"

        # Check if the event log source exists, create it if not (requires admin privileges)
        if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
            New-EventLog -LogName Application -Source $source
        }

        # Write an informational event log entry for auditing
        Write-EventLog -LogName Application -Source $source -EntryType Information -EventId 1000 -Message "Opened Camera Settings page."

    } catch {
        # Show any errors in a message box
        [System.Windows.Forms.MessageBox]::Show(
            "An error occurred: $($_.Exception.Message)",
            "Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
    }
} else {
    # User chose 'No', optionally log or just silently exit
    # Write-Host "Operation cancelled by the user."
}
