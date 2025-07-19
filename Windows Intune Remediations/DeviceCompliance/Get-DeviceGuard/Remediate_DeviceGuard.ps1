<#
.SYNOPSIS
    Enables Windows Defender Device Guard on the system.

.DESCRIPTION
    Sets registry keys to activate virtualization-based security and platform security features required for Device Guard.
    Improves system security by enforcing code integrity policies.
    Intended for Windows 11 24H2 and later.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges. Suitable for local or remote deployment via Intune/GPO.
#>

# Enable Device Guard
$regKey = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard"
Set-ItemProperty -Path $regKey -Name "EnableVirtualizationBasedSecurity" -Value 1
Set-ItemProperty -Path $regKey -Name "RequirePlatformSecurityFeatures" -Value 1

Write-Output "Device Guard has been enabled."
