<#
.SYNOPSIS
    Retrieves and exports the status of Microsoft Defender Antivirus protection.

.DESCRIPTION
    This script checks the current status of Microsoft Defender Antivirus, including whether the antivirus service is enabled, 
    the version of the service, and the last update time for antivirus signatures. The status information is exported to a CSV file for reporting.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses the `Get-MpComputerStatus` cmdlet to retrieve antivirus service and status details.
        - Administrative privileges may be required to query the antivirus service status.
        - The result is saved to a CSV file for further analysis.
#>

# Check endpoint protection status
$protectionStatus = Get-MpComputerStatus | Select-Object AMServiceEnabled, AMServiceVersion, AntivirusEnabled, AntivirusSignatureLastUpdated

# Output the endpoint protection status
# Write-Output $protectionStatus

$csvPath = "C:\temp\EndpointProtectionStatus.csv"

$protectionStatus | Export-Csv -Path $csvPath -NoTypeInformation
Write-Output "Endpoint Protection status exported to $csvPath"

Exit 0
