<#
.SYNOPSIS
    Privacy Settings Dashboard - Interactive WPF GUI for Windows 11 24H2 Privacy Settings

.DESCRIPTION
    This script uses WPF to create a simple vertical layout GUI where each Privacy Setting button is defined individually.
    Clicking a button opens the corresponding ms-settings URI and logs the action to the Windows Event Log.

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
    $source = "PowerShell - Privacy Settings Dashboard"

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
$window.Title = "Privacy Settings Dashboard"
# Remove fixed width and height
# $window.Width = 480
# $window.Height = 800
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen
# Let window size itself based on content
$window.SizeToContent = 'WidthAndHeight'

# Main vertical StackPanel to hold header, grid buttons, footer
$mainPanel = New-Object System.Windows.Controls.StackPanel
$mainPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$mainPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$mainPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Top
$mainPanel.Margin = [System.Windows.Thickness]::new(10)
$window.Content = $mainPanel

# Header TextBlock
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "Privacy Settings Dashboard"
$textBlockHeader.FontSize = 16
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0,0,0,20)
$mainPanel.Children.Add($textBlockHeader)

# Create a Grid for buttons with 3 columns
$gridButtons = New-Object System.Windows.Controls.Grid
$gridButtons.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$gridButtons.VerticalAlignment = [System.Windows.VerticalAlignment]::Top
$gridButtons.Width = 960  # 3 columns * 320 width

# Define 3 equal columns
for ($i=0; $i -lt 3; $i++) {
    $colDef = New-Object System.Windows.Controls.ColumnDefinition
    $colDef.Width = [System.Windows.GridLength]::new(1, [System.Windows.GridUnitType]::Star)
    $gridButtons.ColumnDefinitions.Add($colDef)
}

# Helper function to add button to grid at row and column
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

# Define all buttons (exactly as originally provided)

# Account info
$buttonAccountInfo = New-Object System.Windows.Controls.Button
$buttonAccountInfo.Content = "Account info"
$buttonAccountInfo.Add_Click({
    Start-Process "ms-settings:privacy-accountinfo"
    Log-Action "Opened 'Account info'"
})

# Activity history
$buttonActivityHistory = New-Object System.Windows.Controls.Button
$buttonActivityHistory.Content = "Activity history"
$buttonActivityHistory.Add_Click({
    Start-Process "ms-settings:privacy-activityhistory"
    Log-Action "Opened 'Activity history'"
})

# App diagnostics
$buttonAppDiagnostics = New-Object System.Windows.Controls.Button
$buttonAppDiagnostics.Content = "App diagnostics"
$buttonAppDiagnostics.Add_Click({
    Start-Process "ms-settings:privacy-appdiagnostics"
    Log-Action "Opened 'App diagnostics'"
})

# Automatic file downloads
$buttonAutomaticFileDownloads = New-Object System.Windows.Controls.Button
$buttonAutomaticFileDownloads.Content = "Automatic file downloads"
$buttonAutomaticFileDownloads.Add_Click({
    Start-Process "ms-settings:privacy-automaticfiledownloads"
    Log-Action "Opened 'Automatic file downloads'"
})

# Background Spatial Perception
$buttonBackgroundSpatial = New-Object System.Windows.Controls.Button
$buttonBackgroundSpatial.Content = "Background Spatial Perception"
$buttonBackgroundSpatial.Add_Click({
    Start-Process "ms-settings:privacy-backgroundspatialperception"
    Log-Action "Opened 'Background Spatial Perception'"
})

# Calendar
$buttonCalendar = New-Object System.Windows.Controls.Button
$buttonCalendar.Content = "Calendar"
$buttonCalendar.Add_Click({
    Start-Process "ms-settings:privacy-calendar"
    Log-Action "Opened 'Calendar'"
})

# Call history
$buttonCallHistory = New-Object System.Windows.Controls.Button
$buttonCallHistory.Content = "Call history"
$buttonCallHistory.Add_Click({
    Start-Process "ms-settings:privacy-callhistory"
    Log-Action "Opened 'Call history'"
})

# Camera
$buttonCamera = New-Object System.Windows.Controls.Button
$buttonCamera.Content = "Camera"
$buttonCamera.Add_Click({
    Start-Process "ms-settings:privacy-webcam"
    Log-Action "Opened 'Camera'"
})

