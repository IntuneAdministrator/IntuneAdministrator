<#
.SYNOPSIS
    Windows Maintenance Settings Dashboard - Interactive WPF GUI for Windows 11 24H2

.DESCRIPTION
    This script creates a WPF GUI with individually defined buttons for various Windows maintenance and update settings.
    Each button opens its respective ms-settings URI and logs the action to the Windows Event Log.

.AUTHOR
    Allester Padovani
    Senior IT Specialist
    Date: 2025-07-18
    Version: 1.0

.NOTES
    Requires Windows 11 24H2 or later.
    Requires PowerShell 5.1+ and admin rights for event log creation.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

function Log-Action {
    param ([string]$message)

    $logName = "Application"
    $source = "PowerShell - Windows Maintenance Dashboard"

    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try {
            New-EventLog -LogName $logName -Source $source
        } catch {
            Write-Warning "Run the script as Administrator to create event log source."
        }
    }

    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message $message
}

# Create main window
$window = New-Object System.Windows.Window
$window.Title = "Windows Maintenance Dashboard"
#$window.Width = 600
#$window.Height = 700
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen
$window.SizeToContent = 'WidthAndHeight'

# Main vertical StackPanel
$mainPanel = New-Object System.Windows.Controls.StackPanel
$mainPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$mainPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$mainPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Top
$mainPanel.Margin = [System.Windows.Thickness]::new(10)
$window.Content = $mainPanel

# Header TextBlock
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "Windows Maintenance Dashboard"
$textBlockHeader.FontSize = 18
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0,0,0,20)
$mainPanel.Children.Add($textBlockHeader)

# Create Grid for buttons with 3 columns
$gridButtons = New-Object System.Windows.Controls.Grid
$gridButtons.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$gridButtons.VerticalAlignment = [System.Windows.VerticalAlignment]::Top
#$gridButtons.Width = 580

# Define 3 equal columns
for ($i=0; $i -lt 3; $i++) {
    $colDef = New-Object System.Windows.Controls.ColumnDefinition
    $colDef.Width = [System.Windows.GridLength]::new(1, [System.Windows.GridUnitType]::Star)
    $gridButtons.ColumnDefinitions.Add($colDef)
}

function Add-ButtonToGrid {
    param(
        [System.Windows.Controls.Button]$btn,
        [int]$row,
        [int]$col
    )
    $btn.Width = 320
    $btn.Margin = [System.Windows.Thickness]::new(5)
    [System.Windows.Controls.Grid]::SetRow($btn, $row)
    [System.Windows.Controls.Grid]::SetColumn($btn, $col)
    $gridButtons.Children.Add($btn) | Out-Null
}

# Buttons definitions

$buttonActivation = New-Object System.Windows.Controls.Button
$buttonActivation.Content = "Activation"
$buttonActivation.Add_Click({
    Start-Process "ms-settings:activation"
    Log-Action "Opened 'Activation'"
})

$buttonBackup = New-Object System.Windows.Controls.Button
$buttonBackup.Content = "Backup"
$buttonBackup.Add_Click({
    Start-Process "ms-settings:backup"
    Log-Action "Opened 'Backup'"
})

$buttonDeliveryOptimization = New-Object System.Windows.Controls.Button
$buttonDeliveryOptimization.Content = "Delivery Optimization"
$buttonDeliveryOptimization.Add_Click({
    Start-Process "ms-settings:delivery-optimization"
    Log-Action "Opened 'Delivery Optimization'"
})

$buttonDeliveryOptimizationActivity = New-Object System.Windows.Controls.Button
$buttonDeliveryOptimizationActivity.Content = "Delivery Optimization Activity"
$buttonDeliveryOptimizationActivity.Add_Click({
    Start-Process "ms-settings:delivery-optimization-activity"
    Log-Action "Opened 'Delivery Optimization Activity'"
})

