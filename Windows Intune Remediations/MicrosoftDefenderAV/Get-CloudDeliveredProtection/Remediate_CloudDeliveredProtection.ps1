<#
.SYNOPSIS
    Enables cloud-delivered protection in Windows Defender.

.DESCRIPTION
    This script enables cloud-delivered protection by setting the `-MAPSReporting` flag to `Advanced` using the `Set-MpPreference` cmdlet.
    If successful, the script exits with code 0 to indicate that cloud-delivered protection has been enabled.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses the `Set-MpPreference` cmdlet to enable cloud-delivered protection via the MAPS (Microsoft Active Protection Service) reporting.
        - Ensure that you have administrative privileges to run this script.
        - Cloud-delivered protection helps enhance Windows Defender's ability to detect and block new and emerging threats.
#>

# Enable cloud-delivered protection
Set-MpPreference -MAPSReporting Advanced
exit 0
