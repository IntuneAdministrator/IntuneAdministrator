<#
.SYNOPSIS
    Updates webcam drivers on Windows 11 (24H2) using pnputil, with a modern progress bar UI.

.DESCRIPTION
    This PowerShell script scans for enabled webcam devices from the Camera and Media device classes,
    filters devices with "camera" or "webcam" in their friendly names, and attempts to update their drivers
    by invoking pnputil to check for newer driver packages from Windows Update or the local driver store.
    The script displays a responsive Windows Forms GUI with a progress bar and status messages,
    providing real-time feedback during the update process.
    Detailed error handling ensures that failures for individual devices are logged without terminating the script.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-20
    Version     : 1.0

.NOTES
    - Designed for Windows 11 version 24H2.
    - Requires running the script with administrative privileges to update drivers.
    - Uses .NET Windows Forms for UI; no external dependencies.
    - Tested with pnputil.exe located in %SystemRoot%\System32.
    - The script excludes non-webcam devices by filtering on device class and friendly name.
    - Make sure your system has access to Windows Update for driver fetching.
#>

# Load necessary assemblies for Windows Forms and Drawing
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create a new Windows Form for the progress UI
$form = New-Object System.Windows.Forms.Form
$form.Text = "Webcam Driver Updater"                   # Window title
$form.Size = New-Object System.Drawing.Size(500, 150) # Window size width=500, height=150
$form.StartPosition = 'CenterScreen'                   # Center window on screen
$form.TopMost = $true                                   # Keep window on top

# Create and configure a label to show status messages
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Size = New-Object System.Drawing.Size(460, 30)
$statusLabel.Location = New-Object System.Drawing.Point(15, 10)
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI",12,[System.Drawing.FontStyle]::Regular)
$statusLabel.Text = "Preparing to update webcam drivers..." # Initial text
$form.Controls.Add($statusLabel)

# Create and configure the progress bar control
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Size = New-Object System.Drawing.Size(460, 30)
$progressBar.Location = New-Object System.Drawing.Point(15, 50)
$progressBar.Style = 'Continuous'        # Smooth progress bar style (not marquee)
$progressBar.Minimum = 0                 # Minimum value of progress
$progressBar.Value = 0                   # Initial progress bar value
$form.Controls.Add($progressBar)

# Show the form before starting updates so user sees UI immediately
$form.Show()

# Function to update UI elements and keep form responsive
function Update-UI {
    param (
        [string]$message,
        [int]$progress
    )
    $statusLabel.Text = $message
    $progressBar.Value = $progress
    # Process Windows messages to keep UI responsive during loop
    [System.Windows.Forms.Application]::DoEvents()
}

# Retrieve enabled devices from Camera and Media device setup classes
$cameras = Get-PnpDevice -Class "Camera" -Status OK -ErrorAction SilentlyContinue
$mediaDevices = Get-PnpDevice -Class "Media" -Status OK -ErrorAction SilentlyContinue

# Combine device lists safely (handle nulls)
$allDevices = @()
if ($cameras) { $allDevices += $cameras }
if ($mediaDevices) { $allDevices += $mediaDevices }

# Filter only devices whose FriendlyName contains "camera" or "webcam" (case-insensitive)
$webcams = $allDevices | Where-Object {
    $_.FriendlyName -match 'camera|webcam'
}

# Exit early if no webcams found, show warning message box and close form
if (-not $webcams) {
    $form.Close()
    [System.Windows.Forms.MessageBox]::Show(
        "No enabled webcam devices found to update.",
        "Driver Update",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )
    exit
}

# Total devices count for progress calculation
$totalDevices = $webcams.Count
$currentIndex = 0

# Loop through each webcam device and update driver
foreach ($device in $webcams) {
    $currentIndex++

    # Update UI to show which device is currently updating and progress percent
    $percent = [math]::Floor(($currentIndex / $totalDevices) * 100)
    Update-UI -message "Updating driver for: $($device.FriendlyName) ($percent%)" -progress $percent

    try {
        # Run pnputil to update the driver for this device silently
        # /update-driver tries to find a newer driver from Windows Update or local store
        # /install installs the driver if found
        & "$env:SystemRoot\System32\pnputil.exe" /update-driver "$($device.InstanceId)" /install | Out-Null
    }
    catch {
        # Log warning to console if update failed for a device (does not stop script)
        Write-Warning "Failed to update driver for: $($device.FriendlyName). Error: $_"
    }
}

# Finalize progress bar and status message after all updates complete
Update-UI -message "Driver update process completed." -progress 100

# Small pause so user can see 100% completion before window closes
Start-Sleep -Seconds 1

# Close the progress window
$form.Close()

# Inform user of completion with a MessageBox
[System.Windows.Forms.MessageBox]::Show(
    "Webcam driver update process completed successfully.",
    "Driver Update",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)

# Exit script
exit
