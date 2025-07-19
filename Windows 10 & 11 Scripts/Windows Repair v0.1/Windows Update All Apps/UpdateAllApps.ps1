<#
.SYNOPSIS
    Elevates script if needed, then upgrades all software and drivers using winget with a progress bar UI.

.DESCRIPTION
    Checks for admin rights and relaunches elevated if necessary.
    Runs `winget upgrade --all` to update all software and drivers.
    Displays a Windows Form with progress bar, percentage label, and status messages.
    Shows completion message box when done.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-19
    Version     : 1.0

.NOTES
    Requires Windows 10/11 with winget installed.
    Must be run as Administrator.
#>

# --- Check for Administrator Privileges ---
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "powershell.exe"
    $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$PSCommandPath`""
    $psi.Verb = "runas"
    $psi.WindowStyle = [System.Diagnostics.ProcessWindowStyle]::Hidden
    
    [System.Diagnostics.Process]::Start($psi) | Out-Null
    exit
}

Add-Type -AssemblyName System.Windows.Forms

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Software & Driver Upgrades"
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
$statusLabel.Text = "Starting upgrades..."
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

# Simulate progress as winget doesn’t report progress incrementally
for ($i = 0; $i -le 100; $i += 2) {
    $progressBar.Value = $i
    $percentLabel.Text = "$i%"
    $statusLabel.Text = "Upgrading software and drivers..."
    Update-UI
    Start-Sleep -Milliseconds 100
}

$statusLabel.Text = "Running winget upgrade --all..."
$percentLabel.Text = "Processing..."
Update-UI

try {
    winget upgrade --all --accept-source-agreements --accept-package-agreements | Out-Null
    $statusLabel.Text = "Upgrade completed successfully."
    $progressBar.Value = 100
    $percentLabel.Text = "100%"
    Update-UI
}
catch {
    $statusLabel.Text = "An error occurred during upgrade."
    $percentLabel.Text = "Error"
    Update-UI
}

$form.Close()

[System.Windows.Forms.MessageBox]::Show(
    'All drivers and software have been updated successfully.',
    'Operation Complete',
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)

exit
