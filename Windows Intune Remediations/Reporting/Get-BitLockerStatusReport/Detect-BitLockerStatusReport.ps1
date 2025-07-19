<#
.SYNOPSIS
    Retrieves and exports the BitLocker encryption status of volumes.

.DESCRIPTION
    This script checks the encryption status of all volumes on the system, including the encryption percentage and current volume status. 
    The BitLocker status is exported to a CSV file for reporting or auditing purposes.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses the `Get-BitLockerVolume` cmdlet to query the BitLocker encryption status.
        - Administrative privileges may be required to access BitLocker encryption status.
        - The result is saved to a CSV file for further analysis.
#>

# Check BitLocker encryption status
$bitLockerStatus = Get-BitLockerVolume | Select-Object MountPoint, VolumeStatus, EncryptionPercentage

# Output the BitLocker encryption status
# Write-Output $bitLockerStatus

$csvPath = "C:\temp\BitLockerStatus.csv"

$bitLockerStatus | Export-Csv -Path $csvPath -NoTypeInformation
Write-Output "BitLocker status exported to $csvPath"

Exit 0
