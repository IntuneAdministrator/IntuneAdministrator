<#
.SYNOPSIS
    Detects if Secure Boot is enabled on the system.

.DESCRIPTION
    Uses the Confirm-SecureBootUEFI cmdlet to determine the Secure Boot status.
    Outputs the status and returns exit code 0 if enabled, otherwise 1.
    Designed for Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges. Suitable for local or remote execution via Intune/GPO.
#>

# Check if Secure Boot is enabled
if (Confirm-SecureBootUEFI) {
    Write-Output "Secure Boot is enabled."
    exit 0
} else {
    Write-Output "Secure Boot is not enabled."
    exit 1
}
