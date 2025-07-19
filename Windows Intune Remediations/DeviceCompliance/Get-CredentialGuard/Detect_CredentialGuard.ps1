<#
.SYNOPSIS
    Detects if Windows Defender Credential Guard is enabled on the system.

.DESCRIPTION
    Queries the Win32_DeviceGuard WMI class to check if Credential Guard
    security services are configured and running.
    Returns exit code 0 if Credential Guard is enabled, otherwise 1.
    Intended for use on Windows 11 24H2 and later.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Local execution or remote deployment via Intune/GPO. Requires administrative privileges.
#>

# Check if Credential Guard is enabled
$credentialGuardStatus = Get-CimInstance -ClassName Win32_DeviceGuard -Namespace root\Microsoft\Windows\DeviceGuard

if ($credentialGuardStatus.SecurityServicesConfigured -contains 1 -and $credentialGuardStatus.SecurityServicesRunning -contains 1) {
    Write-Output "Credential Guard is enabled."
    exit 0
} else {
    Write-Output "Credential Guard is not enabled."
    exit 1
}
