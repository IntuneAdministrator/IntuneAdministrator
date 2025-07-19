<#
.SYNOPSIS
    Detects if Windows Defender Device Guard is enabled on the system.

.DESCRIPTION
    Queries the Win32_DeviceGuard WMI class to determine if Device Guard
    security services are configured and running.
    Returns exit code 0 if Device Guard is enabled, otherwise 1.
    Designed for Windows 11 24H2 and later systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Local execution or remote deployment via Intune/GPO. Requires administrative privileges.
#>

# Check if Device Guard is enabled
$deviceGuardStatus = Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard

if ($deviceGuardStatus.SecurityServicesConfigured -contains 2 -and $deviceGuardStatus.SecurityServicesRunning -contains 2) {
    Write-Output "Device Guard is enabled."
    exit 0
} else {
    Write-Output "Device Guard is not enabled."
    exit 1
}
