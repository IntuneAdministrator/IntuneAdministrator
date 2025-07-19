<#
.SYNOPSIS
    Removes the `SoftwareDistribution.old` folder used by Windows Update.

.DESCRIPTION
    This script deletes the `SoftwareDistribution.old` folder, which is created during troubleshooting Windows Update issues. 
    This folder contains cached data from Windows Update and is often renamed to force Windows to recreate it for fresh updates.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - Administrative privileges are required to delete system folders in the `C:\Windows` directory.
        - Ensure that the `SoftwareDistribution.old` folder is no longer needed before deleting it.
        - This action can help resolve issues with corrupted update files.
#>

# Remove the SoftwareDistribution.old folder
Remove-Item -Path C:\Windows\SoftwareDistribution.old -Recurse -Force
