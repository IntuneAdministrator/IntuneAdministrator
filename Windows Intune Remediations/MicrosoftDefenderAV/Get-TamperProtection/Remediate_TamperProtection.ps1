<#
.SYNOPSIS
    Enables tamper protection in Windows Defender.

.DESCRIPTION
    This script enables tamper protection by setting the `-DisableTamperProtection` flag to `$false` using the `Set-MpPreference` cmdlet.
    If successful, the script exits with code 0 to indicate that tamper protection has been enabled.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses the `Set-MpPreference` cmdlet to enable tamper protection.
        - Ensure that you have administrative privileges to run this script.
#>

# Enable tamper protection
Set-MpPreference -DisableTamperProtection $false
exit 0
