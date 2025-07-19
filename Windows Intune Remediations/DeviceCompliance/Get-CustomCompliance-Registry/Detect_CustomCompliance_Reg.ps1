<#
.SYNOPSIS
    Checks if a specific registry key exists and a related service is running.

.DESCRIPTION
    Verifies the presence of a designated registry key and the running status of a specified service.
    Outputs compliance status based on these checks.
    Designed for Windows 11 24H2 and newer environments.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires appropriate permissions to read registry and service status.
#>

# Check if a specific registry key exists and a service is running
$regPath = "HKLM:\Software\MyCompany\Settings"
$regName = "ComplianceSetting"
$serviceName = "MyService"

$regExists = Test-Path "$regPath\$regName"
$serviceStatus = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

if ($regExists -and $serviceStatus.Status -eq "Running") {
    Write-Output "Compliance settings are in place."
} else {
    Write-Output "Compliance settings are not in place."
}
