<#
.SYNOPSIS
    Retrieves and exports a list of installed software on the system.

.DESCRIPTION
    This script retrieves a list of installed software on the machine using the `Win32_Product` WMI class.
    The software list, including the name and version, is exported to a CSV file at a specified location.
    The script is intended to be used for inventory reporting purposes.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script queries the `Win32_Product` class, which may trigger a reconfiguration of installed software on some systems.
        - Ensure that the path provided in `$csvPath` is valid and writable.
#>

# Get list of installed software
$software = Get-WmiObject -Class Win32_Product | Select-Object Name, Version

# Output the list
# Write-Output $software

$csvPath = "C:\temp\SoftwareInventoryReportStatus.csv"

$software | Export-Csv -Path $csvPath -NoTypeInformation
Write-Output "Software Inventory Report status exported to $csvPath"

Exit 0