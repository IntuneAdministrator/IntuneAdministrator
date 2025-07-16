<#
.SYNOPSIS
    Prompts the user to open the Battery Saver settings page if a battery is detected.

.DESCRIPTION
    Uses CIM to check for the presence of a battery on the device. If a battery exists, prompts the user with a confirmation dialog.
    Upon user approval, opens the Battery Saver settings page and logs the action to the Application event log.
    If no battery is found, informs the user. Handles errors gracefully and logs them when possible.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-16

.NOTES
    Compatibility: Windows 11 24H2 and above  
    Requires     : Permissions to write to the event log and start processes
#>

# Load the Windows Forms assembly to use MessageBox GUI dialogs
Add-Type -AssemblyName System.Windows.Forms

# Define event log source name to avoid hardcoding it multiple times
$eventSource = "Battery Saver Settings"

try {
    # Query for battery presence using CIM (preferred over Get-WmiObject which is deprecated)
    $batteryStatus = Get-CimInstance -ClassName Win32_Battery

    if ($batteryStatus) {
        # Battery detected, ask user for confirmation before opening settings
        $response = [System.Windows.Forms.MessageBox]::Show(
            "A battery is detected on this device.`nDo you want to open the Battery Saver settings page?",
            "Open Battery Saver Settings",
            [System.Windows.Forms.MessageBoxButtons]::YesNo,
            [System.Windows.Forms.MessageBoxIcon]::Question
        )

        if ($response -eq [System.Windows.Forms.DialogResult]::Yes) {
            # Ensure the event log source exists before writing to it
            if (-not [System.Diagnostics.EventLog]::SourceExists($eventSource)) {
                New-EventLog -LogName Application -Source $eventSource
            }

            # Open Battery Saver settings page
            Start-Process "ms-settings:batterysaver"

            # Log the action for auditing
            Write-EventLog -LogName Application -Source $eventSource -EntryType Information -EventId 1000 -Message "User opened Battery Saver settings."
        }
        else {
            # User chose not to proceed
            Write-Host "User canceled opening Battery Saver settings."
        }
    }
    else {
        # Inform the user that no battery was detected
        [System.Windows.Forms.MessageBox]::Show(
            "This device does not have a battery. Battery Saver settings are unavailable.",
            "No Battery Detected",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
    }
}
catch {
    # Handle unexpected errors gracefully
    $errorMsg = "An error occurred: $($_.Exception.Message)"
    Write-Error $errorMsg

    # Log the error if event source exists
    if ([System.Diagnostics.EventLog]::SourceExists($eventSource)) {
        Write-EventLog -LogName Application -Source $eventSource -EntryType Error -EventId 1001 -Message $errorMsg
    }
}
