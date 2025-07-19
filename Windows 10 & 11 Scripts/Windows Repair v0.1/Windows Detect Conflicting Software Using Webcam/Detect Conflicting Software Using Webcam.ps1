<#
.SYNOPSIS
    Detects running applications that may conflict with webcam usage and notifies the user.

.DESCRIPTION
    This script checks for a predefined list of known applications that often lock or use the webcam,
    such as Skype, Zoom, Teams, Discord, OBS, ManyCam, and CyberLink.
    If any conflicting applications are found running, it displays a warning message box with their names,
    prompting the user to close them.
    If no conflicts are detected, it informs the user that no known conflicting apps are currently running.
    Uses Windows Forms to display message boxes for user-friendly notifications.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-17
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2 and later
    Requires     : PowerShell 5.1+ with access to System.Windows.Forms
    Usage        : Run this script before attempting to use webcam-dependent applications.
#>

# Begin script to detect conflicting applications that may be using the webcam

# Step 1: Load necessary assembly to use Windows Forms for displaying message boxes
# Windows Forms is required to create and show message boxes with custom content
Add-Type -AssemblyName System.Windows.Forms

# Step 2: Define a list of known applications that are likely to use or lock the webcam
# These applications (e.g., Skype, Zoom, Teams) often interfere with webcam usage if they are running
$conflictingApps = @("SkypeApp", "Zoom", "Teams", "Discord", "OBS", "ManyCam", "CyberLink")

# Step 3: Check if any of the conflicting applications are currently running
# The `Where-Object` cmdlet is used to filter through the list of applications and check if they are running
# `Get-Process -Name $_ -ErrorAction SilentlyContinue` attempts to get the process for each application
# The `-ErrorAction SilentlyContinue` suppresses errors if the process is not found, avoiding unnecessary error messages
$runningConflicts = $conflictingApps | Where-Object {
    Get-Process -Name $_ -ErrorAction SilentlyContinue
}

# Step 4: Handle the case where conflicting applications are found
if ($runningConflicts) {
    # If there are running conflicts, join them into a comma-separated string to display in the message
    $apps = $runningConflicts -join ", "

    # Step 5: Display a warning message to the user indicating which conflicting applications are running
    # A MessageBox is used to notify the user with a list of conflicting apps
    # The message box uses the warning icon to indicate an issue and provides an OK button to close it
    [System.Windows.Forms.MessageBox]::Show(
        "Conflicting applications detected that may be using the webcam: $apps.`nPlease close them and try again.",  # Message content
        "Conflicting Software Detected",  # Title of the message box window
        [System.Windows.Forms.MessageBoxButtons]::OK,  # OK button to acknowledge the message
        [System.Windows.Forms.MessageBoxIcon]::Warning  # Warning icon to indicate that this is an issue to resolve
    )
} else {
    # Step 6: If no conflicting applications are found, display an informational message
    # The message box indicates that no known conflicts are running and the webcam should be available for use
    [System.Windows.Forms.MessageBox]::Show(
        "No known conflicting applications detected running.",  # Message content indicating no issues
        "Conflicting Software Check",  # Title of the message box window
        [System.Windows.Forms.MessageBoxButtons]::OK,  # OK button to acknowledge the message
        [System.Windows.Forms.MessageBoxIcon]::Information  # Information icon, as there is no issue
    )
}

# Step 7: Exit the script after the message box is displayed
# Exiting ensures the script completes its execution and doesn't continue running unnecessarily
exit
