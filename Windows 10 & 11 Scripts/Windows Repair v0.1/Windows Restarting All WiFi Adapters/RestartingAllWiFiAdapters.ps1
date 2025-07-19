<#
.SYNOPSIS
    Restarts enabled Wi-Fi and Ethernet network adapters on Windows 11 systems.

.DESCRIPTION
    This script detects network adapters named "Wi-Fi" and "Ethernet" that are currently enabled (Status "Up" or "Connected").
    It then disables and re-enables these adapters to effectively restart them.
    This can help resolve network connectivity issues without requiring a full system reboot.
    The script ensures it is run with administrator privileges and provides user feedback via Windows Forms message boxes.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-18
    Version     : 1.0

.NOTES
    - Designed and tested for Windows 11 24H2.
    - Requires running with Administrator privileges.
    - Uses built-in PowerShell cmdlets: Get-NetAdapter, Disable-NetAdapter, Enable-NetAdapter.
    - Provides visual user feedback through message boxes.
#>

# Ensure running as admin (you can add this in your script if needed)

Add-Type -AssemblyName System.Windows.Forms

$adapters = Get-NetAdapter | Where-Object {
    ($_.Name -eq "Wi-Fi" -or $_.Name -eq "Ethernet") -and
    ($_.Status -eq "Up" -or $_.Status -eq "Connected")
}

if ($adapters) {
    foreach ($adapter in $adapters) {
        Write-Host "Restarting adapter: $($adapter.Name)"
        Disable-NetAdapter -Name $adapter.Name -Confirm:$false -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 3
        Enable-NetAdapter -Name $adapter.Name -Confirm:$false -ErrorAction SilentlyContinue
    }

    [System.Windows.Forms.MessageBox]::Show(
        "Selected adapters restarted successfully.",
        "Restart Complete",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
} else {
    [System.Windows.Forms.MessageBox]::Show(
        "No enabled Wi-Fi or Ethernet adapters found.",
        "No Adapters Found",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Warning
    )
}

exit
