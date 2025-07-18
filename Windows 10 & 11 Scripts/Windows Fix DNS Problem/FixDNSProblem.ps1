<#
.SYNOPSIS
    Clears DNS server settings and sets Google Public DNS on all enabled network adapters, showing a progress bar UI.

.DESCRIPTION
    This script clears existing DNS server configurations on all enabled network adapters using WMI,
    sets the DNS servers to Google's public DNS addresses (8.8.8.8 and 8.8.4.4),
    shows a responsive Windows Forms progress bar,
    and prompts the user to restart the computer.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 2.0
    Date        : 2025-07-18

.NOTES
    Requires running with Administrator privileges.
    Compatible with Windows 11 24H2 and later.
    Uses .NET Framework for Windows Forms.
#>

# Load required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create form
$form = New-Object System.Windows.Forms.Form
$form.Text = "DNS Reset Progress"
$form.Size = New-Object System.Drawing.Size(450, 150)
$form.StartPosition = "CenterScreen"
$form.Topmost = $true
$form.FormBorderStyle = 'FixedDialog'

# Create progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Style = 'Continuous'
$progressBar.Minimum = 0
$progressBar.Maximum = 100
$progressBar.Value = 0
$progressBar.Size = New-Object System.Drawing.Size(400, 25)
$progressBar.Location = New-Object System.Drawing.Point(20, 30)
$form.Controls.Add($progressBar)

# Create status label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = "Starting DNS reset..."
$statusLabel.AutoSize = $true
$statusLabel.Location = New-Object System.Drawing.Point(20, 70)
$form.Controls.Add($statusLabel)

# Show the form
$form.Show()
[System.Windows.Forms.Application]::DoEvents()

# Define DNS servers to apply
$dnsServers = @("8.8.8.8", "8.8.4.4")

# Get enabled NICs
$adapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter "IPEnabled=TRUE"
$total = $adapters.Count
$count = 0

foreach ($adapter in $adapters) {
    try {
        $statusLabel.Text = "Clearing DNS for: $($adapter.Description)"
        [System.Windows.Forms.Application]::DoEvents()
        $adapter.SetDNSServerSearchOrder($null)
        Start-Sleep -Milliseconds 300

        $statusLabel.Text = "Setting Google DNS for: $($adapter.Description)"
        [System.Windows.Forms.Application]::DoEvents()
        $adapter.SetDNSServerSearchOrder($dnsServers)
        Start-Sleep -Milliseconds 300
    } catch {
        Write-Warning "Error with NIC $($adapter.Description): $($_.Exception.Message)"
    }

    $count++
    $percent = [math]::Round(($count / $total) * 100)
    $progressBar.Value = [math]::Min($percent, 100)
    $statusLabel.Text = "Completed $count of $total adapters..."
    [System.Windows.Forms.Application]::DoEvents()
}

$statusLabel.Text = "DNS reset complete."
$progressBar.Value = 100
[System.Windows.Forms.Application]::DoEvents()

# Wait briefly before closing
Start-Sleep -Seconds 1
$form.Close()

# Ask user if they want to restart
$result = [System.Windows.Forms.MessageBox]::Show(
    "Network settings have been reset successfully.`nDo you want to restart your computer now?",
    "Restart Required",
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Question,
    [System.Windows.Forms.MessageBoxDefaultButton]::Button1,
    [System.Windows.Forms.MessageBoxOptions]::DefaultDesktopOnly
)

# Restart or exit based on user response
if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
    shutdown /r /t 30 /c "Restart initiated by DNS reset script."
    Write-Host "Restarting system in 30 seconds..."
} else {
    Write-Host "Restart cancelled by user."
}
