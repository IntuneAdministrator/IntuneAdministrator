<#
.SYNOPSIS
    Detects local user accounts inactive for a specified threshold.

.DESCRIPTION
    Retrieves all local user accounts.
    Checks the last logon date for each user.
    If any user account has been inactive longer than the defined threshold (default 90 days), outputs the account and exits with code 1.
    Otherwise, confirms no inactive accounts and exits with code 0.
    Designed for Windows 11 24H2 and newer.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires appropriate permissions to read user account info.
#>

# Define the inactivity threshold in days
$inactivityThreshold = 90

# Get the current date
$currentDate = Get-Date

# Get all local user accounts
$userAccounts = Get-LocalUser

foreach ($user in $userAccounts) {
    # Use the cached object property directly to avoid redundant calls
    $lastLogonDate = $user.LastLogon

    if ($lastLogonDate -and $lastLogonDate -lt $currentDate.AddDays(-$inactivityThreshold)) {
        Write-Output "Inactive user account detected: $($user.Name)"
        exit 1
    }
}

Write-Output "No inactive user accounts detected."
exit 0
