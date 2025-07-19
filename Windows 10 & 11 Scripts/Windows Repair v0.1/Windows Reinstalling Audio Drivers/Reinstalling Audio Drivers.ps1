<#
.SYNOPSIS
    Uninstalls all active audio devices and triggers driver reinstallation.

.DESCRIPTION
    This script removes all currently functioning audio devices (classified under the "Media" device class) 
    and initiates a rescan so that Windows reinstalls the drivers automatically.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-18
    Version     : 1.0

.NOTES
    Tested on: Windows 11 24H2+
    Requires: Administrator privileges
    Compatible with: PowerShell 5.1+, pnputil.exe
#>

# Step 1: Load Windows Forms for MessageBox functionality
# This enables use of [System.Windows.Forms.MessageBox] for user interaction.
Add-Type -AssemblyName System.Windows.Forms

# Step 2: Check for administrative privileges
# Ensures script is running with elevated permissions.
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    
    [System.Windows.Forms.MessageBox]::Show(
        "This script must be run as Administrator.",
        "Insufficient Privileges",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
    exit 1
}

# Step 3: Retrieve all working audio (Media class) devices
# These include speakers, microphones, sound cards, and virtual audio drivers.
$audioDevices = Get-PnpDevice -Class Media -Status OK

# Step 4: Confirm uninstallation with the user
$userConfirm = [System.Windows.Forms.MessageBox]::Show(
    "This will uninstall all active audio devices. Windows will attempt to reinstall them automatically after a scan." + [Environment]::NewLine + [Environment]::NewLine + "Do you want to continue?",
    "Confirm Audio Device Reinstallation",
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Warning
)
if ($userConfirm -ne [System.Windows.Forms.DialogResult]::Yes) {
    Write-Host "Operation canceled by user."
    exit 0
}

# Step 5: Loop through each audio device and uninstall it
$failedUninstalls = @()

foreach ($device in $audioDevices) {
    Write-Host "Attempting to uninstall device: $($device.FriendlyName)"
    try {
        # Attempt to remove the device via pnputil using the InstanceId
        pnputil /remove-device "$($device.InstanceId)" | Out-Null
        Start-Sleep -Seconds 2
    } catch {
        Write-Warning "Failed to uninstall: $($device.FriendlyName)"
        $failedUninstalls += $device.FriendlyName
    }
}

# Step 6: Trigger device rescan to force driver reinstallation
try {
    Start-Process -FilePath "pnputil.exe" -ArgumentList "/scan-devices" -Wait
} catch {
    Write-Warning "Device rescan failed: $_"
}

# Step 7: Notify user of results
if ($failedUninstalls.Count -eq 0) {
    [System.Windows.Forms.MessageBox]::Show(
        "Audio devices uninstalled successfully. Windows will reinstall the drivers automatically." + [Environment]::NewLine + "A system reboot may be required.",
        "Audio Devices Reinstalled",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
} else {
    $failList = $failedUninstalls -join "`n"
    [System.Windows.Forms.MessageBox]::Show(
        "The following devices could not be uninstalled:`n`n$failList`n`nPlease uninstall them manually or contact IT support.",
        "Manual Uninstall Required",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )
}

# Step 8: End the script gracefully
exit 0
