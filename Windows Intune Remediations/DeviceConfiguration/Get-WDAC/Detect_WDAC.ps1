<#
.SYNOPSIS
    Detects if Windows Defender Application Control (WDAC) is enabled.

.DESCRIPTION
    Queries the Win32_DeviceGuard class to check if WDAC (Device Guard) security services are configured and running.
    Outputs the WDAC status and returns exit code 0 if enabled, otherwise 1.
    Designed for Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution with necessary permissions.
#>

# Check if WDAC is enabled
$wdacStatus = Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard

if ($wdacStatus.SecurityServicesConfigured -contains 2 -and $wdacStatus.SecurityServicesRunning -contains 2) {
    Write-Output "WDAC is enabled."
    exit 0
} else {
    Write-Output "WDAC is not enabled."
    exit 1
}
