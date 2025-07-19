<#
.SYNOPSIS
    Repairs Windows Update components, runs DISM and SFC scans to fix system corruption, with a progress bar UI and detailed logging.

.DESCRIPTION
    This script is tailored for Windows 11 24H2 environments.
    It performs the following:
      - Stops Windows Update services and clears update caches
      - Runs DISM checks and restores system image health
      - Runs System File Checker (SFC) to repair system files
      - Displays a Windows Forms-based progress bar with percentage and status messages
      - Logs all operations with timestamps to centralized log files for auditing and troubleshooting
      - Displays completion or error messages to the user

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-20
    Version     : 1.0

.NOTES
    Author: Senior IT Professional
    Requires: PowerShell running as Administrator
    Tested on: Windows 11 24H2
#>

# Import .NET Windows Forms assembly to enable GUI components like message boxes and progress bars
Add-Type -AssemblyName System.Windows.Forms

# --- Function: Write-Log ---
# Writes a timestamped log message to a specified log file, creating the file/folder if necessary.
function Write-Log {
    param(
        [Parameter(Mandatory)]
        [string]$Message,
        [Parameter(Mandatory)]
        [string]$LogFile
    )

    # Ensure the directory for the log file exists
    $logDir = Split-Path -Path $LogFile
    if (-not (Test-Path $logDir)) {
        New-Item -Path $logDir -ItemType Directory -Force | Out-Null
    }

    # Format message with timestamp
    $timeStampedMessage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - $Message"

    # Append the message to the log file
    Add-Content -Path $LogFile -Value $timeStampedMessage
}

# --- Function: Update-UI ---
# Processes pending Windows Forms UI events, keeping the form responsive.
function Update-UI {
    [System.Windows.Forms.Application]::DoEvents()
}

# --- Function: Set-Progress ---
# Updates the progress bar and status labels on the form.
function Set-Progress {
    param(
        [Parameter(Mandatory)]
        [int]$Percent,
        [Parameter(Mandatory)]
        [string]$StatusMessage
    )

    # Clamp percentage value between 0 and 100
    $Percent = [Math]::Min([Math]::Max($Percent, 0), 100)

    $progressBar.Value = $Percent
    $percentLabel.Text = "$Percent%"
    $statusLabel.Text = $StatusMessage
    Update-UI
}

# --- Verify script is running with Administrator privileges ---
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    # Inform the user about the required elevated privileges and exit
    [System.Windows.Forms.MessageBox]::Show(
        "This script must be run as Administrator.",
        "Insufficient Privileges",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Warning)
    exit 1
}

# --- Initialize Windows Forms GUI ---

$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows Update Repair Progress"
$form.Size = New-Object System.Drawing.Size(480, 180)
$form.StartPosition = 'CenterScreen'
$form.Topmost = $true
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.MinimizeBox = $false

# Label showing numeric percentage
$percentLabel = New-Object System.Windows.Forms.Label
$percentLabel.AutoSize = $false
$percentLabel.Width = 440
$percentLabel.Height = 20
$percentLabel.Location = New-Object System.Drawing.Point(20, 15)
$percentLabel.TextAlign = 'MiddleCenter'
$percentLabel.Text = "0%"
$form.Controls.Add($percentLabel)

# Progress bar control
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Minimum = 0
$progressBar.Maximum = 100
$progressBar.Style = 'Continuous'
$progressBar.Width = 440
$progressBar.Height = 30
$progressBar.Location = New-Object System.Drawing.Point(20, 40)
$form.Controls.Add($progressBar)

# Label showing status text below progress bar
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.AutoSize = $false
$statusLabel.Width = 440
$statusLabel.Height = 20
$statusLabel.Location = New-Object System.Drawing.Point(20, 80)
$statusLabel.TextAlign = 'MiddleCenter'
$statusLabel.Text = "Initializing..."
$form.Controls.Add($statusLabel)

