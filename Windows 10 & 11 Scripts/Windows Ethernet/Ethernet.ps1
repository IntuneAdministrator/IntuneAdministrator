<#
.SYNOPSIS
    Opens a custom network settings dialog with buttons for Ethernet, Wi-Fi, or Cancel.

.DESCRIPTION
    This script launches a custom Windows Forms GUI dialog asking the user to choose between opening 
    the Ethernet or Wi-Fi settings pages on Windows 11 24H2. It also includes error handling and 
    a Cancel button that closes the dialog without action.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-18

.NOTES
    Compatibility: Windows 11 24H2 and later
    Requires     : .NET Framework for Windows Forms
#>

# Load required assemblies for Windows Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create a new form (window)
$form = New-Object System.Windows.Forms.Form
$form.Text = "Network Settings"
$form.Size = New-Object System.Drawing.Size(400, 180)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.Topmost = $true

# Create label with message
$label = New-Object System.Windows.Forms.Label
$label.Text = "Which network settings page do you want to open?"
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(60, 20)
$form.Controls.Add($label)

# Create Ethernet button
$ethernetButton = New-Object System.Windows.Forms.Button
$ethernetButton.Text = "Ethernet"
$ethernetButton.Size = New-Object System.Drawing.Size(100, 30)
$ethernetButton.Location = New-Object System.Drawing.Point(30, 70)
$ethernetButton.Add_Click({
    try {
        Start-Process "ms-settings:network-ethernet"
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Could not open Ethernet settings.`n$($_.Exception.Message)", "Error", 'OK', 'Error')
    }
    $form.Close()
})
$form.Controls.Add($ethernetButton)

# Create Wi-Fi button
$wifiButton = New-Object System.Windows.Forms.Button
$wifiButton.Text = "Wi-Fi"
$wifiButton.Size = New-Object System.Drawing.Size(100, 30)
$wifiButton.Location = New-Object System.Drawing.Point(140, 70)
$wifiButton.Add_Click({
    try {
        Start-Process "ms-settings:network-wifi"
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Could not open Wi-Fi settings.`n$($_.Exception.Message)", "Error", 'OK', 'Error')
    }
    $form.Close()
})
$form.Controls.Add($wifiButton)

# Create Cancel button
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Cancel"
$cancelButton.Size = New-Object System.Drawing.Size(100, 30)
$cancelButton.Location = New-Object System.Drawing.Point(250, 70)
$cancelButton.Add_Click({
    $form.Close()
})
$form.Controls.Add($cancelButton)

# Show the form (modal)
$form.ShowDialog()
