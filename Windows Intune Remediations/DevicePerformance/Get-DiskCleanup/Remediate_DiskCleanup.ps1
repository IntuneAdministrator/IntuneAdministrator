<#
.SYNOPSIS
    Performs disk cleanup using a predefined cleanup profile.

.DESCRIPTION
    Launches the Windows Disk Cleanup tool (cleanmgr.exe) with the /sagerun option to execute saved cleanup settings.
    Waits for the cleanup process to complete before proceeding.
    Designed for Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Ensure that the cleanup profile 1 is pre-configured via cleanmgr /sageset:1.
#>

# Perform disk cleanup
Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -Wait
Write-Output "Disk cleanup performed"
