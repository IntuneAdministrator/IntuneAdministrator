<#
.SYNOPSIS
    Removes corrupted or oversized user profiles based on defined criteria.

.DESCRIPTION
    Retrieves all non-special user profiles on the system.
    Removes profiles if their status indicates corruption.
    Calculates profile size; removes profiles exceeding the specified size threshold (default 500 MB).
    Logs each removal action.
    Designed for Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges. Profile removal is permanent.
#>

# Define the size threshold in MB
$sizeThresholdMB = 500

# Get all user profiles excluding special system profiles
$userProfiles = Get-WmiObject -Class Win32_UserProfile | Where-Object { $_.Special -eq $false }

foreach ($profile in $userProfiles) {
    # Remove profile if corrupted (Status not 0)
    if ($profile.Status -ne 0) {
        Remove-WmiObject -InputObject $profile
        Write-Output "Removed corrupted profile: $($profile.LocalPath)"
        continue
    }

    # Calculate profile size in MB
    $profileSizeBytes = (Get-ChildItem -Path $profile.LocalPath -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    $profileSizeMB = if ($profileSizeBytes) { [math]::Round($profileSizeBytes / 1MB, 2) } else { 0 }

    # Remove profile if size exceeds threshold
    if ($profileSizeMB -gt $sizeThresholdMB) {
        Remove-WmiObject -InputObject $profile
        Write-Output "Removed large profile: $($profile.LocalPath) - Size: $profileSizeMB MB"
    }
}

Write-Output "User profile remediation tasks completed."
