<#
.SYNOPSIS
    Repairs system files and Windows corruption issues using DISM and SFC with a progress bar UI.

.DESCRIPTION
    Runs DISM commands to check, scan, and restore system image health, then runs SFC to verify and repair system files.
    Displays a responsive Windows Form with progress updates and logs each step to files.
    Shows message boxes upon completion of DISM and SFC.
    Informs the user that this process can take about 30 minutes.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-19
    Version     : 1.0

.NOTES
    Requires administrative privileges.
    Tested on Windows 10/11.
#>

Add-Type -AssemblyName System.Windows.Forms

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "System Repair in Progress"
$form.Size = New-Object System.Drawing.Size(450,180)
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

# Status label (shows current step and percentage)
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.AutoSize = $false
$statusLabel.Width = 400
$statusLabel.Height = 20
$statusLabel.Location = New-Object System.Drawing.Point(20,80)
$statusLabel.TextAlign = 'MiddleCenter'
$statusLabel.Text = "Starting system repair..."
$form.Controls.Add($statusLabel)

# Info label (static message about process duration)
$infoLabel = New-Object System.Windows.Forms.Label
$infoLabel.AutoSize = $false
$infoLabel.Width = 400
$infoLabel.Height = 30
$infoLabel.Location = New-Object System.Drawing.Point(20,110)
$infoLabel.TextAlign = 'MiddleCenter'
$infoLabel.ForeColor = [System.Drawing.Color]::DarkRed
$infoLabel.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Italic)
$infoLabel.Text = "Note: This process can take up to 30 minutes. Please be patient."
$form.Controls.Add($infoLabel)

function Update-UI {
    [System.Windows.Forms.Application]::DoEvents()
}

$form.Show()
Update-UI

# DISM log paths
$dismLogFolder = "C:\ProgramData\OzarkTechTeam\DISM tool Logs"
$dismLogFile = Join-Path $dismLogFolder "DISM_log.txt"

if (-not (Test-Path $dismLogFolder)) {
    New-Item -Path $dismLogFolder -ItemType Directory -Force | Out-Null
}

# SFC log paths
$sfcLogFolder = "C:\ProgramData\OzarkTechTeam\SFC Logs"
$sfcLogFile = Join-Path $sfcLogFolder "SFC_log.txt"

if (-not (Test-Path $sfcLogFolder)) {
    New-Item -Path $sfcLogFolder -ItemType Directory -Force | Out-Null
}

# DISM steps with progress %
$dismSteps = @(
    @{ Description = "Checking image health (DISM)..."; Cmd = { DISM /Online /Cleanup-Image /CheckHealth | Out-File -FilePath $dismLogFile -Append }; Progress = 30 },
    @{ Description = "Scanning image health (DISM)..."; Cmd = { DISM /Online /Cleanup-Image /ScanHealth | Out-File -FilePath $dismLogFile -Append }; Progress = 60 },
    @{ Description = "Restoring image health (DISM)..."; Cmd = { DISM /Online /Cleanup-Image /RestoreHealth | Out-File -FilePath $dismLogFile -Append }; Progress = 100 }
)

# Log DISM start
"Starting DISM tool at $(Get-Date)" | Out-File -FilePath $dismLogFile -Append

foreach ($step in $dismSteps) {
    $statusLabel.Text = "{0} {1}%" -f $step.Description, $step.Progress
    $progressBar.Value = $step.Progress
    Update-UI
    try {
        & $step.Cmd
        "$($step.Description) succeeded at $(Get-Date)" | Out-File -FilePath $dismLogFile -Append
    }
    catch {
        "Error during $($step.Description): $_" | Out-File -FilePath $dismLogFile -Append
    }
}

"DISM process completed at $(Get-Date)`r`n" | Out-File -FilePath $dismLogFile -Append

$form.Close()

[System.Windows.Forms.MessageBox]::Show(
    "DISM process completed successfully.",
    "DISM Status",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)

# Show form again for SFC
$form.Show()
$statusLabel.Text = "Starting System File Checker (SFC)..."
$progressBar.Value = 0
Update-UI

# Log SFC start
"Starting SFC at $(Get-Date)" | Out-File -FilePath $sfcLogFile -Append

try {
    $statusLabel.Text = "Running System File Checker (SFC)... 50%"
    $progressBar.Value = 50
    Update-UI
    sfc /scannow | Out-File -FilePath $sfcLogFile -Append
    "SFC scan completed at $(Get-Date)" | Out-File -FilePath $sfcLogFile -Append
    $progressBar.Value = 100
    $statusLabel.Text = "System File Checker (SFC) completed. 100%"
    Update-UI
}
catch {
    "Error during SFC scan: $_" | Out-File -FilePath $sfcLogFile -Append
}

$form.Close()

[System.Windows.Forms.MessageBox]::Show(
    "System File Checker scan completed successfully.",
    "SFC Status",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)

exit
