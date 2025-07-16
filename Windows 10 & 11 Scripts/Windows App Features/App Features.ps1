<#
.SYNOPSIS
    Prompt the user to open the Apps & Features settings page on Windows 11 24H2.

.DESCRIPTION
    This script displays a Windows Forms message box asking the user to confirm if they want to open the Apps & Features settings page.
    If the user agrees, it opens the settings page via ms-settings URI.
    The script logs the user's action in the Application event log for auditing.
    Includes error handling and checks for event log source existence.

.NOTES
    Author      : Senior IT Professional
    Date        : 2025-07-16
    Compatibility: Windows 11 24H2 and above
    Requires    : Permission to write to the event log and start processes
#>

# Load the necessary assembly to use Windows Forms MessageBox
Add-Type -AssemblyName System.Windows.Forms

try {
    # Display a confirmation message box with Yes/No options
    $result = [System.Windows.Forms.MessageBox]::Show(
        "Do you want to open the Apps & Features settings page?",
        "Open Apps & Features",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question
    )

    # Check if user clicked 'Yes'
    if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {

        # Start the Apps & Features settings page using the ms-settings URI scheme
        Start-Process "ms-settings:appsfeatures"

        # Define event log parameters
        $logName = "Application"
        $source = "AppsFeaturesLauncher"
        $eventId = 1001
        $message = "User opened the Apps & Features settings page."

        # Check if the event log source exists; if not, create it
        if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
            New-EventLog -LogName $logName -Source $source
        }

        # Write an informational event to the Application event log
        Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId $eventId -Message $message
    }
    else {
        # User chose not to open the settings page; optionally log or silently exit
        # Write-Verbose "User declined to open the Apps & Features settings page."
    }
}
catch {
    # Handle any exceptions by showing an error message box
    [System.Windows.Forms.MessageBox]::Show(
        "An error occurred: $($_.Exception.Message)",
        "Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
}
