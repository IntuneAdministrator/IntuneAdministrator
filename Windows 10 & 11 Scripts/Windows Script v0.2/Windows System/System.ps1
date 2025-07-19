<#
.SYNOPSIS
    System Settings Dashboard - Interactive WPF GUI for Windows 11 24H2 System Settings

.DESCRIPTION
    This script creates a WPF GUI with individually defined buttons for various Windows system settings.
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
    $source = "PowerShell - System Settings Dashboard"

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
$window.Title = "System Settings Dashboard"
# Remove fixed size
#$window.Width = 600
#$window.Height = 800
$window.SizeToContent = 'WidthAndHeight'
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

# Main vertical StackPanel
$mainPanel = New-Object System.Windows.Controls.StackPanel
$mainPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$mainPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$mainPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Top
$mainPanel.Margin = [System.Windows.Thickness]::new(10)
$window.Content = $mainPanel

# Header TextBlock
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "System Settings Dashboard"
$textBlockHeader.FontSize = 18
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0,0,0,20)
$mainPanel.Children.Add($textBlockHeader)

# Create Grid for buttons with 3 columns
$gridButtons = New-Object System.Windows.Controls.Grid
$gridButtons.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$gridButtons.VerticalAlignment = [System.Windows.VerticalAlignment]::Top
$gridButtons.Width = 960  # 320 * 3 columns

# Define 3 equal columns
for ($i=0; $i -lt 3; $i++) {
    $colDef = New-Object System.Windows.Controls.ColumnDefinition
    $colDef.Width = [System.Windows.GridLength]::new(1, [System.Windows.GridUnitType]::Star)
    $gridButtons.ColumnDefinitions.Add($colDef)
}

# Helper function to add button to grid
function Add-ButtonToGrid {
    param(
        [System.Windows.Controls.Button]$btn,
        [int]$row,
        [int]$col
    )
    $btn.Width = 320   # Changed from 180
    $btn.Margin = [System.Windows.Thickness]::new(5)
    [System.Windows.Controls.Grid]::SetRow($btn, $row)
    [System.Windows.Controls.Grid]::SetColumn($btn, $col)
    $gridButtons.Children.Add($btn) | Out-Null
}

# Define each button individually with event handlers

# About
$buttonAbout = New-Object System.Windows.Controls.Button
$buttonAbout.Content = "About"
$buttonAbout.Add_Click({
    Start-Process "ms-settings:about"
    Log-Action "Opened 'About'"
})

# Advanced display settings
$buttonAdvancedDisplay = New-Object System.Windows.Controls.Button
$buttonAdvancedDisplay.Content = "Advanced display settings"
$buttonAdvancedDisplay.Add_Click({
    Start-Process "ms-settings:display-advanced"
    Log-Action "Opened 'Advanced display settings'"
})

# Battery Saver
$buttonBatterySaver = New-Object System.Windows.Controls.Button
$buttonBatterySaver.Content = "Battery Saver"
$buttonBatterySaver.Add_Click({
    Start-Process "ms-settings:batterysaver"
    Log-Action "Opened 'Battery Saver'"
})

# Battery Saver settings
$buttonBatterySaverSettings = New-Object System.Windows.Controls.Button
$buttonBatterySaverSettings.Content = "Battery Saver settings"
$buttonBatterySaverSettings.Add_Click({
    Start-Process "ms-settings:batterysaver-settings"
    Log-Action "Opened 'Battery Saver settings'"
})

# Battery use
$buttonBatteryUse = New-Object System.Windows.Controls.Button
$buttonBatteryUse.Content = "Battery use"
$buttonBatteryUse.Add_Click({
    Start-Process "ms-settings:batterysaver-usagedetails"
    Log-Action "Opened 'Battery use'"
})

# Clipboard
$buttonClipboard = New-Object System.Windows.Controls.Button
$buttonClipboard.Content = "Clipboard"
$buttonClipboard.Add_Click({
    Start-Process "ms-settings:clipboard"
    Log-Action "Opened 'Clipboard'"
})

# Default Save Locations
$buttonDefaultSaveLocations = New-Object System.Windows.Controls.Button
$buttonDefaultSaveLocations.Content = "Default Save Locations"
$buttonDefaultSaveLocations.Add_Click({
    Start-Process "ms-settings:savelocations"
    Log-Action "Opened 'Default Save Locations'"
})

