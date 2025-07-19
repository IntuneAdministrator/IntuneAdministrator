<#
.SYNOPSIS
    Checks if the DNS server settings include a specific IP address.

.DESCRIPTION
    Retrieves the configured IPv4 DNS server addresses for all network interfaces.
    Verifies if the primary DNS server (8.8.8.8) is included in the list.
    Outputs status and returns exit code 0 if correct, otherwise 1.
    Designed for Windows 11 24H2 and later systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires read access to network configuration. Suitable for local or remote execution.
#>

# Check DNS settings
$dnsServers = Get-DnsClientServerAddress -AddressFamily IPv4 | Select-Object -ExpandProperty ServerAddresses
if ($dnsServers -notcontains "8.8.8.8") {
    Write-Output "DNS settings need to be updated"
    exit 1
} else {
    Write-Output "DNS settings are correct"
    exit 0
}
