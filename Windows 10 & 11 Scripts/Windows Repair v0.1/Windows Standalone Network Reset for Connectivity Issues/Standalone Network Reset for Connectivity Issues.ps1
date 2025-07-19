<#
.SYNOPSIS
    Resets network settings to resolve common connectivity issues with a progress bar UI.

.DESCRIPTION
    The script releases/renews IP, flushes DNS cache, resets Winsock and TCP/IP stack.
    It shows a responsive Windows Form with a progress bar and status updates during the process.
    Logs each step to a file and shows completion message.

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
$form.Text = "Network Reset in Progress"
$form.Size = New-Object System.Drawing.Size(400,150)
$form.StartPosition = "CenterScreen"
$form.Topmost = $true
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.MinimizeBox = $false

# Create progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Minimum = 0
$progressBar.Maximum = 100
$progressBar.Style = 'Continuous'
$progressBar.Width = 350
$progressBar.Height = 30
$progressBar.Location = New-Object System.Drawing.Point(20,40)
$form.Controls.Add($progressBar)

# Create status label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.AutoSize = $false
$statusLabel.Width = 350
$statusLabel.Height = 20
$statusLabel.Location = New-Object System.Drawing.Point(20,80)
$statusLabel.TextAlign = 'MiddleCenter'
$statusLabel.Text = "Starting network reset..."
$form.Controls.Add($statusLabel)

function Update-UI {
    [System.Windows.Forms.Application]::DoEvents()
}

$form.Show()
Update-UI

# Define log folder and file
$logFolder = "C:\ProgramData\OzarkTechTeam\NetworkReset Logs"
$logFile = Join-Path $logFolder "NetworkReset_log.txt"

if (-not (Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory -Force | Out-Null
}

# Steps with descriptions and scriptblocks
$steps = @(
    @{ Description = "Releasing IP address..."; Action = { ipconfig /release | Out-File -FilePath $logFile -Append } ; Progress=15 },
    @{ Description = "Renewing IP address..."; Action = { ipconfig /renew | Out-File -FilePath $logFile -Append } ; Progress=30 },
    @{ Description = "Flushing DNS cache..."; Action = { ipconfig /flushdns | Out-File -FilePath $logFile -Append } ; Progress=50 },
    @{ Description = "Resetting Winsock..."; Action = { netsh winsock reset | Out-File -FilePath $logFile -Append } ; Progress=75 },
    @{ Description = "Resetting TCP/IP stack..."; Action = { netsh int ip reset | Out-File -FilePath $logFile -Append } ; Progress=95 },
    @{ Description = "Finalizing..."; Action = { Start-Sleep -Seconds 2 } ; Progress=100 }
)

# Start logging
"Starting Network Reset at $(Get-Date)" | Out-File -FilePath $logFile -Append

foreach ($step in $steps) {
    $statusLabel.Text = $step.Description
    $progressBar.Value = $step.Progress
    Update-UI
    try {
        & $step.Action
        "$($step.Description) Success at $(Get-Date)" | Out-File -FilePath $logFile -Append
    }
    catch {
        "Error during $($step.Description) : $_" | Out-File -FilePath $logFile -Append
    }
}

"Network reset completed at $(Get-Date)`r`n" | Out-File -FilePath $logFile -Append

$form.Close()

# Show completion message
[System.Windows.Forms.MessageBox]::Show(
    "Network reset completed successfully.",
    "Network Reset Status",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)

exit
