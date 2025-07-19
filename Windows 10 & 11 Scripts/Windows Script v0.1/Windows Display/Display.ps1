<#
.SYNOPSIS
    Opens the Display settings page on Windows 11 24H2 and asks user confirmation.

.DESCRIPTION
    This script launches the Windows Display settings page and shows a Yes/No message box asking
    the user to confirm if they want to open the Display settings. The user's response is returned.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-17
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2 and later
    Requires     : .NET Framework for Windows Forms
#>

Add-Type -AssemblyName System.Windows.Forms

# Show Yes/No confirmation message box
$response = [System.Windows.Forms.MessageBox]::Show(
    "Do you want to open the Display settings?",
    "Open Display Settings",
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Question
)

if ($response -eq [System.Windows.Forms.DialogResult]::Yes) {
    Start-Process "ms-settings:display"
}
