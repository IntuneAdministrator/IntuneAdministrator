<#
.SYNOPSIS
    Enables network protection in Windows Defender.

.DESCRIPTION
    This script enables network protection by setting the `-EnableNetworkProtection` flag to `Enabled`.
    If successful, the script exits with code 0 to indicate that network protection is enabled.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses the `Set-MpPreference` cmdlet to enable network protection in Windows Defender.
        - Ensure that you have administrative privileges to run this script.
#>

# Enable network protection
Set-MpPreference -EnableNetworkProtection Enabled
exit 0
