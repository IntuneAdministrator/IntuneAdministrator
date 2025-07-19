<#
.SYNOPSIS
    Restarts a specified service on the system.

.DESCRIPTION
    This script restarts the service with the given name. In this case, it specifically restarts the "wuauserv" service, which is the Windows Update service.
    This can be useful when troubleshooting issues with Windows Update or after making configuration changes that require a restart of the service.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script restarts the Windows Update service (`wuauserv`), which is responsible for managing Windows updates.
        - Ensure that you have appropriate privileges to restart services, particularly system-level services.
        - You can modify the service name to restart other services as needed.
#>

# Restart a service
Restart-Service -Name "wuauserv"
