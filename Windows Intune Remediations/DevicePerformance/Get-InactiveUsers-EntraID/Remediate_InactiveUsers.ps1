<#
.SYNOPSIS
    Detects user profiles inactive for a specified threshold and optionally removes them.

.DESCRIPTION
    Retrieves all non-special user profiles on the system.
    Calculates the days since each profile was last used.
    Logs profiles inactive for more than the defined threshold (default 90 days).
    Optionally, can remove these inactive profiles (commented out for safety).
    Designed for Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges to remove profiles.
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
        # Log the profile that is inactive
        Write-Output "Inactive profile detected: $($profile.LocalPath) - Last used: $lastUseTime"
        
        # Optionally, remove the inactive profile by uncommenting the following line:
        # Remove-WmiObject -InputObject $profile
    }
}
