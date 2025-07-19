<#
.SYNOPSIS
    Checks if BitLocker encryption is enabled on the system drive (C:).

.DESCRIPTION
    Uses Get-BitLockerVolume cmdlet to determine the protection status of the C: drive.
    Outputs the current BitLocker status and returns an exit code:
    0 if BitLocker is enabled, 1 if not enabled.
    Designed for Windows 11 24H2 and later systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Local execution or remote deployment via Intune/GPO
#>

# Check if BitLocker is enabled
$bitLockerStatus = Get-BitLockerVolume -MountPoint "C:"

if ($bitLockerStatus.ProtectionStatus -ne "On") {
    Write-Output "BitLocker is not enabled on the system drive."
    exit 1
} else {
    Write-Output "BitLocker is enabled on the system drive."
    exit 0
}
