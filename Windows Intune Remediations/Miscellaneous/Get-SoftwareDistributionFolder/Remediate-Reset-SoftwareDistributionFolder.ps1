<#
.SYNOPSIS
    Stops the Windows Update service, renames the SoftwareDistribution folder, and restarts the service.

.DESCRIPTION
    This script performs a series of actions to reset the Windows Update service by stopping it, renaming the SoftwareDistribution folder (which stores update files), 
    and then restarting the service. This can be useful for resolving issues related to Windows Update corruption or problems with update downloads.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script stops the Windows Update service (`wuauserv`), renames the `SoftwareDistribution` folder, and restarts the service.
        - Administrative privileges are required to stop/start services and rename system folders.
        - Renaming the `SoftwareDistribution` folder forces Windows to recreate the folder and re-download any necessary update files.
#>

# Stop the Windows Update service
Get-Service -Name wuauserv | Stop-Service

# Rename the SoftwareDistribution folder to reset Windows Update cache
Rename-Item -Path C:\Windows\SoftwareDistribution -NewName SoftwareDistribution.old

# Start the Windows Update service again
Get-Service -Name wuauserv | Start-Service
