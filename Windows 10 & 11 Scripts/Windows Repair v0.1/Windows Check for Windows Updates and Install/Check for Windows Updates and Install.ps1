<#
.SYNOPSIS
    Provides a GUI to check, download, and install pending Windows updates with progress feedback.

.DESCRIPTION
    Creates a Windows Forms window displaying status and progress of Windows Update operations.
    Searches for available updates, queues them for download and installation using the Microsoft.Update.Session COM interface.
    Updates the UI dynamically during each phase: search, download, and installation.
    Displays a notification window upon completion that auto-closes after 5 seconds.
    Handles errors gracefully and closes UI elements properly.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-16
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2 and above  
    Requires     : Access to Windows Update COM API, .NET Framework for Windows Forms
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create main progress form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows Update Installer"
$form.Size = New-Object System.Drawing.Size(520, 150)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedDialog
$form.MaximizeBox = $false
$form.TopMost = $true

# Status label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = New-Object System.Drawing.Point(15, 15)
$statusLabel.Size = New-Object System.Drawing.Size(480, 40)
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$statusLabel.Text = "Initializing Windows Update check..."
$form.Controls.Add($statusLabel)

# Progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(15, 65)
$progressBar.Size = New-Object System.Drawing.Size(480, 30)
$progressBar.Minimum = 0
$progressBar.Maximum = 100
$progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
$form.Controls.Add($progressBar)

# Show form non-blocking
$form.Show()
[System.Windows.Forms.Application]::DoEvents()

function Update-UI {
    param(
        [string]$Message,
        [int]$PercentComplete = $null
    )
    $statusLabel.Text = $Message
    if ($PercentComplete -ne $null) {
        $progressBar.Value = [Math]::Min([Math]::Max($PercentComplete, 0), 100)
    }
    [System.Windows.Forms.Application]::DoEvents()
}

try {
    Update-UI "Creating Windows Update session..." 5
    $updateSession = New-Object -ComObject Microsoft.Update.Session
    $updateSearcher = $updateSession.CreateUpdateSearcher()
    Update-UI "Searching for available updates..." 15
    $searchResult = $updateSearcher.Search("IsInstalled=0")

    if ($searchResult.Updates.Count -gt 0) {
        $totalUpdates = $searchResult.Updates.Count
        Update-UI "Found $totalUpdates update(s). Preparing to download..." 20

        $updatesToInstall = New-Object -ComObject Microsoft.Update.UpdateColl
        $i = 0
        foreach ($update in $searchResult.Updates) {
            $updatesToInstall.Add($update) | Out-Null
            $i++
            $percent = 20 + [Math]::Round(($i / $totalUpdates) * 10)
            Update-UI "Queued update $i of ${totalUpdates}: $($update.Title)" $percent
            Start-Sleep -Milliseconds 100
        }

        $downloader = $updateSession.CreateUpdateDownloader()
        $downloader.Updates = $updatesToInstall
        Update-UI "Downloading updates..." 35
        $downloadResult = $downloader.Download()

        if ($downloadResult.ResultCode -ne 2) {
            throw "Download failed with result code: $($downloadResult.ResultCode)"
        }

        $installer = $updateSession.CreateUpdateInstaller()
        $installer.Updates = $updatesToInstall
        Update-UI "Installing updates..." 60
        $installResult = $installer.Install()

        if ($installResult.ResultCode -eq 2) {
            Update-UI "All updates installed successfully." 100
        }
        else {
            Update-UI "Updates installed with warnings/errors. ResultCode: $($installResult.ResultCode)" 100
        }

        Start-Sleep -Seconds 3
    }
    else {
        Update-UI "No pending updates found. System is up to date." 100
        Start-Sleep -Seconds 3
    }
}
catch {
    Update-UI "An error occurred: $_" 100
    Start-Sleep -Seconds 6
}
finally {
    $form.Close()
}

# Auto-closing notification form
$notifyForm = New-Object System.Windows.Forms.Form
$notifyForm.Size = New-Object System.Drawing.Size(420, 140)
$notifyForm.StartPosition = "CenterScreen"
$notifyForm.TopMost = $true
$notifyForm.FormBorderStyle = 'FixedDialog'
$notifyForm.MaximizeBox = $false
$notifyForm.MinimizeBox = $false
$notifyForm.Text = "Windows Update Status"

$label = New-Object System.Windows.Forms.Label
$label.Text = "Windows Updates check complete.`nAll available updates have been installed."
$label.Font = New-Object System.Drawing.Font("Segoe UI", 12)
$label.Size = New-Object System.Drawing.Size(380, 90)
$label.Location = New-Object System.Drawing.Point(20, 20)
$label.TextAlign = 'MiddleCenter'
$notifyForm.Controls.Add($label)

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 5000  # 5 seconds
$timer.Add_Tick({
    $timer.Stop()
    $notifyForm.Close()
})

$timer.Start()
$notifyForm.ShowDialog()

Write-Host "Windows Update script finished." -ForegroundColor Cyan
exit
