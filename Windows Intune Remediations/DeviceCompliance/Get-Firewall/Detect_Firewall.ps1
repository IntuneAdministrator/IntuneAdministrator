<#
.SYNOPSIS
    Detects if the Windows Firewall is enabled for all network profiles.

.DESCRIPTION
    Retrieves the firewall status for Domain, Public, and Private profiles using Get-NetFirewallProfile.
    Checks each profile and reports if any are disabled.
    Returns exit code 0 if all profiles are enabled, otherwise 1.
    Designed for Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges. Suitable for local or remote deployment via Intune/GPO.
#>

# Check if the firewall is enabled
$firewallStatus = Get-NetFirewallProfile -Profile Domain,Public,Private

foreach ($profile in $firewallStatus) {
    if ($profile.Enabled -eq $false) {
        Write-Output "Firewall is disabled for profile: $($profile.Name)"
        exit 1
    }
}

Write-Output "Firewall is enabled for all profiles."
exit 0
