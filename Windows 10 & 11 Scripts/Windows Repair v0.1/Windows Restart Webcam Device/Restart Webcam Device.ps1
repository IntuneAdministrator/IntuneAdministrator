<#
.SYNOPSIS
    Restarts all connected webcam devices.

.DESCRIPTION
    Detects webcam devices (class "Camera" or "Image") and restarts them by disabling and re-enabling via PowerShell.
    Useful for resolving common webcam issues without needing a full system reboot.

.REQUIREMENTS
    - Run as Administrator
    - Windows 10/11, especially 22H2 / 24H2 compatible

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-18
    Version     : 1.0
#>

# Step 1: Load Windows Forms for visual feedback
Add-Type -AssemblyName System.Windows.Forms

# Step 2: Ensure the script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    [System.Windows.Forms.MessageBox]::Show("Please run this script as Administrator.", "Permission Required", 'OK', 'Error')
    exit 1
}

try {
    # Step 3: Get webcam devices (exclude printers and scanners)
    $webcams = Get-CimInstance -Namespace root\cimv2 -ClassName Win32_PnPEntity | Where-Object {
        ($_.PNPClass -eq 'Camera' -or $_.PNPClass -eq 'Image') -and
        ($_.Name -notmatch 'Printer|OfficeJet|Fax|Scan|Copy')
    }

    if (-not $webcams) {
        # Step 4: No webcams found
        [System.Windows.Forms.MessageBox]::Show("No webcam devices found to restart.", "No Devices Detected", 'OK', 'Warning')
        exit 0
    }

    # Step 5: Restart each detected webcam
    foreach ($cam in $webcams) {
        Write-Host "Restarting device: $($cam.Name)"

        try {
            Disable-PnpDevice -InstanceId $cam.PNPDeviceID -Confirm:$false -ErrorAction Stop
            Start-Sleep -Seconds 2
            Enable-PnpDevice -InstanceId $cam.PNPDeviceID -Confirm:$false -ErrorAction Stop
        } catch {
            Write-Warning "Failed to restart device: $($cam.Name)`n$($_.Exception.Message)"
        }
    }

    # Step 6: Success message
    [System.Windows.Forms.MessageBox]::Show("Webcam device(s) restarted successfully.", "Webcam Restart Complete", 'OK', 'Information')

} catch {
    # Step 7: General error handling
    [System.Windows.Forms.MessageBox]::Show("An error occurred: $($_.Exception.Message)", "Error", 'OK', 'Error')
}
