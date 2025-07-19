<#
.SYNOPSIS
    Checks for pending Windows updates and returns an appropriate exit code.

.DESCRIPTION
    Uses the `Get-WindowsUpdate` cmdlet to check if there are any pending updates.
    If there are pending updates, the script returns an exit code of 1.
    If there are no pending updates, the script returns an exit code of 0.
    The `-AcceptAll` parameter accepts all updates, and `-IgnoreReboot` prevents the script from rebooting the system.
    
.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 10 and Windows 11 systems with the `Get-WindowsUpdate` cmdlet available.
    Usage        : Local execution or remote deployment via Intune/GPO.
#>

$updates = Get-WindowsUpdate -AcceptAll -IgnoreReboot
if ($updates.Count -gt 0) {
    Write-Output "Pending Windows updates"
    exit 1
} else {
    exit 0
}
