<#
.SYNOPSIS
    Prompts the user with a Yes/No dialog to open the Windows 11 Colors personalization settings.

.DESCRIPTION
    Displays a simple Windows Forms message box asking the user if they want to open the Colors personalization page.
    If the user selects Yes, the script launches the Colors settings page using the appropriate ms-settings URI.
    If No is selected, the script exits silently without any further action.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Requires     : .NET Framework for Windows Forms
#>

Add-Type -AssemblyName System.Windows.Forms

$userChoice = [System.Windows.Forms.MessageBox]::Show(
    "Do you want to open the Colors personalization settings page?",
    "Open Colors Settings",
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Question
)

if ($userChoice -eq [System.Windows.Forms.DialogResult]::Yes) {
    Start-Process "ms-settings:personalization-colors"
}
