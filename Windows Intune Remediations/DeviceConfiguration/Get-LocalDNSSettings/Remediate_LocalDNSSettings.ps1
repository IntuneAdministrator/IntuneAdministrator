<#
.SYNOPSIS
    Configures DNS server addresses for a specified network interface.

.DESCRIPTION
    Sets the DNS server IP addresses for the network interface identified by the alias "Ethernet".
    Applies the specified DNS servers to enhance or override default network DNS settings.
    Suitable for Windows 11 24H2 and later.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges. Suitable for local or remote deployment via Intune/GPO.
#>

# Set DNS settings
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "8.8.8.8","8.8.4.4"
Write-Output "DNS settings updated"