# Contacts
$buttonContacts = New-Object System.Windows.Controls.Button
$buttonContacts.Content = "Contacts"
$buttonContacts.Add_Click({
    Start-Process "ms-settings:privacy-contacts"
    Log-Action "Opened 'Contacts'"
})

# Documents
$buttonDocuments = New-Object System.Windows.Controls.Button
$buttonDocuments.Content = "Documents"
$buttonDocuments.Add_Click({
    Start-Process "ms-settings:privacy-documents"
    Log-Action "Opened 'Documents'"
})

# Downloads folder
$buttonDownloadsFolder = New-Object System.Windows.Controls.Button
$buttonDownloadsFolder.Content = "Downloads folder"
$buttonDownloadsFolder.Add_Click({
    Start-Process "ms-settings:privacy-downloadsfolder"
    Log-Action "Opened 'Downloads folder'"
})

# Email
$buttonEmail = New-Object System.Windows.Controls.Button
$buttonEmail.Content = "Email"
$buttonEmail.Add_Click({
    Start-Process "ms-settings:privacy-email"
    Log-Action "Opened 'Email'"
})

# Eye tracker (requires hardware)
$buttonEyeTracker = New-Object System.Windows.Controls.Button
$buttonEyeTracker.Content = "Eye tracker (requires hardware)"
$buttonEyeTracker.Add_Click({
    Start-Process "ms-settings:privacy-eyetracker"
    Log-Action "Opened 'Eye tracker (requires hardware)'"
})

# Feedback & diagnostics
$buttonFeedbackDiagnostics = New-Object System.Windows.Controls.Button
$buttonFeedbackDiagnostics.Content = "Feedback & diagnostics"
$buttonFeedbackDiagnostics.Add_Click({
    Start-Process "ms-settings:privacy-feedback"
    Log-Action "Opened 'Feedback & diagnostics'"
})

# File system
$buttonFileSystem = New-Object System.Windows.Controls.Button
$buttonFileSystem.Content = "File system"
$buttonFileSystem.Add_Click({
    Start-Process "ms-settings:privacy-broadfilesystemaccess"
    Log-Action "Opened 'File system'"
})

# General
$buttonGeneral = New-Object System.Windows.Controls.Button
$buttonGeneral.Content = "General"
$buttonGeneral.Add_Click({
    Start-Process "ms-settings:privacy"
    Log-Action "Opened 'General privacy settings'"
})

# Graphics (with border)
$buttonGraphicsWithBorder = New-Object System.Windows.Controls.Button
$buttonGraphicsWithBorder.Content = "Graphics (with border)"
$buttonGraphicsWithBorder.Add_Click({
    Start-Process "ms-settings:privacy-graphicscaptureprogrammatic"
    Log-Action "Opened 'Graphics (with border)'"
})

# Graphics (without border)
$buttonGraphicsWithoutBorder = New-Object System.Windows.Controls.Button
$buttonGraphicsWithoutBorder.Content = "Graphics (without border)"
$buttonGraphicsWithoutBorder.Add_Click({
    Start-Process "ms-settings:privacy-graphicscapturewithoutborder"
    Log-Action "Opened 'Graphics (without border)'"
})

# Inking & typing
$buttonInkingTyping = New-Object System.Windows.Controls.Button
$buttonInkingTyping.Content = "Inking & typing"
$buttonInkingTyping.Add_Click({
    Start-Process "ms-settings:privacy-speechtyping"
    Log-Action "Opened 'Inking & typing'"
})

# Location
$buttonLocation = New-Object System.Windows.Controls.Button
$buttonLocation.Content = "Location"
$buttonLocation.Add_Click({
    Start-Process "ms-settings:privacy-location"
    Log-Action "Opened 'Location'"
})

# Messaging
$buttonMessaging = New-Object System.Windows.Controls.Button
$buttonMessaging.Content = "Messaging"
$buttonMessaging.Add_Click({
    Start-Process "ms-settings:privacy-messaging"
    Log-Action "Opened 'Messaging'"
})

# Microphone
$buttonMicrophone = New-Object System.Windows.Controls.Button
$buttonMicrophone.Content = "Microphone"
$buttonMicrophone.Add_Click({
    Start-Process "ms-settings:privacy-microphone"
    Log-Action "Opened 'Microphone'"
})

# Motion
$buttonMotion = New-Object System.Windows.Controls.Button
$buttonMotion.Content = "Motion"
$buttonMotion.Add_Click({
    Start-Process "ms-settings:privacy-motion"
    Log-Action "Opened 'Motion'"
})

