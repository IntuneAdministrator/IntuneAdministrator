<#
.SYNOPSIS
    WASAPI Audio Endpoint Management Dashboard for Windows 11 24H2.

.DESCRIPTION
    Provides a WPF GUI with buttons for common WASAPI audio endpoint tasks:
    - Open Volume Mixer (App Volume & Device Preferences)
    - Open Sound Settings
    - Open Microphone Privacy Settings
    - Open Classic Sound Control Panel
    - Open Sound Playback Devices
    - Restart AudioEndpointBuilder Service with progress and notification

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-20
    Version     : 1.0

.NOTES
    Requires PowerShell 5.1+, Windows 11 24H2 or later.
    Admin rights needed for restarting service.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Log-Action {
    param ([string]$message)
    $logName = "Application"
    $source = "PowerShell - WASAPI Audio Dashboard"

    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try { New-EventLog -LogName $logName -Source $source } catch {}
    }

    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message $message
}

function Restart-WASAPIService {
    # Admin check
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
        [Security.Principal.WindowsBuiltInRole] "Administrator")) {
        [System.Windows.Forms.MessageBox]::Show(
            "This action requires Administrator privileges.",
            "Insufficient Privileges",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning)
        return
    }

    # Create restart progress form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "WASAPI Service Restart"
    $form.Size = New-Object System.Drawing.Size(450, 180)
    $form.StartPosition = "CenterScreen"
    $form.Topmost = $true
    $form.FormBorderStyle = 'FixedDialog'
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false

    $percentLabel = New-Object System.Windows.Forms.Label
    $percentLabel.Size = New-Object System.Drawing.Size(400,20)
    $percentLabel.Location = New-Object System.Drawing.Point(20,15)
    $percentLabel.TextAlign = 'MiddleCenter'
    $percentLabel.Text = "0%"
    $form.Controls.Add($percentLabel)

    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Minimum = 0
    $progressBar.Maximum = 100
    $progressBar.Style = 'Continuous'
    $progressBar.Size = New-Object System.Drawing.Size(400,30)
    $progressBar.Location = New-Object System.Drawing.Point(20,40)
    $form.Controls.Add($progressBar)

    $statusLabel = New-Object System.Windows.Forms.Label
    $statusLabel.Size = New-Object System.Drawing.Size(400,20)
    $statusLabel.Location = New-Object System.Drawing.Point(20,80)
    $statusLabel.TextAlign = 'MiddleCenter'
    $statusLabel.Text = "Preparing to restart WASAPI service..."
    $form.Controls.Add($statusLabel)

    $infoLabel = New-Object System.Windows.Forms.Label
    $infoLabel.Size = New-Object System.Drawing.Size(400,30)
    $infoLabel.Location = New-Object System.Drawing.Point(20,110)
    $infoLabel.TextAlign = 'MiddleCenter'
    $infoLabel.ForeColor = [System.Drawing.Color]::DarkRed
    $infoLabel.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Italic)
    $infoLabel.Text = "Note: This process can take a few seconds. Please wait."
    $form.Controls.Add($infoLabel)

    function Update-UI { [System.Windows.Forms.Application]::DoEvents() }

    $form.Show()
    Update-UI

    for ($i = 0; $i -le 50; $i += 10) {
        $progressBar.Value = $i
        $percentLabel.Text = "$i%"
        $statusLabel.Text = "Restarting WASAPI service... $i%"
        Update-UI
        Start-Sleep -Milliseconds 200
    }

    try {
        Restart-Service -Name "AudioEndpointBuilder" -Force -ErrorAction Stop
    } catch {
        $statusLabel.Text = "Failed to restart WASAPI service."
        $percentLabel.Text = "Error"
        Update-UI
        Start-Sleep -Seconds 2
        $form.Close()
        [System.Windows.Forms.MessageBox]::Show(
            "Failed to restart WASAPI service:`n$_",
            "Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    for ($i = 60; $i -le 100; $i += 10) {
        $progressBar.Value = $i
        $percentLabel.Text = "$i%"
        $statusLabel.Text = "WASAPI service restarted... $i%"
        Update-UI
        Start-Sleep -Milliseconds 200
    }

    $statusLabel.Text = "WASAPI service restarted successfully."
    $percentLabel.Text = "100%"
    Update-UI
    Start-Sleep -Seconds 1

    $form.Close()

    [System.Windows.Forms.MessageBox]::Show(
        "WASAPI service restarted successfully.",
        "WASAPI Restart",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
}

# Create main window
$window = New-Object System.Windows.Window
$window.Title = "WASAPI Audio Endpoint Management Dashboard"
$window.Width = 420
$window.Height = 420
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen

# Main StackPanel
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $stackPanel

# Header
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "WASAPI Audio Endpoint Management Dashboard"
$textBlockHeader.FontSize = 16
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$stackPanel.Children.Add($textBlockHeader)

# Button: Volume Mixer (App volume & device prefs)
$buttonVolumeMixer = New-Object System.Windows.Controls.Button
$buttonVolumeMixer.Content = "Open Volume Mixer (App Volume & Device Preferences)"
$buttonVolumeMixer.Width = 380
$buttonVolumeMixer.Margin = [System.Windows.Thickness]::new(10)
$buttonVolumeMixer.Add_Click({
    Start-Process "ms-settings:apps-volume"
    Log-Action "Opened Volume Mixer (App Volume & Device Preferences)"
})
$stackPanel.Children.Add($buttonVolumeMixer)

# Button: Sound Settings
$buttonSoundSettings = New-Object System.Windows.Controls.Button
$buttonSoundSettings.Content = "Open Sound Settings"
$buttonSoundSettings.Width = 380
$buttonSoundSettings.Margin = [System.Windows.Thickness]::new(10)
$buttonSoundSettings.Add_Click({
    Start-Process "ms-settings:sound"
    Log-Action "Opened Sound Settings"
})
$stackPanel.Children.Add($buttonSoundSettings)

# Button: Microphone Privacy Settings
$buttonMicrophone = New-Object System.Windows.Controls.Button
$buttonMicrophone.Content = "Open Microphone Privacy Settings"
$buttonMicrophone.Width = 380
$buttonMicrophone.Margin = [System.Windows.Thickness]::new(10)
$buttonMicrophone.Add_Click({
    Start-Process "ms-settings:privacy-microphone"
    Log-Action "Opened Microphone Privacy Settings"
})
$stackPanel.Children.Add($buttonMicrophone)

# Button: Classic Sound Control Panel (mmsys.cpl)
$buttonSoundControlPanel = New-Object System.Windows.Controls.Button
$buttonSoundControlPanel.Content = "Open Classic Sound Control Panel"
$buttonSoundControlPanel.Width = 380
$buttonSoundControlPanel.Margin = [System.Windows.Thickness]::new(10)
$buttonSoundControlPanel.Add_Click({
    Start-Process "mmsys.cpl"
    Log-Action "Opened Classic Sound Control Panel"
})
$stackPanel.Children.Add($buttonSoundControlPanel)

# Button: Playback Devices (sndvol.exe)
$buttonPlaybackDevices = New-Object System.Windows.Controls.Button
$buttonPlaybackDevices.Content = "Open Playback Devices (Classic Volume Mixer)"
$buttonPlaybackDevices.Width = 380
$buttonPlaybackDevices.Margin = [System.Windows.Thickness]::new(10)
$buttonPlaybackDevices.Add_Click({
    Start-Process "sndvol.exe"
    Log-Action "Opened Playback Devices (Classic Volume Mixer)"
})
$stackPanel.Children.Add($buttonPlaybackDevices)

# Button: Restart WASAPI AudioEndpointBuilder Service
$buttonRestartWASAPI = New-Object System.Windows.Controls.Button
$buttonRestartWASAPI.Content = "Restart WASAPI AudioEndpointBuilder Service"
$buttonRestartWASAPI.Width = 380
$buttonRestartWASAPI.Margin = [System.Windows.Thickness]::new(10)
$buttonRestartWASAPI.Add_Click({
    Restart-WASAPIService
    Log-Action "Restarted WASAPI AudioEndpointBuilder Service"
})
$stackPanel.Children.Add($buttonRestartWASAPI)

# Footer
$textBlockFooter = New-Object System.Windows.Controls.TextBlock
$textBlockFooter.Text = "Allester Padovani, Senior IT Specialist. All rights reserved."
$textBlockFooter.FontSize = 12
$textBlockFooter.FontStyle = [System.Windows.FontStyles]::Italic
$textBlockFooter.Foreground = [System.Windows.Media.Brushes]::Black
$textBlockFooter.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$textBlockFooter.Margin = [System.Windows.Thickness]::new(0, 20, 0, 5)
$stackPanel.Children.Add($textBlockFooter)

# Show window
$window.ShowDialog()
