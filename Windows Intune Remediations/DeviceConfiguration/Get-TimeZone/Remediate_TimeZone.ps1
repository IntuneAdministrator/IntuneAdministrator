<#
.SYNOPSIS
    Sets the system time zone to a specified value.

.DESCRIPTION
    Defines the required time zone and applies it using Set-TimeZone.
    Ensures system time zone compliance, important for regional settings and logging accuracy.
    Designed for Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges. Suitable for local or remote deployment via Intune/GPO.
#>

# Define the required time zone
$requiredTimeZone = "Pacific Standard Time"

# Set the time zone
Set-TimeZone -Id $requiredTimeZone

Write-Output "Time zone has been set to: $requiredTimeZone"
