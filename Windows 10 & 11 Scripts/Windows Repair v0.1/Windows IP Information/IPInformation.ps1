<#
.SYNOPSIS
    Displays the main IPv4 addresses of all active physical network adapters.

.DESCRIPTION
    This script retrieves all physical network adapters that are currently up,
    gathers their main IPv4 addresses (excluding link-local addresses),
    and displays the information in a Windows Forms message box.

.NOTES
    - Requires running with appropriate privileges to access network adapter info.
    - Compatible with Windows 11 24H2 and later.
    - Uses native PowerShell cmdlets: Get-NetAdapter, Get-NetIPAddress.
    - Uses Windows Forms for user-friendly display.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-17
    Version     : 1.0
#>

# Load Windows Forms assembly for GUI MessageBox
Add-Type -AssemblyName System.Windows.Forms

# Retrieve all physical network adapters that are up and functioning
$adapters = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' -and $_.HardwareInterface } |
    Select-Object Name, Status, MacAddress, LinkSpeed, InterfaceDescription, InterfaceIndex

# Retrieve all IPv4 addresses excluding link-local (169.254.x.x) addresses and nulls
$ipv4Addresses = Get-NetIPAddress | Where-Object {
    $_.AddressFamily -eq 'IPv4' -and
    $_.IPAddress -notlike '169.254.*' -and
    $_.IPAddress -ne $null
}

# Build a formatted message containing adapter info and main IPv4 address
$message = ($adapters | ForEach-Object {
    $adapter = $_
    # Find IPv4 addresses that belong to this adapter by matching InterfaceIndex
    $ips = $ipv4Addresses | Where-Object { $_.InterfaceIndex -eq $adapter.InterfaceIndex } | Select-Object -ExpandProperty IPAddress

    # Choose first IPv4 address or fallback text if none found
    $mainIp = if ($ips) { $ips[0] } else { "No IPv4 Address" }

    # Format multi-line string for this adapter
    "Name: $($adapter.Name)`nStatus: $($adapter.Status)`nMAC: $($adapter.MacAddress)`nSpeed: $($adapter.LinkSpeed)`nDescription: $($adapter.InterfaceDescription)`nMain IPv4 Address: $mainIp`n`n"
}) -join ""

# Display the message box with all adapter information
[System.Windows.Forms.MessageBox]::Show(
    $message,
    "Main IPv4 Addresses",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)
