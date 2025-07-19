<#
.SYNOPSIS
    Checks if a VPN profile named "CorporateVPN" is configured on the system.

.DESCRIPTION
    Uses Get-VpnConnection cmdlet to query for the presence of the specified VPN profile.
    Outputs the configuration status and returns exit code 0 if found, otherwise 1.
    Designed for Windows 11 24H2 and newer.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires appropriate permissions. Suitable for local or remote execution via Intune/GPO.
#>

# Check if the VPN profile is configured
$vpnProfile = Get-VpnConnection -Name "CorporateVPN" -ErrorAction SilentlyContinue
if ($vpnProfile) {
    Write-Output "VPN is configured"
    exit 0
} else {
    Write-Output "VPN is not configured"
    exit 1
}