$buttonDeliveryOptimizationAdvanced = New-Object System.Windows.Controls.Button
$buttonDeliveryOptimizationAdvanced.Content = "Delivery Optimization Advanced"
$buttonDeliveryOptimizationAdvanced.Add_Click({
    Start-Process "ms-settings:delivery-optimization-advanced"
    Log-Action "Opened 'Delivery Optimization Advanced'"
})

$buttonFindMyDevice = New-Object System.Windows.Controls.Button
$buttonFindMyDevice.Content = "Find My Device"
$buttonFindMyDevice.Add_Click({
    Start-Process "ms-settings:findmydevice"
    Log-Action "Opened 'Find My Device'"
})

$buttonForDevelopers = New-Object System.Windows.Controls.Button
$buttonForDevelopers.Content = "For developers"
$buttonForDevelopers.Add_Click({
    Start-Process "ms-settings:developers"
    Log-Action "Opened 'For developers'"
})

$buttonRecovery = New-Object System.Windows.Controls.Button
$buttonRecovery.Content = "Recovery"
$buttonRecovery.Add_Click({
    Start-Process "ms-settings:recovery"
    Log-Action "Opened 'Recovery'"
})

$buttonSecurityKeyEnrollment = New-Object System.Windows.Controls.Button
$buttonSecurityKeyEnrollment.Content = "Launch Security Key Enrollment"
$buttonSecurityKeyEnrollment.Add_Click({
    Start-Process "ms-settings:signinoptions-launchsecuritykeyenrollment"
    Log-Action "Opened 'Launch Security Key Enrollment'"
})

$buttonTroubleshoot = New-Object System.Windows.Controls.Button
$buttonTroubleshoot.Content = "Troubleshoot"
$buttonTroubleshoot.Add_Click({
    Start-Process "ms-settings:troubleshoot"
    Log-Action "Opened 'Troubleshoot'"
})

$buttonWindowsSecurity = New-Object System.Windows.Controls.Button
$buttonWindowsSecurity.Content = "Windows Security"
$buttonWindowsSecurity.Add_Click({
    Start-Process "ms-settings:windowsdefender"
    Log-Action "Opened 'Windows Security'"
})

$buttonWindowsInsiderProgram = New-Object System.Windows.Controls.Button
$buttonWindowsInsiderProgram.Content = "Windows Insider Program"
$buttonWindowsInsiderProgram.Add_Click({
    Start-Process "ms-settings:windowsinsider"
    Log-Action "Opened 'Windows Insider Program'"
})

$buttonWindowsInsiderOptin = New-Object System.Windows.Controls.Button
$buttonWindowsInsiderOptin.Content = "Windows Insider Opt-In"
$buttonWindowsInsiderOptin.Add_Click({
    Start-Process "ms-settings:windowsinsider-optin"
    Log-Action "Opened 'Windows Insider Opt-In'"
})

$buttonWindowsUpdate = New-Object System.Windows.Controls.Button
$buttonWindowsUpdate.Content = "Windows Update"
$buttonWindowsUpdate.Add_Click({
    Start-Process "ms-settings:windowsupdate"
    Log-Action "Opened 'Windows Update'"
})

$buttonWindowsUpdateAction = New-Object System.Windows.Controls.Button
$buttonWindowsUpdateAction.Content = "Windows Update Action"
$buttonWindowsUpdateAction.Add_Click({
    Start-Process "ms-settings:windowsupdate-action"
    Log-Action "Opened 'Windows Update Action'"
})

$buttonWindowsUpdateActiveHours = New-Object System.Windows.Controls.Button
$buttonWindowsUpdateActiveHours.Content = "Windows Update - Active Hours"
$buttonWindowsUpdateActiveHours.Add_Click({
    Start-Process "ms-settings:windowsupdate-activehours"
    Log-Action "Opened 'Windows Update - Active Hours'"
})

$buttonWindowsUpdateAdvancedOptions = New-Object System.Windows.Controls.Button
$buttonWindowsUpdateAdvancedOptions.Content = "Windows Update - Advanced Options"
$buttonWindowsUpdateAdvancedOptions.Add_Click({
    Start-Process "ms-settings:windowsupdate-options"
    Log-Action "Opened 'Windows Update - Advanced Options'"
})

