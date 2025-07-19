<#
.SYNOPSIS
    Tests internet connectivity using ping and shows results with a GUI progress bar.

.DESCRIPTION
    This script sends ICMP requests to a reliable host (google.com), evaluates average latency, and shows results.
    If the average response time exceeds 40ms, a warning is displayed indicating that the internet is super slow.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-19
    Version     : 1.0

.VERSION
    1.1.0
#>

# Load necessary assembly for GUI elements
Add-Type -AssemblyName System.Windows.Forms

function Show-MessageBox {
    param (
        [string]$Text,
        [string]$Title = "Internet Test"
    )
    [System.Windows.Forms.MessageBox]::Show($Text, $Title,
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information)
}

function Update-UI {
    [System.Windows.Forms.Application]::DoEvents()
}

try {
    # Setup form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Internet Connectivity Test"
    $form.Size = New-Object System.Drawing.Size(450, 150)
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = 'FixedDialog'
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.Topmost = $true

    # Add status label
    $statusLabel = New-Object System.Windows.Forms.Label
    $statusLabel.Text = "Starting test..."
    $statusLabel.AutoSize = $false
    $statusLabel.Width = 400
    $statusLabel.Height = 20
    $statusLabel.Location = New-Object System.Drawing.Point(20, 15)
    $statusLabel.TextAlign = 'MiddleCenter'
    $form.Controls.Add($statusLabel)

    # Add progress bar
    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Minimum = 0
    $progressBar.Maximum = 100
    $progressBar.Value = 0
    $progressBar.Style = 'Continuous'
    $progressBar.Size = New-Object System.Drawing.Size(400, 30)
    $progressBar.Location = New-Object System.Drawing.Point(20, 40)
    $form.Controls.Add($progressBar)

    # Show form
    $form.Show()
    Update-UI

    # Simulated start progress
    for ($i = 0; $i -le 20; $i += 5) {
        $progressBar.Value = $i
        $statusLabel.Text = "Initializing... $i%"
        Update-UI
        Start-Sleep -Milliseconds 100
    }

    # Begin pinging
    $targetHost = "google.com"
    $statusLabel.Text = "Pinging $targetHost..."
    $progressBar.Value = 30
    Update-UI

    $pings = Test-Connection -ComputerName $targetHost -Count 10 -ErrorAction Stop

    # Update UI
    $progressBar.Value = 60
    $statusLabel.Text = "Analyzing results..."
    Update-UI

    # Process ping results
    $grouped = $pings | Group-Object -Property Address
    $connectionStatus = ""
    $message = "Internet Connectivity Test Results:`n`n"
    $isSlow = $false

    foreach ($group in $grouped) {
        $ip = $group.Name
        $responses = $group.Group
        $sent = $responses.Count
        $received = $responses | Where-Object { $_.StatusCode -eq 0 } | Measure-Object | Select-Object -ExpandProperty Count
        $lost = $sent - $received
        $lossPercent = [math]::Round(($lost / $sent) * 100, 2)
        $avgRTT = [math]::Round(($responses | Measure-Object -Property ResponseTime -Average).Average, 2)

        # If average response time exceeds 40ms, consider it slow
        if ($avgRTT -gt 40) {
            $isSlow = $true
        }

        $message += @"
Target Host       : $targetHost
Resolved IP       : $ip
Packets Sent      : $sent
Packets Received  : $received
Packets Lost      : $lost
Packet Loss       : $lossPercent%
Average Latency   : $avgRTT ms
"@
        $message += "`n-------------------------------------------`n"
    }

    # Close progress form
    $progressBar.Value = 100
    $statusLabel.Text = "Test complete"
    Update-UI
    Start-Sleep -Seconds 1
    $form.Close()

    # Show warning if slow
    if ($isSlow) {
        Show-MessageBox -Text "Internet is super slow (latency > 40ms).`nPlease reach out to your provider as soon as possible." -Title "Performance Warning"
    } else {
        Show-MessageBox -Text $message -Title "Internet Test Results"
    }
}
catch {
    if ($form -and $form.Visible) { $form.Close() }
    Show-MessageBox -Text "Failed to reach $targetHost.`nError: $($_.Exception.Message)" -Title "Connection Error"
}
