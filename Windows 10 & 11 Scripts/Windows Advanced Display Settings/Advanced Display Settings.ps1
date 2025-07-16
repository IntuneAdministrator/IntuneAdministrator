<#
.SYNOPSIS
    Checks for advanced display settings support and prompts the user to open the settings page on Windows 11 24H2.

.DESCRIPTION
    Queries the video controller(s) to verify if advanced display settings are available.
    If supported, prompts the user with a Yes/No message box asking whether to open the 'Advanced Display Settings' page.
    Upon user confirmation, opens the settings page and logs the action in the Application event log.
    If not supported, informs the user accordingly.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-16

.NOTES
    Compatibility: Windows 11 24H2 and above
    Requires     : Running with appropriate permissions to write event logs and start processes
#>

# Load Windows Forms assembly to use MessageBox for user interaction
Add-Type -AssemblyName System.Windows.Forms

try {
    # Query video controllers for display mode descriptions, indicating advanced display support
    $displaySupported = Get-CimInstance -ClassName Win32_VideoController | Select-Object -ExpandProperty VideoModeDescription

    # If any display mode description exists, consider advanced display settings supported
    if ($displaySupported -and $displaySupported.Count -gt 0) {

        # Prompt the user with a Yes/No message box asking if they want to open the settings page
        $userResponse = [System.Windows.Forms.MessageBox]::Show(
            "Advanced Display Settings are available on this device.`nWould you like to open the settings page now?",
            "Open Advanced Display Settings?",
            [System.Windows.Forms.MessageBoxButtons]::YesNo,
            [System.Windows.Forms.MessageBoxIcon]::Question
        )

        # If user clicks Yes, open the settings page and log the event
        if ($userResponse -eq [System.Windows.Forms.DialogResult]::Yes) {
            # Launch the Advanced Display Settings page using the ms-settings URI scheme
            Start-Process "ms-settings:display-advanced"

            # Define event log source and parameters
            $logSource = "Advanced Display Settings"
            $logName = "Application"
            $eventId = 1000

            # Create event log source if it does not exist (requires admin privileges)
            if (-not [System.Diagnostics.EventLog]::SourceExists($logSource)) {
                New-EventLog -LogName $logName -Source $logSource
            }

            # Write an informational entry to the event log for auditing
            Write-EventLog -LogName $logName -Source $logSource -EntryType Information -EventId $eventId -Message "User opened Advanced Display Settings page."
        }
        else {
            # User chose not to open the settings; optionally notify or silently exit
            [System.Windows.Forms.MessageBox]::Show(
                "The Advanced Display Settings page was not opened.",
                "Operation Cancelled",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Information
            )
        }
    }
    else {
        # Inform the user that advanced display settings are not supported on this device
        [System.Windows.Forms.MessageBox]::Show(
            "Advanced Display Settings are not supported on this device.",
            "Not Supported",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
    }
}
catch {
    # Handle unexpected errors gracefully and display the error message to the user
    [System.Windows.Forms.MessageBox]::Show(
        "An error occurred while checking or opening Advanced Display Settings:`n$($_.Exception.Message)",
        "Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
}
