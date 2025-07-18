<#
.SYNOPSIS
    Displays a Yes/No message box and opens the Display settings page if Yes is clicked.

.DESCRIPTION
    Loads Windows Forms to show a confirmation dialog.
    If the user confirms (clicks Yes), opens the Windows Display settings page.
    Otherwise, the script ends gracefully.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.1
    Date        : 2025-07-18

.NOTES
    Requires PowerShell with .NET Framework.
    Tested on Windows 11 24H2.
#>

# Load Windows Forms assembly to use MessageBox class
Add-Type -AssemblyName System.Windows.Forms

# Define message and window title for the confirmation dialog
$message = "Do you want to open the Display settings?"
$title = "Open Display Settings"

# Show the Yes/No message box with a Question icon
$userResponse = [System.Windows.Forms.MessageBox]::Show(
    $message,
    $title,
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Question
)

# If user clicks Yes, open the Display settings page
if ($userResponse -eq [System.Windows.Forms.DialogResult]::Yes) {
    Write-Host "User selected Yes. Opening Display settings..."
    Start-Process "ms-settings:display"
} else {
    Write-Host "User selected No. Exiting script."
}
