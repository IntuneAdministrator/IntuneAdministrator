<#
.SYNOPSIS
    Prompts the user to open the Advanced Network Settings page on Windows 11 24H2.

.DESCRIPTION
    Displays a Windows Forms message box asking the user if they want to open the Advanced Network Settings page.
    If the user agrees, the script opens the settings page and logs the action in the Application event log.
    It also handles errors gracefully and ensures event log source existence.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-16

.NOTES
    Compatibility: Windows 11 24H2 and above
    Requires     : Permissions to write to the event log and start processes
#>

# Load the required .NET assembly for using Windows Forms message boxes
Add-Type -AssemblyName System.Windows.Forms

try {
    # Define the message to prompt the user
    $message = "Do you want to open the Advanced Network Settings page?"

    # Define the title of the message box window
    $title = "Open Advanced Network Settings"

    # Show a Yes/No message box with a question icon and capture the user's response
    $response = [System.Windows.Forms.MessageBox]::Show(
        $message,
        $title,
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question
    )

    # Check if the user clicked 'Yes'
    if ($response -eq [System.Windows.Forms.DialogResult]::Yes) {
        # Open the Advanced Network Settings page via the ms-settings URI scheme
        Start-Process "ms-settings:network-advancedsettings"

        # Define event log parameters
        $logName = "Application"
        $source = "Network Advanced Settings"
        $eventId = 1000
        $logMessage = "User opened the Advanced Network Settings page."

        # Create the event log source if it doesn't exist (requires admin privileges)
        if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
            New-EventLog -LogName $logName -Source $source
        }

        # Write an informational event log entry for auditing
        Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId $eventId -Message $logMessage
    }
    else {
        # User declined to open the settings page; optionally notify them
        [System.Windows.Forms.MessageBox]::Show(
            "The Advanced Network Settings page was not opened.",
            "Operation Cancelled",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
    }
}
catch {
    # Handle and display any unexpected errors in a message box
    [System.Windows.Forms.MessageBox]::Show(
        "An error occurred: $($_.Exception.Message)",
        "Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
}
