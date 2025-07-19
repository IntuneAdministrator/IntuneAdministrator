<#
.SYNOPSIS
    Enables Windows Defender real-time monitoring.

.DESCRIPTION
    Attempts to enable real-time protection using Set-MpPreference.
    Outputs success or failure messages and exits with corresponding codes.
    Designed for Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges.
#>

try {
    # Enable real-time monitoring
    Set-MpPreference -DisableRealtimeMonitoring $false
    Write-Output "Device Remediated"
    exit 0
}
catch {
    Write-Output "Remediation Failed"
    exit 1
}
