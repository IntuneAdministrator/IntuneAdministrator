<#
.SYNOPSIS
    Checks for a pending system reboot.

.DESCRIPTION
    This script checks if there is a pending system reboot by querying the registry for the `RebootPending`
    key in the `Component Based Servicing` registry path. It outputs a message indicating whether a reboot is pending.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script queries the registry to check if there is a pending reboot request.
        - Administrative privileges may be required to access the relevant registry keys.
#>

# Check for pending reboot
$pendingReboot = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -ErrorAction SilentlyContinue

if ($pendingReboot) {
    Write-Output "Reboot is pending."
} else {
    Write-Output "No reboot pending."
}

Exit 0
