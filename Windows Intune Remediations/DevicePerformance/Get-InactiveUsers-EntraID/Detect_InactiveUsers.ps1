<#
.SYNOPSIS
    Checks for user profiles inactive longer than a specified threshold.

.DESCRIPTION
    Retrieves all non-special user profiles on the system.
    Calculates the days since each profile was last used.
    If any profile has been inactive for equal or more than the threshold (default 90 days), exits with code 1.
    If no profiles exceed inactivity threshold, exits with code 0.
    Suitable for Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires appropriate permissions to query user profiles.
#>

# Define the inactivity threshold in days
$inactivityThreshold = 90

# Get the current date
$currentDate = Get-Date

# Get all user profiles on the endpoint (excluding special system profiles)
$userProfiles = Get-WmiObject -Class Win32_UserProfile | Where-Object { $_.Special -eq $false }

foreach ($profile in $userProfiles) {
    # Get the last use time of the profile
    $lastUseTime = [Management.ManagementDateTimeConverter]::ToDateTime($profile.LastUseTime)
    
    # Calculate the number of days since the profile was last used
    $daysInactive = ($currentDate - $lastUseTime).Days
    
    if ($daysInactive -ge $inactivityThreshold) {
        # Exit with code 1 to indicate an inactive profile was detected
        exit 1
    }
}

# Exit with code 0 to indicate no inactive profiles detected
exit 0
