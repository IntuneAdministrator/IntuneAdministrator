<#
.SYNOPSIS
    Checks for connected webcam devices and attempts uninstallation.

.DESCRIPTION
    Queries WMI for imaging devices classified as webcams, excluding multifunction printers or scanners.
    Attempts to uninstall each detected webcam. If any uninstallation fails, alerts the user to uninstall manually.
    Handles errors gracefully with clear message boxes.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-18
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2 and above  
    Requires     : Admin rights, Windows Forms, Device Management privileges
#>

Add-Type -AssemblyName System.Windows.Forms

# Check for Admin
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    [System.Windows.Forms.MessageBox]::Show(
        "This script must be run as Administrator.",
        "Insufficient Permissions",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
    exit 1
}

# Confirm user wants to continue
$userChoice = [System.Windows.Forms.MessageBox]::Show(
    "This will uninstall all detected webcam devices. Windows will reinstall drivers automatically." + [Environment]::NewLine + "Do you want to continue?",
    "Confirm Webcam Uninstall",
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Warning
)
if ($userChoice -ne [System.Windows.Forms.DialogResult]::Yes) {
    Write-Host "Operation cancelled by user."
    exit 0
}

try {
    # Query webcams, excluding printers and MFPs
    $webcams = Get-CimInstance -Namespace root\cimv2 -ClassName Win32_PnPEntity | Where-Object {
        ($_.PNPClass -eq 'Camera' -or $_.PNPClass -eq 'Image') -and
        ($_.Name -notmatch 'Printer|OfficeJet|Fax|Scan|Copy')
    }

    if (-not $webcams) {
        [System.Windows.Forms.MessageBox]::Show(
            "No webcam devices were detected on this system.",
            "No Devices Found",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
        exit 0
    }

    $uninstallFailures = @()

    foreach ($cam in $webcams) {
        Write-Output "Uninstalling device: $($cam.Name)"
        try {
            Remove-PnpDevice -InstanceId $cam.DeviceID -Confirm:$false -ErrorAction Stop
            Start-Sleep -Seconds 3
        } catch {
            Write-Warning "Failed to uninstall device: $($cam.Name)"
            $uninstallFailures += $cam.Name
        }
    }

    if ($uninstallFailures.Count -gt 0) {
        $failedList = ($uninstallFailures -join "`n")
        [System.Windows.Forms.MessageBox]::Show(
            "Some devices could not be uninstalled:`n`n$failedList`n`nPlease uninstall them manually or contact support.",
            "Manual Intervention Required",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
    } else {
        [System.Windows.Forms.MessageBox]::Show(
            "Webcam device(s) uninstalled successfully. Windows will reinstall drivers automatically.",
            "Operation Completed",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
    }

} catch {
    [System.Windows.Forms.MessageBox]::Show(
        "An unexpected error occurred: $($_.Exception.Message)",
        "Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
    exit 1
}
