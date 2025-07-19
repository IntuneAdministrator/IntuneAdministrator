<#
.SYNOPSIS
    Configures a VPN connection profile named "CorporateVPN".

.DESCRIPTION
    Creates a VPN connection using the Add-VpnConnection cmdlet with specified parameters:
    - Server address set to vpn.corporate.com
    - Tunnel type set to L2TP
    - Authentication method set to EAP
    - Encryption level set to Required
    - Credentials are remembered for user convenience
    Suitable for Windows 11 24H2 and newer.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges. Suitable for local or remote deployment via Intune/GPO.
#>

# Configure the VPN profile
Add-VpnConnection -Name "CorporateVPN" -ServerAddress "vpn.corporate.com" -TunnelType "L2tp" -AuthenticationMethod "Eap" -EncryptionLevel "Required" -RememberCredential

Write-Output "VPN configured"
