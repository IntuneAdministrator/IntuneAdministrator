<#
.SYNOPSIS
    Prompts the user to open the Apps & Features settings page on Windows 11 24H2.

.DESCRIPTION
    Displays a Windows Forms message box asking the user if they want to open the Apps & Features settings page.
    If the user agrees, the script opens the settings page and logs the action in the Application event log.
    It also handles errors gracefully and ensures the event log source exists before writing.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.1
    Date        : 2025-07-16

.NOTES
    Compatibility: Windows 11 24H2 and above
    Requires     : Permissions to write to the event log and start processes
#>

# Load Windows Forms to enable MessageBox functionality
Add-Type -AssemblyName System.Windows.Forms

try {
    # Prompt the user with a Yes/No dialog to confirm action
    $dialogResult = [System.Windows.Forms.MessageBox]::Show(
        "Do you want to open the Apps & Features settings page?",
        "Confirm Action",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question
    )

    # Proceed only if the user selects 'Yes'
    if ($dialogResult -eq [System.Windows.Forms.DialogResult]::Yes) {
        # Define the ms-settings URI for the Apps & Features page
        $settingsUri = "ms-settings:appsfeatures"

        # Open the Apps & Features settings page
        Start-Process $settingsUri

        # Define event log parameters
        $logName    = "Application"
        $source     = "AppsFeaturesScript"
        $eventID    = 1020
        $entryType  = [System.Diagnostics.EventLogEntryType]::Information
        $message    = "User opened the 'Apps & Features' settings page via script on Windows 11 24H2."

        # Ensure the event source exists; create if necessary
        if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
            New-EventLog -LogName $logName -Source $source
        }

        # Write a success log entry
        Write-EventLog -LogName $logName -Source $source -EntryType $entryType -EventId $eventID -Message $message
    }

} catch {
    # Handle and report any error
    $errorMessage = "An error occurred: $($_.Exception.Message)"

    # Display error message to the user
    [System.Windows.Forms.MessageBox]::Show(
        $errorMessage,
        "Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )

    # Fallback event log source and error ID
    $fallbackSource = "PowerShellScriptError"
    $fallbackEventID = 2020

    # Create fallback source if it doesn't exist
    if (-not [System.Diagnostics.EventLog]::SourceExists($fallbackSource)) {
        New-EventLog -LogName "Application" -Source $fallbackSource
    }

    # Log the error to the Application event log
    Write-EventLog -LogName "Application" -Source $fallbackSource -EntryType [System.Diagnostics.EventLogEntryType]::Error -EventId $fallbackEventID -Message $errorMessage
}
