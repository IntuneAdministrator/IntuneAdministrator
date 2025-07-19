<#
.SYNOPSIS
    Force updates Group Policy with a progress bar UI and logs output.

.DESCRIPTION
    Runs 'gpupdate /force' to update Group Policy immediately.
    Displays a Windows Form with a progress bar, status messages, and a note on duration.
    Logs all output and shows a message box on completion.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-20
    Version     : 1.0

.NOTES
    Requires administrative privileges.
#>

Add-Type -AssemblyName System.Windows.Forms

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Group Policy Update"
$form.Size = New-Object System.Drawing.Size(450,160)
$form.StartPosition = "CenterScreen"
$form.Topmost = $true
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.MinimizeBox = $false

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
$statusLabel.Text = "Starting Group Policy update..."
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

# Define log paths
$logFolder = "C:\ProgramData\OzarkTechTeam\GPOUpdateLogs"
$logFile = Join-Path $logFolder "GPOUpdate_log.txt"

if (-not (Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory -Force | Out-Null
}

# Log start
"Starting Group Policy Update at $(Get-Date)" | Out-File -FilePath $logFile -Append

# Simulate progress because gpupdate output is not easily parsed for progress
$steps = 0..100

foreach ($i in $steps) {
    $progressBar.Value = $i
    $statusLabel.Text = "Updating Group Policy... $i%"
    Update-UI
    Start-Sleep -Milliseconds 80
}

# Run gpupdate /force and log output
$statusLabel.Text = "Running gpupdate /force..."
Update-UI
try {
    gpupdate /force | Out-File -FilePath $logFile -Append
    "Group Policy update completed successfully at $(Get-Date)" | Out-File -FilePath $logFile -Append
}
catch {
    "Error running gpupdate: $_" | Out-File -FilePath $logFile -Append
}

$form.Close()

# Show completion message
[System.Windows.Forms.MessageBox]::Show(
    "Group Policy has been updated successfully.",
    "Group Policy Update Status",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)

exit
