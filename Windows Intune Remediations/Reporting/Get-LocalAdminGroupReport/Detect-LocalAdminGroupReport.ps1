<#
.SYNOPSIS
    Retrieves and exports membership information for the local Administrators group.

.DESCRIPTION
    This script checks the members of the local "Administrators" group and exports the membership details 
    (including the name and principal source) to a CSV file for reporting or auditing purposes.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses the `Get-LocalGroupMember` cmdlet to query members of the "Administrators" group.
        - Administrative privileges are required to query local group membership.
        - The result is saved to a CSV file for further analysis.
#>

# Check local administrators group membership
$localAdmins = Get-LocalGroupMember -Group "Administrators" | Select-Object Name, PrincipalSource

# Output the local administrators group membership
# Write-Output $localAdmins

$csvPath = "C:\temp\LocalAdminGroupStatus.csv"

$localAdmins | Export-Csv -Path $csvPath -NoTypeInformation
Write-Output "Local Admin Group status exported to $csvPath"

Exit 0
