<#
.SYNOPSIS
    Checks for connected webcam devices and displays their status.

.DESCRIPTION
    Queries WMI for imaging devices classified as webcams, excluding multifunction printers or scanners.
    If webcams are found, displays their name, status, and device ID in a message box.
    If none are found, notifies the user accordingly.
    Handles errors gracefully by showing an error message box.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above  
    Requires     : Permissions to query WMI and display Windows Forms message boxes
#>

# Load Windows Forms assembly for message box
Add-Type -AssemblyName System.Windows.Forms

try {
    # Query WMI for imaging devices (webcams)
    $webcams = Get-CimInstance -Namespace root\cimv2 -ClassName Win32_PnPEntity |
        Where-Object { 
            ($_.PNPClass -eq 'Camera' -or $_.PNPClass -eq 'Image') -and
            ($_.Name -notmatch 'Printer|OfficeJet|Fax|Scan|Copy') # exclude printers and multifunction devices
        }

    if ($webcams.Count -eq 0) {
        # No webcams found
        [System.Windows.Forms.MessageBox]::Show(
            "No webcam devices were found on this system.",
            "Webcam Status",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
    } else {
        # Build status report string
        $statusReport = ""

        foreach ($cam in $webcams) {
            $statusReport += "Device Name: $($cam.Name)`n"
            $statusReport += "Status: $($cam.Status)`n"
            $statusReport += "Device ID: $($cam.DeviceID)`n"
            $statusReport += "----------------------------------------`n"
        }

        # Show webcam info in message box
        [System.Windows.Forms.MessageBox]::Show(
            $statusReport,
            "Webcam Devices Found",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
    }
} catch {
    # Show error message box if something goes wrong
    [System.Windows.Forms.MessageBox]::Show(
        "An error occurred: $_",
        "Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
}

exit 0
