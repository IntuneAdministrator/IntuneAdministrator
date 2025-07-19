<#
.SYNOPSIS
    Restarts Windows audio services to resolve common audio issues.

.DESCRIPTION
    This script restarts the 'AudioEndpointBuilder' and 'Audiosrv' services, which are critical
    for audio functionality on Windows. It requires administrative privileges and provides
    user feedback via Windows Forms message boxes.

.NOTES
    Tested on Windows 11 24H2
    Requires PowerShell 5.1+ and .NET Framework for Windows Forms

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-18
    Version     : 1.0

#>

# Step 1: Load Windows Forms assembly to enable message boxes
Add-Type -AssemblyName System.Windows.Forms

# Step 2: Check if the script is running with Administrator privileges
$principal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    [System.Windows.Forms.MessageBox]::Show(
        "Please run this script as Administrator to restart audio services.",
        "Insufficient Privileges",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
    exit 1
}

# Step 3: Define audio-related services to restart
$services = @("AudioEndpointBuilder", "Audiosrv")

# Step 4: Restart each service with error handling
foreach ($service in $services) {
    try {
        Restart-Service -Name $service -Force -ErrorAction Stop
        Start-Sleep -Seconds 2  # Brief pause to allow service to restart properly
    } catch {
        [System.Windows.Forms.MessageBox]::Show(
            "Failed to restart the service '$service'.`nError details: $($_.Exception.Message)",
            "Service Restart Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
        exit 1
    }
}

# Step 5: Notify user of successful restart
[System.Windows.Forms.MessageBox]::Show(
    "Audio services have been restarted successfully.",
    "Success",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)

# Step 6: Exit script gracefully
exit
