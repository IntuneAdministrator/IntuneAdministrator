<#
.SYNOPSIS
    Disables local user accounts inactive for a specified threshold.

.DESCRIPTION
    Retrieves all local user accounts.
    Checks the last logon date for each user.
    Disables user accounts that have not logged in within the defined inactivity threshold (default 90 days).
    Logs each disabled user account.
    Designed for Windows 11 24H2 and newer.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges to disable user accounts.
#>

# Define the inactivity threshold in days
$inactivityThreshold = 90

# Get the current date
$currentDate = Get-Date

# Get all local user accounts
$userAccounts = Get-LocalUser

foreach ($user in $userAccounts) {
    # Get the last logon date for the user
    $lastLogonDate = $user.LastLogon

    # Some accounts might not have a LastLogon value (never logged on), handle accordingly
    if ($lastLogonDate -and $lastLogonDate -lt $currentDate.AddDays(-$inactivityThreshold)) {
        # Disable inactive user account
        Disable-LocalUser -Name $user.Name
        Write-Output "Disabled inactive user account: $($user.Name)"
    }
}

Write-Output "Inactive user accounts have been disabled."