# Display
$buttonDisplay = New-Object System.Windows.Controls.Button
$buttonDisplay.Content = "Display"
$buttonDisplay.Add_Click({
    Start-Process "ms-settings:display"
    Log-Action "Opened 'Display'"
})

# Screen rotation
$buttonScreenRotation = New-Object System.Windows.Controls.Button
$buttonScreenRotation.Content = "Screen rotation"
$buttonScreenRotation.Add_Click({
    Start-Process "ms-settings:screenrotation"
    Log-Action "Opened 'Screen rotation'"
})

# Duplicating my display
$buttonDuplicatingDisplay = New-Object System.Windows.Controls.Button
$buttonDuplicatingDisplay.Content = "Duplicating my display"
$buttonDuplicatingDisplay.Add_Click({
    Start-Process "ms-settings:quietmomentspresentation"
    Log-Action "Opened 'Duplicating my display'"
})

# During these hours
$buttonDuringTheseHours = New-Object System.Windows.Controls.Button
$buttonDuringTheseHours.Content = "During these hours"
$buttonDuringTheseHours.Add_Click({
    Start-Process "ms-settings:quietmomentsscheduled"
    Log-Action "Opened 'During these hours'"
})

# Encryption
$buttonEncryption = New-Object System.Windows.Controls.Button
$buttonEncryption.Content = "Encryption"
$buttonEncryption.Add_Click({
    Start-Process "ms-settings:deviceencryption"
    Log-Action "Opened 'Encryption'"
})

# Energy recommendations
$buttonEnergyRecommendations = New-Object System.Windows.Controls.Button
$buttonEnergyRecommendations.Content = "Energy recommendations"
$buttonEnergyRecommendations.Add_Click({
    Start-Process "ms-settings:energyrecommendations"
    Log-Action "Opened 'Energy recommendations'"
})

# Focus assist
$buttonFocusAssist = New-Object System.Windows.Controls.Button
$buttonFocusAssist.Content = "Focus assist"
$buttonFocusAssist.Add_Click({
    Start-Process "ms-settings:quiethours"
    Log-Action "Opened 'Focus assist'"
})

# Graphics Settings
$buttonGraphicsSettings = New-Object System.Windows.Controls.Button
$buttonGraphicsSettings.Content = "Graphics Settings"
$buttonGraphicsSettings.Add_Click({
    Start-Process "ms-settings:display-advancedgraphics"
    Log-Action "Opened 'Graphics Settings'"
})

# Graphics Default Settings
$buttonGraphicsDefault = New-Object System.Windows.Controls.Button
$buttonGraphicsDefault.Content = "Graphics Default Settings"
$buttonGraphicsDefault.Add_Click({
    Start-Process "ms-settings:display-advancedgraphics-default"
    Log-Action "Opened 'Graphics Default Settings'"
})

# Multitasking
$buttonMultitasking = New-Object System.Windows.Controls.Button
$buttonMultitasking.Content = "Multitasking"
$buttonMultitasking.Add_Click({
    Start-Process "ms-settings:multitasking"
    Log-Action "Opened 'Multitasking'"
})

# Multitasking SG Update
$buttonMultitaskingSGUpdate = New-Object System.Windows.Controls.Button
$buttonMultitaskingSGUpdate.Content = "Multitasking SG Update"
$buttonMultitaskingSGUpdate.Add_Click({
    Start-Process "ms-settings:multitasking-sgupdate"
    Log-Action "Opened 'Multitasking SG Update'"
})

# Night light settings
$buttonNightLight = New-Object System.Windows.Controls.Button
$buttonNightLight.Content = "Night light settings"
$buttonNightLight.Add_Click({
    Start-Process "ms-settings:nightlight"
    Log-Action "Opened 'Night light settings'"
})

# Projecting to this PC
$buttonProjectingPC = New-Object System.Windows.Controls.Button
$buttonProjectingPC.Content = "Projecting to this PC"
$buttonProjectingPC.Add_Click({
    Start-Process "ms-settings:project"
    Log-Action "Opened 'Projecting to this PC'"
})

# Shared experiences
$buttonSharedExperiences = New-Object System.Windows.Controls.Button
$buttonSharedExperiences.Content = "Shared experiences"
$buttonSharedExperiences.Add_Click({
    Start-Process "ms-settings:crossdevice"
    Log-Action "Opened 'Shared experiences'"
})

