<#
.SYNOPSIS
    Detects whether a specific registry key exists on the system.

.DESCRIPTION
    This script checks if a given registry key exists in the Windows Registry.
    In this case, it checks for the registry key located at `HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\SideCarPolicies\Scripts`.
    If the registry key is found, it exits with code 0. If not, it exits with code 1.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - This script uses `Test-Path` to verify the existence of the registry key.
        - Administrative privileges may be required to access registry keys under `HKLM`.
        - Customize the `$RegistryPath` variable to detect other registry keys as needed.
#>

# Detect if the registry key exists
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\IntuneManagementExtension\SideCarPolicies\Scripts"
if (Test-Path -Path $RegistryPath) {
    Write-Host "Registry key exists: $RegistryPath"
    exit 0
} else {
    Write-Host "Registry key not found: $RegistryPath"
    exit 1
}
