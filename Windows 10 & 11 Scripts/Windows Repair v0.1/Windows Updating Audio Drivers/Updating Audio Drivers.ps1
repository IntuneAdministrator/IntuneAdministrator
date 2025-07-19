<#
.SYNOPSIS
    Updates audio drivers for all connected media devices with a progress bar UI and percentage display.

.DESCRIPTION
    Checks for administrator privileges.
    Retrieves all audio devices with status OK.
    Updates drivers for each device using pnputil.
    Shows progress bar and percentage during the update process.
    Provides user feedback via message boxes.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-20
    Version     : 1.0

.NOTES
    Requires to run as Administrator.
#>

Add-Type -AssemblyName System.Windows.Forms

# Check for Administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    [System.Windows.Forms.MessageBox]::Show(
        "This script must be run as Administrator.",
        "Insufficient Privileges",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Warning)
    exit
}

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Audio Drivers Update"
$form.Size = New-Object System.Drawing.Size(450,180)
$form.StartPosition = "CenterScreen"
$form.Topmost = $true
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.MinimizeBox = $false

# Percentage label (above progress bar)
$percentLabel = New-Object System.Windows.Forms.Label
$percentLabel.AutoSize = $false
$percentLabel.Width = 400
$percentLabel.Height = 20
$percentLabel.Location = New-Object System.Drawing.Point(20,15)
$percentLabel.TextAlign = 'MiddleCenter'
$percentLabel.Text = "0%"
$form.Controls.Add($percentLabel)

# Progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Minimum = 0
$progressBar.Maximum = 100
$progressBar.Style = 'Continuous'
$progressBar.Width = 400
$progressBar.Height = 30
$progressBar.Location = New-Object System.Drawing.Point(20,40)
$form.Controls.Add($progressBar)

# Status label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.AutoSize = $false
$statusLabel.Width = 400
$statusLabel.Height = 20
$statusLabel.Location = New-Object System.Drawing.Point(20,80)
$statusLabel.TextAlign = 'MiddleCenter'
$statusLabel.Text = "Starting audio drivers update..."
$form.Controls.Add($statusLabel)

# Info label
$infoLabel = New-Object System.Windows.Forms.Label
$infoLabel.AutoSize = $false
$infoLabel.Width = 400
$infoLabel.Height = 30
$infoLabel.Location = New-Object System.Drawing.Point(20,110)
$infoLabel.TextAlign = 'MiddleCenter'
$infoLabel.ForeColor = [System.Drawing.Color]::DarkRed
$infoLabel.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Italic)
$infoLabel.Text = "Note: This process can take several minutes. Please be patient."
$form.Controls.Add($infoLabel)

function Update-UI {
    [System.Windows.Forms.Application]::DoEvents()
}

$form.Show()
Update-UI

# Get all audio devices with status OK
$audioDevices = Get-PnpDevice -Class Media -Status OK

if ($audioDevices.Count -eq 0) {
    $statusLabel.Text = "No audio devices found to update."
    $percentLabel.Text = "0%"
    Update-UI
    Start-Sleep -Seconds 2
    $form.Close()
    [System.Windows.Forms.MessageBox]::Show(
        "No audio devices found with status OK.",
        "No Devices",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information)
    exit
}

$total = $audioDevices.Count
$counter = 0

foreach ($device in $audioDevices) {
    $counter++
    $percent = [math]::Round(($counter / $total) * 100)
    $progressBar.Value = $percent
    $percentLabel.Text = "$percent%"
    $statusLabel.Text = "Updating audio driver $counter of $total..."
    Update-UI

    try {
        pnputil /update-driver $device.InstanceId /install | Out-Null
    }
    catch {
        # Optionally log or handle errors here
    }
}

$progressBar.Value = 100
$percentLabel.Text = "100%"
$statusLabel.Text = "Audio drivers update process completed."
Update-UI
Start-Sleep -Seconds 1

$form.Close()

[System.Windows.Forms.MessageBox]::Show(
    "Audio drivers update process completed.",
    "Audio Drivers Update",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information)

exit
