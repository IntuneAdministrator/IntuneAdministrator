<#
.SYNOPSIS
    Enables Secure Boot on the system via registry modification.

.DESCRIPTION
    Sets the UEFISecureBootEnabled registry value to 1 to enable Secure Boot.
    Enhances system security by ensuring boot integrity.
    Note: A system reboot is required for this change to take effect.
    Applicable to Windows 11 24H2 and later.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges. Suitable for local or remote deployment via Intune/GPO.
#>

# Enable Secure Boot
$regKey = "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\State"
Set-ItemProperty -Path $regKey -Name "UEFISecureBootEnabled" -Value 1

Write-Output "Secure Boot has been enabled. A system reboot is required for changes to take effect."
