<#
.SYNOPSIS
    Collects and displays key system hardware and OS information for auditing or inventory purposes.

.DESCRIPTION
    Gathers information such as device name, processor, RAM, device ID, product ID,
    system type, total storage, and graphics card details. Designed for Windows 11 24H2 systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-16

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Local execution or remote deployment via Intune/GPO
#>

# Load .NET assembly for using Windows Forms (MessageBox)
Add-Type -AssemblyName System.Windows.Forms

# Device Name
$deviceName = $env:COMPUTERNAME

# Processor Info
$cpu = Get-CimInstance Win32_Processor | Select-Object -ExpandProperty Name

# Installed RAM (converted to GB, rounded)
$ramBytes = (Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory
$installedRAM = "{0:N2} GB" -f ($ramBytes / 1GB)

# Device ID (BIOS UUID)
$deviceID = (Get-CimInstance Win32_ComputerSystemProduct).UUID

# Product ID from Windows registry
$productID = (Get-ItemProperty "HKLM:\Software\Microsoft\Windows NT\CurrentVersion").ProductId

# System Type (e.g., x64-based PC)
$systemType = (Get-CimInstance Win32_ComputerSystem).SystemType

# Total Storage across all physical disks
$storageBytes = (Get-CimInstance Win32_DiskDrive | Measure-Object -Property Size -Sum).Sum
$totalStorage = "{0:N2} GB" -f ($storageBytes / 1GB)

# Graphics Card(s)
$gpuList = Get-CimInstance Win32_VideoController | Select-Object -ExpandProperty Name

# Formatted information output
$info = @"
Device Name     : $deviceName
Processor       : $cpu
Installed RAM   : $installedRAM
Device ID       : $deviceID
Product ID      : $productID
System Type     : $systemType
Total Storage   : $totalStorage
Graphics Card(s): $(($gpuList -join ", "))

Collected by    : Alex Carter
Job Title       : IT Systems Engineer
Script Version  : 1.0
Date            : $(Get-Date -Format "yyyy-MM-dd HH:mm")
"@

# Output to console
Write-Host "`nSystem Information:`n$info"

# Show in Windows Message Box
[System.Windows.Forms.MessageBox]::Show($info, "System Info - Windows 11 24H2", "OK", "Information")
