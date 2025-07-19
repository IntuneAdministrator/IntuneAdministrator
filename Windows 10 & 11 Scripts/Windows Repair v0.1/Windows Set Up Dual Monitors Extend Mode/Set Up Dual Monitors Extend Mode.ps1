<#
.SYNOPSIS
    Configures dual monitor setup by extending the desktop across connected monitors.

.DESCRIPTION
    This script checks if two or more monitors are connected using WMI.
    It prompts the user to confirm whether to proceed with extending the desktop.
    If the user agrees and two or more monitors are detected, it uses DisplaySwitch.exe to extend the desktop.
    The script provides visual feedback via Windows Forms message boxes and handles errors gracefully.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-19
    Version     : 1.0

.NOTES
    - Tested on Windows 11 24H2.
    - Requires PowerShell with permission to query WMI and start processes.
    - Uses built-in Windows utilities for display configuration.
    - Does not set primary monitor; user must adjust manually if needed.
#>

# Load Windows Forms assembly for MessageBox support
Add-Type -AssemblyName System.Windows.Forms

# Prompt user to confirm extending the desktop to multiple monitors
$userChoice = [System.Windows.Forms.MessageBox]::Show(
    "Do you want to configure the dual monitor setup to Extend mode?",
    "Confirm Dual Monitor Setup",
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Question
)

if ($userChoice -eq [System.Windows.Forms.DialogResult]::Yes) {
    try {
        # Function to retrieve connected monitor details via WMI
        function Get-ConnectedMonitors {
            Get-CimInstance -Namespace root\wmi -ClassName WmiMonitorBasicDisplayParams | 
            Select-Object InstanceName, MaxHorizontalImageSize, MaxVerticalImageSize
        }

        # Get the list of connected monitors
        $monitors = Get-ConnectedMonitors

        # Validate that at least two monitors are connected
        if ($monitors.Count -lt 2) {
            [System.Windows.Forms.MessageBox]::Show(
                "Less than two monitors detected. Please connect a second monitor to proceed.",
                "Dual Monitor Setup",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Warning
            )
            exit
        }

        # Extend the desktop across all connected monitors
        Start-Process -FilePath "C:\Windows\System32\DisplaySwitch.exe" -ArgumentList "/extend" -Wait

        # Inform the user of successful configuration
        [System.Windows.Forms.MessageBox]::Show(
            "Dual monitor setup has been configured to Extend mode. Please adjust resolution and primary monitor in Display Settings as needed.",
            "Dual Monitor Setup",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        )
    }
    catch {
        # Show error message if something goes wrong
        [System.Windows.Forms.MessageBox]::Show(
            "An error occurred during dual monitor setup:`n$_",
            "Dual Monitor Setup Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
    }
} else {
    # User chose No - exit script gracefully without changes
    Write-Host "Operation cancelled by user."
    exit
}

# Exit script gracefully
exit
