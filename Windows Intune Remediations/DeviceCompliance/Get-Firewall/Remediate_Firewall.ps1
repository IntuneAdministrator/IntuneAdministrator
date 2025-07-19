<#
.SYNOPSIS
    Enables the Windows Firewall for all network profiles.

.DESCRIPTION
    Uses Set-NetFirewallProfile cmdlet to enable the firewall on Domain, Public, and Private profiles.
    Enhances system security by ensuring firewall protection is active.
    Applicable to Windows 11 24H2 and newer.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges. Suitable for local or remote deployment via Intune/GPO.
#>

# Enable the firewall for all profiles
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

Write-Output "Firewall has been enabled for all profiles."
