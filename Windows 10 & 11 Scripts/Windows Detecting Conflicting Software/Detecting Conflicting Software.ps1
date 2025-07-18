<#
.SYNOPSIS
    Detects potentially conflicting audio software running on the system and notifies the user.

.DESCRIPTION
    This script checks for a list of known audio management or enhancement applications that might interfere
    with system audio settings or other audio software.
    It queries running processes, identifies any conflicts, and informs the user via Windows Forms message boxes.
    If conflicts are detected, it lists the conflicting software; otherwise, it confirms no conflicts are found.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-18

.NOTES
    Compatibility: Windows 11 24H2 and later
    Requires     : PowerShell 5.1+ with access to System.Windows.Forms
    Usage        : Run prior to troubleshooting audio issues or configuring audio software.
#>

# Begin script to detect potentially conflicting audio software running on the system

# Step 1: Load necessary assembly to use Windows Forms for displaying message boxes
# Windows Forms is required to create and display message boxes with custom content
Add-Type -AssemblyName System.Windows.Forms

# Step 2: Define a list of known audio software that may conflict with other audio applications or system audio settings
# These are common audio management or enhancement applications that could interfere with the system’s default audio settings
$knownApps = @("Voicemeeter", "Nahimic", "RealtekAudioConsole", "Dolby", "Razer", "KillerService")

# Step 3: Get a list of all running processes and filter out those that match the known audio software
# `Get-Process` retrieves all currently running processes. The `Where-Object` cmdlet filters out processes where the process name
# matches any of the names in the `$knownApps` array. This identifies any conflicting applications that are currently running.
$runningConflicts = Get-Process | Where-Object { $knownApps -contains $_.ProcessName }

# Step 4: Check if any conflicting applications are running
if ($runningConflicts) {
    # If there are conflicts, extract the process names of the conflicting software
    # `Select-Object -ExpandProperty ProcessName` retrieves just the names of the conflicting processes (not the entire process object)
    $names = $runningConflicts | Select-Object -ExpandProperty ProcessName

    # Step 5: Display a warning message box to notify the user of the conflicting applications
    # The message box displays the names of the conflicting processes so that the user is aware of which software needs to be addressed
    # The warning icon is used to indicate that there is a potential issue with the system's audio configuration
    [System.Windows.Forms.MessageBox]::Show(
        "Detected potentially conflicting audio software running:`n$($names -join ', ')",  # List of conflicting process names
        "Conflicting Software Detected",  # Title of the message box
        [System.Windows.Forms.MessageBoxButtons]::OK,  # Only an OK button to close the message box
        [System.Windows.Forms.MessageBoxIcon]::Warning  # Warning icon to indicate the presence of a conflict
    )
} else {
    # Step 6: If no conflicting applications are found, display an informational message box
    # This message box informs the user that there are no known conflicting audio software running
    [System.Windows.Forms.MessageBox]::Show(
        "No known conflicting audio software detected.",  # Informational message indicating no conflicts
        "No Conflicts Found",  # Title of the message box
        [System.Windows.Forms.MessageBoxButtons]::OK,  # OK button to acknowledge the message
        [System.Windows.Forms.MessageBoxIcon]::Information  # Information icon indicating no issues
    )
}

# Step 7: Exit the script after the message box is displayed
# Exiting ensures that the script terminates cleanly after the user acknowledges the message
exit
