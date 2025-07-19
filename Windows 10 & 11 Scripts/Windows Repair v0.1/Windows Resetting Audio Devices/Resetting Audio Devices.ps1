<#
.SYNOPSIS
    Soft-resets all enabled audio devices by disabling and re-enabling them.

.DESCRIPTION
    This script is designed for Windows 11 24H2 systems. It identifies all enabled audio devices (Media class),
    temporarily disables each one, then re-enables it to help resolve common sound issues without requiring a full driver reinstall.
    Administrative privileges are required. The script provides user-friendly feedback via MessageBoxes.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-18
    Version     : 1.0

.NOTES
    - Requires administrator privileges
    - Uses Windows Forms for message dialogs
    - Compatible with Windows 11 24H2 and newer
#>

# Step 1: Load Windows Forms assembly to use MessageBox UI
Add-Type -AssemblyName System.Windows.Forms

# Step 2: Ensure script is running with administrator privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    throw "Run this script as Administrator."
}

# Step 3: Retrieve all currently enabled audio (Media class) devices
$audioDevices = Get-PnpDevice -Class Media -Status OK

# Step 4: If no enabled audio devices found, notify and exit
if (-not $audioDevices) {
    [System.Windows.Forms.MessageBox]::Show(
        "No enabled audio devices were found on this system.",
        "No Devices Detected",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )
    exit 0
}

# Step 5: Loop through each audio device and soft reset (disable → enable)
foreach ($device in $audioDevices) {
    try {
        # Disable the device
        Disable-PnpDevice -InstanceId $device.InstanceId -Confirm:$false -ErrorAction Stop
        Start-Sleep -Seconds 1

        # Re-enable the device
        Enable-PnpDevice -InstanceId $device.InstanceId -Confirm:$false -ErrorAction Stop
        Start-Sleep -Seconds 1

    } catch {
        # Log warning if soft reset fails for a specific device
        Write-Warning "Failed to reset device $($device.FriendlyName): $($_.Exception.Message)"
    }
}

# Step 6: Notify user that audio reset was completed
[System.Windows.Forms.MessageBox]::Show(
    "Audio devices were successfully reset. You may now test your audio.",
    "Audio Devices Reset",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)

# Step 7: Exit script gracefully
exit 0
