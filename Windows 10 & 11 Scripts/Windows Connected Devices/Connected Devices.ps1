<#
.SYNOPSIS
    Prompts the user with a Yes/No dialog to open the Windows 11 Connected Devices settings.

.DESCRIPTION
    Displays a Windows Forms message box asking the user if they want to open the Connected Devices settings page.
    If the user selects Yes, it launches the Connected Devices settings via the ms-settings URI.
    If No is selected, the script exits quietly without further action.

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
    "Do you want to open the Connected Devices settings page?",
    "Open Connected Devices Settings",
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Question
)

if ($userChoice -eq [System.Windows.Forms.DialogResult]::Yes) {
    Start-Process "ms-settings:connecteddevices"
}
