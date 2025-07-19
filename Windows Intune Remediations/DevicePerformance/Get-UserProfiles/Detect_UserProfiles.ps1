<#
.SYNOPSIS
    Detects corrupted or oversized user profiles based on defined criteria.

.DESCRIPTION
    Retrieves all non-special user profiles on the system.
    Checks each profile for corruption (Status not 0).
    Calculates profile size and flags profiles exceeding the size threshold (default 500 MB).
    Outputs details of non-compliant profiles.
    Exits with code 1 if any non-compliant profiles are found; otherwise exits 0.
    Designed for Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution.
#>

# Define the size threshold in MB
$sizeThresholdMB = 500

# Get all user profiles excluding special system profiles
$userProfiles = Get-WmiObject -Class Win32_UserProfile | Where-Object { $_.Special -eq $false }

# Initialize flag for non-compliance
$nonCompliant = $false

foreach ($profile in $userProfiles) {
    # Check for corrupted profiles
    if ($profile.Status -ne 0) {
        Write-Output "Corrupted profile detected: $($profile.LocalPath)"
        $nonCompliant = $true
    }

    # Calculate profile size in MB with error handling for inaccessible paths
    $profileSizeBytes = (Get-ChildItem -Path $profile.LocalPath -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
    $profileSizeMB = if ($profileSizeBytes) { [math]::Round($profileSizeBytes / 1MB, 2) } else { 0 }

    # Check if profile size exceeds threshold
    if ($profileSizeMB -gt $sizeThresholdMB) {
        Write-Output "Profile size exceeds threshold: $($profile.LocalPath) - Size: $profileSizeMB MB"
        $nonCompliant = $true
    }
}

if ($nonCompliant) {
    exit 1
} else {
    Write-Output "All user profiles are compliant."
    exit 0
}
