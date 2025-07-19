<#
.SYNOPSIS
    Retrieves and exports user login times from the Security event log.

.DESCRIPTION
    This script retrieves user login times (Event ID 4624) from the Security event log.
    It outputs the login details, including the timestamp and associated user information, to a CSV file.
    The script is intended for tracking login events on a system for auditing or reporting purposes.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - Administrative privileges may be required to access the Security event log.
        - Ensure the path specified in `$csvPath` is valid and writable.
        - The script retrieves Event ID 4624, which represents a successful login.
#>

# Check user login times
$userLogins = Get-EventLog -LogName Security -InstanceId 4624 | Select-Object TimeGenerated, ReplacementStrings

# Output the user login times
# Write-Output $userLogins

$csvPath = "C:\temp\UserLoginsStatus.csv"

$userLogins | Export-Csv -Path $csvPath -NoTypeInformation
Write-Output "User Logins status exported to $csvPath"

Exit 0