# Info label for user note
$infoLabel = New-Object System.Windows.Forms.Label
$infoLabel.AutoSize = $false
$infoLabel.Width = 440
$infoLabel.Height = 30
$infoLabel.Location = New-Object System.Drawing.Point(20, 110)
$infoLabel.TextAlign = 'MiddleCenter'
$infoLabel.ForeColor = [System.Drawing.Color]::DarkRed
$infoLabel.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Italic)
$infoLabel.Text = "Note: This process may take 20-30 minutes. Please be patient."
$form.Controls.Add($infoLabel)

# Show the form on screen
$form.Show()
Update-UI

# Define centralized log file locations for each task
$wuLogFile = "C:\ProgramData\OzarkTechTeam\WURepair Logs\WURepair_log.txt"
$dismLogFile = "C:\ProgramData\OzarkTechTeam\DISM tool Logs\DISM_log.txt"
$sfcLogFile = "C:\ProgramData\OzarkTechTeam\SFC Logs\SFC_log.txt"

# Begin try-catch block for robust error handling
try {
    # --- Windows Update Repair ---

    Set-Progress -Percent 5 -StatusMessage "Stopping Windows Update services..."
    Write-Log "Starting Windows Update repair" $wuLogFile

    # Stop Windows Update services gracefully
    net stop wuauserv | Out-Null
    net stop cryptSvc | Out-Null
    net stop bits | Out-Null
    net stop msiserver | Out-Null

    Set-Progress -Percent 15 -StatusMessage "Renaming update cache folders..."
    # Rename update cache folders to reset update data safely
    Rename-Item -Path "C:\Windows\SoftwareDistribution" -NewName "SoftwareDistribution.old" -ErrorAction SilentlyContinue
    Rename-Item -Path "C:\Windows\System32\catroot2" -NewName "catroot2.old" -ErrorAction SilentlyContinue

    Set-Progress -Percent 25 -StatusMessage "Restarting Windows Update services..."
    # Restart update services after cleanup
    net start wuauserv | Out-Null
    net start cryptSvc | Out-Null
    net start bits | Out-Null
    net start msiserver | Out-Null

    Write-Log "Completed Windows Update repair" $wuLogFile

    # --- DISM (Deployment Image Servicing and Management) ---

    Set-Progress -Percent 35 -StatusMessage "Running DISM /CheckHealth..."
    Write-Log "Starting DISM /CheckHealth" $dismLogFile
    DISM /Online /Cleanup-Image /CheckHealth | Out-Null

    Set-Progress -Percent 50 -StatusMessage "Running DISM /ScanHealth..."
    Write-Log "Starting DISM /ScanHealth" $dismLogFile
    DISM /Online /Cleanup-Image /ScanHealth | Out-Null

    Set-Progress -Percent 65 -StatusMessage "Running DISM /RestoreHealth..."
    Write-Log "Starting DISM /RestoreHealth" $dismLogFile
    DISM /Online /Cleanup-Image /RestoreHealth | Out-Null

    Write-Log "Completed DISM process" $dismLogFile

    # --- System File Checker (SFC) ---

    Set-Progress -Percent 80 -StatusMessage "Running System File Checker (SFC)..."
    Write-Log "Starting SFC /scannow" $sfcLogFile
    sfc /scannow | Out-Null
    Write-Log "Completed SFC scan" $sfcLogFile

    # Final progress update to 100%
    Set-Progress -Percent 100 -StatusMessage "Process completed successfully."
    Start-Sleep -Seconds 1

    # Close the progress form
    $form.Close()

    # Show a message box to inform the user that all operations completed successfully
    [System.Windows.Forms.MessageBox]::Show(
        "Windows Update repair, DISM, and SFC scans completed successfully.",
        "Process Completed",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
}
catch {
    # Close form if open
    if ($form -and $form.Visible) {
        $form.Close()
    }

    # Show error details to user in a message box
    [System.Windows.Forms.MessageBox]::Show(
        "An error occurred during execution:`n$($_.Exception.Message)",
        "Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
}

# End of script
exit 0
