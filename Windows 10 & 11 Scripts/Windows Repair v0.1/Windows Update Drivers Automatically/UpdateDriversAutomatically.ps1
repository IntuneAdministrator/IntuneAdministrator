<#
.SYNOPSIS
    Checks for Windows updates including drivers, with UI progress bar and messages.

.DESCRIPTION
    Requires administrator rights.
    Loads PSWindowsUpdate module (installs if missing).
    Lists available updates and asks user confirmation.
    Shows progress bar with percentage during update installation.
    Displays message boxes for status and errors.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-20
    Version     : 1.0

.NOTES
    Run as Administrator.
    Requires internet connection.
#>

Add-Type -AssemblyName System.Windows.Forms

function Update-UI {
    [System.Windows.Forms.Application]::DoEvents()
}

# Check Admin Rights
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    [System.Windows.Forms.MessageBox]::Show("This script must be run as Administrator.","Insufficient Privileges",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Warning)
    exit
}

# Create UI form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows Update"
$form.Size = New-Object System.Drawing.Size(480,200)
$form.StartPosition = "CenterScreen"
$form.Topmost = $true
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.MinimizeBox = $false

# Percentage label (above progress bar)
$percentLabel = New-Object System.Windows.Forms.Label
$percentLabel.AutoSize = $false
$percentLabel.Width = 420
$percentLabel.Height = 20
$percentLabel.Location = New-Object System.Drawing.Point(25,25)
$percentLabel.TextAlign = 'MiddleCenter'
$percentLabel.Text = "0%"
$form.Controls.Add($percentLabel)

# Progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Minimum = 0
$progressBar.Maximum = 100
$progressBar.Style = 'Continuous'
$progressBar.Width = 420
$progressBar.Height = 30
$progressBar.Location = New-Object System.Drawing.Point(25,50)
$form.Controls.Add($progressBar)

# Status label (below progress bar)
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.AutoSize = $false
$statusLabel.Width = 420
$statusLabel.Height = 20
$statusLabel.Location = New-Object System.Drawing.Point(25,90)
$statusLabel.TextAlign = 'MiddleCenter'
$statusLabel.Text = "Preparing to check for updates..."
$form.Controls.Add($statusLabel)

# Info label (bottom)
$infoLabel = New-Object System.Windows.Forms.Label
$infoLabel.AutoSize = $false
$infoLabel.Width = 420
$infoLabel.Height = 30
$infoLabel.Location = New-Object System.Drawing.Point(25,120)
$infoLabel.TextAlign = 'MiddleCenter'
$infoLabel.ForeColor = [System.Drawing.Color]::DarkRed
$infoLabel.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Italic)
$infoLabel.Text = "Note: This process can take several minutes. Please be patient."
$form.Controls.Add($infoLabel)

$form.Show()
Update-UI

try {
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force
    $statusLabel.Text = "Checking for PSWindowsUpdate module..."
    Update-UI

    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        $statusLabel.Text = "Installing PSWindowsUpdate module..."
        Update-UI
        Install-Module -Name PSWindowsUpdate -Force -Confirm:$false
    }

    Import-Module PSWindowsUpdate

    $statusLabel.Text = "Checking for available updates..."
    Update-UI

    $updates = Get-WindowsUpdate -AcceptAll -IgnoreReboot

    if ($updates) {
        $titles = $updates | ForEach-Object { $_.Title }
        $message = "The following updates will be installed:`n`n" + ($titles -join "`n") + "`n`nClick OK to start installation."

        $form.Close()
        $response = [System.Windows.Forms.MessageBox]::Show($message, "Updates Found",
            [System.Windows.Forms.MessageBoxButtons]::OKCancel,
            [System.Windows.Forms.MessageBoxIcon]::Information)

        if ($response -eq [System.Windows.Forms.DialogResult]::OK) {
            # Show form again for installation progress
            $form.Show()
            $statusLabel.Text = "Installing updates..."
            $progressBar.Value = 0
            $percentLabel.Text = "0%"
            Update-UI

            # Start install job async
            $job = Start-Job -ScriptBlock {
                Import-Module PSWindowsUpdate
                Install-WindowsUpdate -AcceptAll -IgnoreReboot -Verbose -Confirm:$false | Out-Null
            }

            # Loop to update progress while job runs
            while (-not $job.HasExited) {
                for ($i=0; $i -le 100; $i += 2) {
                    if ($job.HasExited) { break }
                    $progressBar.Value = $i
                    $percentLabel.Text = "$i%"
                    $statusLabel.Text = "Installing updates..."
                    Update-UI
                    Start-Sleep -Milliseconds 300
                }
            }
            # Ensure progress bar is full at the end
            $progressBar.Value = 100
            $percentLabel.Text = "100%"
            $statusLabel.Text = "Installation complete."
            Update-UI

            # Cleanup job
            Remove-Job -Job $job -Force

            $form.Close()
            [System.Windows.Forms.MessageBox]::Show(
                "Updates have been installed successfully.`nPlease restart your computer to complete the update process.",
                "Update Complete",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Information)
        }
        else {
            $form.Close()
            [System.Windows.Forms.MessageBox]::Show(
                "Update installation was cancelled by the user.",
                "Update Cancelled",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Warning)
        }
    }
    else {
        $form.Close()
        [System.Windows.Forms.MessageBox]::Show(
            "No updates are currently available. Your system is up to date.",
            "No Updates",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information)
    }
}
catch {
    $form.Close()
    [System.Windows.Forms.MessageBox]::Show(
        "An error occurred during the update process:`n$($_.Exception.Message)",
        "Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error)
}
exit
