<#
.SYNOPSIS
    Retrieves and exports the status of critical services.

.DESCRIPTION
    This script checks the status of critical services, including Windows Update (wuauserv), 
    Background Intelligent Transfer Service (BITS), and Microsoft Defender Antivirus (WinDefend).
    The status of these services (Running, Stopped, etc.) is exported to a CSV file for reporting.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script checks for the status of key system services critical to update and security processes.
        - The service statuses are exported to a CSV file for further analysis or reporting.
#>

# Check status of critical services
$services = Get-Service -Name "wuauserv", "BITS", "WinDefend" | Select-Object Name, Status

# Output the service status
# Write-Output $services

$csvPath = "C:\temp\ServiceStatus.csv"

$services | Export-Csv -Path $csvPath -NoTypeInformation
Write-Output "Service status exported to $csvPath"

Exit 0