# Music Library
$buttonMusicLibrary = New-Object System.Windows.Controls.Button
$buttonMusicLibrary.Content = "Music Library"
$buttonMusicLibrary.Add_Click({
    Start-Process "ms-settings:privacy-musiclibrary"
    Log-Action "Opened 'Music Library'"
})

# Notifications
$buttonNotifications = New-Object System.Windows.Controls.Button
$buttonNotifications.Content = "Notifications"
$buttonNotifications.Add_Click({
    Start-Process "ms-settings:privacy-notifications"
    Log-Action "Opened 'Notifications'"
})

# Other devices
$buttonOtherDevices = New-Object System.Windows.Controls.Button
$buttonOtherDevices.Content = "Other devices"
$buttonOtherDevices.Add_Click({
    Start-Process "ms-settings:privacy-customdevices"
    Log-Action "Opened 'Other devices'"
})

# Phone calls
$buttonPhoneCalls = New-Object System.Windows.Controls.Button
$buttonPhoneCalls.Content = "Phone calls"
$buttonPhoneCalls.Add_Click({
    Start-Process "ms-settings:privacy-phonecalls"
    Log-Action "Opened 'Phone calls'"
})

# Pictures
$buttonPictures = New-Object System.Windows.Controls.Button
$buttonPictures.Content = "Pictures"
$buttonPictures.Add_Click({
    Start-Process "ms-settings:privacy-pictures"
    Log-Action "Opened 'Pictures'"
})

# Radios
$buttonRadios = New-Object System.Windows.Controls.Button
$buttonRadios.Content = "Radios"
$buttonRadios.Add_Click({
    Start-Process "ms-settings:privacy-radios"
    Log-Action "Opened 'Radios'"
})

# Speech
$buttonSpeech = New-Object System.Windows.Controls.Button
$buttonSpeech.Content = "Speech"
$buttonSpeech.Add_Click({
    Start-Process "ms-settings:privacy-speech"
    Log-Action "Opened 'Speech'"
})

# Tasks
$buttonTasks = New-Object System.Windows.Controls.Button
$buttonTasks.Content = "Tasks"
$buttonTasks.Add_Click({
    Start-Process "ms-settings:privacy-tasks"
    Log-Action "Opened 'Tasks'"
})

# Videos
$buttonVideos = New-Object System.Windows.Controls.Button
$buttonVideos.Content = "Videos"
$buttonVideos.Add_Click({
    Start-Process "ms-settings:privacy-videos"
    Log-Action "Opened 'Videos'"
})

# Voice activation
$buttonVoiceActivation = New-Object System.Windows.Controls.Button
$buttonVoiceActivation.Content = "Voice activation"
$buttonVoiceActivation.Add_Click({
    Start-Process "ms-settings:privacy-voiceactivation"
    Log-Action "Opened 'Voice activation'"
})

# Collect buttons in order to add to grid
$buttons = @(
    $buttonAccountInfo,
    $buttonActivityHistory,
    $buttonAppDiagnostics,
    $buttonAutomaticFileDownloads,
    $buttonBackgroundSpatial,
    $buttonCalendar,
    $buttonCallHistory,
    $buttonCamera,
    $buttonContacts,
    $buttonDocuments,
    $buttonDownloadsFolder,
    $buttonEmail,
    $buttonEyeTracker,
    $buttonFeedbackDiagnostics,
    $buttonFileSystem,
    $buttonGeneral,
    $buttonGraphicsWithBorder,
    $buttonGraphicsWithoutBorder,
    $buttonInkingTyping,
    $buttonLocation,
    $buttonMessaging,
    $buttonMicrophone,
    $buttonMotion,
    $buttonMusicLibrary,
    $buttonNotifications,
    $buttonOtherDevices,
    $buttonPhoneCalls,
    $buttonPictures,
    $buttonRadios,
    $buttonSpeech,
    $buttonTasks,
    $buttonVideos,
    $buttonVoiceActivation
)

# Calculate required rows for 3 columns
$rowsNeeded = [math]::Ceiling($buttons.Count / 3)

# Add rows to grid
for ($i = 0; $i -lt $rowsNeeded; $i++) {
    $rowDef = New-Object System.Windows.Controls.RowDefinition
    $rowDef.Height = [System.Windows.GridLength]::Auto
    $gridButtons.RowDefinitions.Add($rowDef)
}

# Add buttons to grid at calculated row and column
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