$buttonWindowsUpdateOptionalUpdates = New-Object System.Windows.Controls.Button
$buttonWindowsUpdateOptionalUpdates.Content = "Windows Update - Optional Updates"
$buttonWindowsUpdateOptionalUpdates.Add_Click({
    Start-Process "ms-settings:windowsupdate-optionalupdates"
    Log-Action "Opened 'Windows Update - Optional Updates'"
})

$buttonWindowsUpdateRestartOptions = New-Object System.Windows.Controls.Button
$buttonWindowsUpdateRestartOptions.Content = "Windows Update - Restart Options"
$buttonWindowsUpdateRestartOptions.Add_Click({
    Start-Process "ms-settings:windowsupdate-restartoptions"
    Log-Action "Opened 'Windows Update - Restart Options'"
})

$buttonWindowsUpdateSeekerOnDemand = New-Object System.Windows.Controls.Button
$buttonWindowsUpdateSeekerOnDemand.Content = "Windows Update - Seeker On Demand"
$buttonWindowsUpdateSeekerOnDemand.Add_Click({
    Start-Process "ms-settings:windowsupdate-seekerondemand"
    Log-Action "Opened 'Windows Update - Seeker On Demand'"
})

$buttonWindowsUpdateViewHistory = New-Object System.Windows.Controls.Button
$buttonWindowsUpdateViewHistory.Content = "Windows Update - View Update History"
$buttonWindowsUpdateViewHistory.Add_Click({
    Start-Process "ms-settings:windowsupdate-history"
    Log-Action "Opened 'Windows Update - View Update History'"
})

# Collect all buttons in an array
$buttons = @(
    $buttonActivation,
    $buttonBackup,
    $buttonDeliveryOptimization,
    $buttonDeliveryOptimizationActivity,
    $buttonDeliveryOptimizationAdvanced,
    $buttonFindMyDevice,
    $buttonForDevelopers,
    $buttonRecovery,
    $buttonSecurityKeyEnrollment,
    $buttonTroubleshoot,
    $buttonWindowsSecurity,
    $buttonWindowsInsiderProgram,
    $buttonWindowsInsiderOptin,
    $buttonWindowsUpdate,
    $buttonWindowsUpdateAction,
    $buttonWindowsUpdateActiveHours,
    $buttonWindowsUpdateAdvancedOptions,
    $buttonWindowsUpdateOptionalUpdates,
    $buttonWindowsUpdateRestartOptions,
    $buttonWindowsUpdateSeekerOnDemand,
    $buttonWindowsUpdateViewHistory
)

# Calculate rows needed for 3 columns
$rowsNeeded = [math]::Ceiling($buttons.Count / 3)

# Add rows to grid
for ($i = 0; $i -lt $rowsNeeded; $i++) {
    $rowDef = New-Object System.Windows.Controls.RowDefinition
    $rowDef.Height = [System.Windows.GridLength]::Auto
    $gridButtons.RowDefinitions.Add($rowDef)
}

# Add buttons to grid with row/col positioning
for ($i = 0; $i -lt $buttons.Count; $i++) {
    $row = [math]::Floor($i / 3)
    $col = $i % 3
    Add-ButtonToGrid -btn $buttons[$i] -row $row -col $col
}

# Add grid to main panel
$mainPanel.Children.Add($gridButtons)

# Footer TextBlock
$textBlockFooter = New-Object System.Windows.Controls.TextBlock
$textBlockFooter.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."
$textBlockFooter.FontSize = 12
$textBlockFooter.FontStyle = [System.Windows.FontStyles]::Italic
$textBlockFooter.Foreground = [System.Windows.Media.Brushes]::Black
$textBlockFooter.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$textBlockFooter.Margin = [System.Windows.Thickness]::new(0,20,0,5)
$mainPanel.Children.Add($textBlockFooter)

# Show the GUI window
$window.ShowDialog()
