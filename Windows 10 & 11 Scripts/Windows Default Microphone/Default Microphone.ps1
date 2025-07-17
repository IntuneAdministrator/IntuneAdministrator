<#
.SYNOPSIS
    Prompts the user with a Yes/No dialog to open the Windows 11 Default Microphone settings.

.DESCRIPTION
    Displays a Windows Forms message box asking if the user wants to open the Default Microphone settings page.
    If the user clicks Yes, it launches the Default Microphone settings via the ms-settings URI.
    If No, the script exits silently.

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
    "Do you want to open the Default Microphone settings page?",
    "Open Default Microphone Settings",
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Question
)

if ($userChoice -eq [System.Windows.Forms.DialogResult]::Yes) {
    Start-Process "ms-settings:sound-defaultinputproperties"
}
