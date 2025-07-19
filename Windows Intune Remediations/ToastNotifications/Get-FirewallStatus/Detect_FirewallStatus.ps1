<#
.SYNOPSIS
    Checks the status of the Windows Firewall for Domain, Public, and Private profiles.

.DESCRIPTION
    This script checks whether the Windows Firewall is enabled for the Domain, Public, and Private profiles.
    If any of these profiles have the firewall disabled, the script will output a message and exit with a status of 1.
    Otherwise, it exits with a status of 0.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11 with Windows Firewall
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script checks for the firewall status across three key network profiles: Domain, Public, and Private.
#>

# Check the firewall status for Domain, Public, and Private profiles
$firewallStatus = Get-NetFirewallProfile -Profile Domain,Public,Private

# If any firewall profile is disabled, exit with status 1
if ($firewallStatus.Enabled -contains $false) {
    Write-Output "Firewall is disabled"
    exit 1
} else {
    exit 0
}
