<#
.SYNOPSIS
    Retrieves and exports the status of Windows Firewall profiles.

.DESCRIPTION
    This script checks the status of all active Windows Firewall profiles, including whether the firewall is enabled, 
    and the default inbound and outbound action. The status information is exported to a CSV file for reporting purposes.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses the `Get-NetFirewallProfile` cmdlet to retrieve firewall profile status information.
        - Administrative privileges may be required to retrieve firewall status on the system.
        - The result is saved to a CSV file for further analysis.
#>

# Check Windows Firewall status
$firewallStatus = Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction

# Output the Firewall status
# Write-Output $firewallStatus

$csvPath = "C:\temp\FirewallProfileStatus.csv"

$firewallStatus | Export-Csv -Path $csvPath -NoTypeInformation
Write-Output "Firewall Profile status exported to $csvPath"

Exit 0
