<#
.SYNOPSIS
    Prompts the user to open the detailed Battery Saver settings page if a battery is detected.

.DESCRIPTION
    Checks for the presence of a battery using the Win32_Battery class. If a battery is detected, prompts the user with a GUI confirmation.
    If the user agrees, opens the detailed Battery Saver settings page and logs the action in the Application event log.
    If no battery is found, it notifies the user. The script also ensures event source existence and handles errors gracefully.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.1
    Date        : 2025-07-16

.NOTES
    Compatibility: Windows 11 24H2 and above  
    Requires     : Permissions to write to the event log and start processes
#>

# Load Windows Forms assembly for GUI dialogs
Add-Type -AssemblyName System.Windows.Forms

# Define the event log source name
$eventSource = "Battery Saver Settings"

try {
    # Check if the device has a battery by querying Win32_Battery class
    $batteryStatus = Get-CimInstance -ClassName Win32_Battery

    if ($batteryStatus) {
        # Prompt the user for confirmation before opening settings
        $dialogResult = [System.Windows.Forms.MessageBox]::Show(
            "A battery is detected on this device.`nDo you want to open the Battery Saver settings page?",
            "Open Battery Saver Settings",
            [System.Windows.Forms.MessageBoxButtons]::YesNo,
            [System.Windows.Forms.MessageBoxIcon]::Question
        )

        if ($dialogResult -eq [System.Windows.Forms.DialogResult]::Yes) {
            # Ensure event log source exists
            if (-not [System.Diagnostics.EventLog]::SourceExists($eventSource)) {
                New-EventLog -LogName Application -Source $eventSource
            }

            # Open Battery Saver settings page
            Start-Process "ms-settings:batterysaver-settings"

            # Log the event for auditing
            Write-EventLog -LogName Application -Source $eventSource -EntryType Information -EventId 1000 -Message "User opened Battery Saver detailed settings."
        } else {
            # User declined to open settings
            Write-Host "Operation canceled by user."
        }
    }
    else {
        # No battery detected, inform the user
        [System.Windows.Forms.MessageBox]::Show(
            "This device does not have a battery. Battery Saver settings are unavailable.",
            "No Battery Detected",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
    }
}
catch {
    # Handle errors gracefully
    $errorMessage = "An error occurred: $($_.Exception.Message)"
    Write-Error $errorMessage

    if ([System.Diagnostics.EventLog]::SourceExists($eventSource)) {
        Write-EventLog -LogName Application -Source $eventSource -EntryType Error -EventId 1001 -Message $errorMessage
    }
}