# Tablet mode
$buttonTabletMode = New-Object System.Windows.Controls.Button
$buttonTabletMode.Content = "Tablet mode"
$buttonTabletMode.Add_Click({
    Start-Process "ms-settings:tabletmode"
    Log-Action "Opened 'Tablet mode'"
})

# Taskbar
$buttonTaskbar = New-Object System.Windows.Controls.Button
$buttonTaskbar.Content = "Taskbar"
$buttonTaskbar.Add_Click({
    Start-Process "ms-settings:taskbar"
    Log-Action "Opened 'Taskbar'"
})

# Notifications & actions
$buttonNotificationsActions = New-Object System.Windows.Controls.Button
$buttonNotificationsActions.Content = "Notifications & actions"
$buttonNotificationsActions.Add_Click({
    Start-Process "ms-settings:notifications"
    Log-Action "Opened 'Notifications & actions'"
})

# Remote Desktop
$buttonRemoteDesktop = New-Object System.Windows.Controls.Button
$buttonRemoteDesktop.Content = "Remote Desktop"
$buttonRemoteDesktop.Add_Click({
    Start-Process "ms-settings:remotedesktop"
    Log-Action "Opened 'Remote Desktop'"
})

# Phone
$buttonPhone = New-Object System.Windows.Controls.Button
$buttonPhone.Content = "Phone"
$buttonPhone.Add_Click({
    Start-Process "ms-settings:phone"
    Log-Action "Opened 'Phone'"
})

# Power & sleep
$buttonPowerSleep = New-Object System.Windows.Controls.Button
$buttonPowerSleep.Content = "Power & sleep"
$buttonPowerSleep.Add_Click({
    Start-Process "ms-settings:powersleep"
    Log-Action "Opened 'Power & sleep'"
})

# Presence sensing
$buttonPresenceSensing = New-Object System.Windows.Controls.Button
$buttonPresenceSensing.Content = "Presence sensing"
$buttonPresenceSensing.Add_Click({
    Start-Process "ms-settings:presence"
    Log-Action "Opened 'Presence sensing'"
})

# Storage
$buttonStorage = New-Object System.Windows.Controls.Button
$buttonStorage.Content = "Storage"
$buttonStorage.Add_Click({
    Start-Process "ms-settings:storagesense"
    Log-Action "Opened 'Storage'"
})

# Storage Sense
$buttonStorageSense = New-Object System.Windows.Controls.Button
$buttonStorageSense.Content = "Storage Sense"
$buttonStorageSense.Add_Click({
    Start-Process "ms-settings:storagepolicies"
    Log-Action "Opened 'Storage Sense'"
})

# Storage recommendations
$buttonStorageRecommendations = New-Object System.Windows.Controls.Button
$buttonStorageRecommendations.Content = "Storage recommendations"
$buttonStorageRecommendations.Add_Click({
    Start-Process "ms-settings:storagerecommendations"
    Log-Action "Opened 'Storage recommendations'"
})

# Disks & volumes
$buttonDisksVolumes = New-Object System.Windows.Controls.Button
$buttonDisksVolumes.Content = "Disks & volumes"
$buttonDisksVolumes.Add_Click({
    Start-Process "ms-settings:disksandvolumes"
    Log-Action "Opened 'Disks & volumes'"
})

# Collect all buttons in an array (order matches above)
$buttons = @(
    $buttonAbout,
    $buttonAdvancedDisplay,
    $buttonBatterySaver,
    $buttonBatterySaverSettings,
    $buttonBatteryUse,
    $buttonClipboard,
    $buttonDefaultSaveLocations,
    $buttonDisplay,
    $buttonScreenRotation,
    $buttonDuplicatingDisplay,
    $buttonDuringTheseHours,
    $buttonEncryption,
    $buttonEnergyRecommendations,
    $buttonFocusAssist,
    $buttonGraphicsSettings,
    $buttonGraphicsDefault,
    $buttonMultitasking,
    $buttonMultitaskingSGUpdate,
    $buttonNightLight,
    $buttonProjectingPC,
    $buttonSharedExperiences,
    $buttonTabletMode,
    $buttonTaskbar,
    $buttonNotificationsActions,
    $buttonRemoteDesktop,
    $buttonPhone,
    $buttonPowerSleep,
    $buttonPresenceSensing,
    $buttonStorage,
    $buttonStorageSense,
    $buttonStorageRecommendations,
    $buttonDisksVolumes
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
