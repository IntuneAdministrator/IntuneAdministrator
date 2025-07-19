<#
.SYNOPSIS
    Enables Windows Defender Credential Guard on the system.

.DESCRIPTION
    Modifies registry settings to activate Credential Guard using
    virtualization-based security features and configures Local Security Authority (LSA) flags.
    Enhances protection against credential theft attacks.
    Compatible with Windows 11 24H2 and later.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges. Suitable for local or remote deployment via Intune/GPO.
#>

# Enable Credential Guard
$regKey = "HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard"
Set-ItemProperty -Path $regKey -Name "EnableVirtualizationBasedSecurity" -Value 1
Set-ItemProperty -Path $regKey -Name "RequirePlatformSecurityFeatures" -Value 1

$regKey = "HKLM:\SYSTEM\CurrentControlSet\Control\LSA"
Set-ItemProperty -Path $regKey -Name "LsaCfgFlags" -Value 1

Write-Output "Credential Guard has been enabled."
