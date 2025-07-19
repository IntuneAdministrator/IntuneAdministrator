<#
.SYNOPSIS
    Checks if the system time zone matches the required setting.

.DESCRIPTION
    Retrieves the current system time zone.
    Compares it with the specified required time zone.
    Outputs status and returns exit code 0 if correct, otherwise 1.
    Designed for Windows 11 24H2 and newer.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution with necessary permissions.
#>

# Define the required time zone
$requiredTimeZone = "Pacific Standard Time"

# Get the current time zone
$currentTimeZone = (Get-TimeZone).Id

if ($currentTimeZone -ne $requiredTimeZone) {
    Write-Output "Incorrect time zone: $currentTimeZone"
    exit 1
} else {
    Write-Output "Time zone is correct: $currentTimeZone"
    exit 0
}
