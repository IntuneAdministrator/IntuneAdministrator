<#
.SYNOPSIS
    Retrieves and exports disk space usage for all file system drives.

.DESCRIPTION
    This script checks the disk space usage for all file system drives on the system.
    It outputs the used and free space for each drive in gigabytes (GB) and exports the result to a CSV file.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - This script uses the `Get-PSDrive` cmdlet to retrieve information about file system drives.
        - The result is rounded to two decimal places for readability.
        - The output is saved to a CSV file at the specified path.
#>

# Check disk space usage
$diskSpace = Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{Name="Used(GB)";Expression={[math]::round($_.Used/1GB,2)}}, @{Name="Free(GB)";Expression={[math]::round($_.Free/1GB,2)}}

# Output the disk space usage
# Write-Output $diskSpace

$csvPath = "C:\temp\DiskSpaceStatus.csv"

$diskSpace | Export-Csv -Path $csvPath -NoTypeInformation
Write-Output "Disk Space status exported to $csvPath"

Exit 0
