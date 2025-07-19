<#
.SYNOPSIS
    Updates the security intelligence (virus definitions) in Windows Defender.

.DESCRIPTION
    This script updates the security intelligence (virus definitions) by using the `Update-MpSignature` cmdlet.
    If successful, the script exits with code 0 to indicate that the update has been completed.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses the `Update-MpSignature` cmdlet to perform an update of Windows Defender's security intelligence.
        - Ensure that you have an active internet connection to retrieve the latest updates.
        - Administrative privileges may be required to run this script.
#>

# Update security intelligence
Update-MpSignature
exit 0
