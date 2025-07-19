<#
.SYNOPSIS
    Ensures a specific registry key is set and a related service is running.

.DESCRIPTION
    Checks if the specified registry key and value exist; creates or updates them as necessary.
    Verifies that the specified service is running; starts it if it is stopped.
    Useful for enforcing compliance settings on Windows 11 24H2 and above.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges. Suitable for local or remote deployment via Intune/GPO.
#>

# Ensure the registry key is set and the service is running
$regPath = "HKLM:\Software\MyCompany\Settings"
$regName = "ComplianceSetting"
$regValue = "Enabled"
$serviceName = "MyService"

if (-Not (Test-Path "$regPath\$regName")) {
    New-Item -Path $regPath -Force | Out-Null
    New-ItemProperty -Path $regPath -Name $regName -Value $regValue -PropertyType String -Force | Out-Null
} else {
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue
}

$service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
if ($service.Status -ne "Running") {
    Start-Service -Name $serviceName
}
