<#
.SYNOPSIS
    Detects whether User Account Control (UAC) is enabled on the system.

.DESCRIPTION
    Reads the EnableLUA registry value to determine UAC status.
    Outputs the current UAC state and returns exit code 0 if enabled, otherwise 1.
    Designed for Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution with appropriate permissions.
#>

# Check if UAC is enabled
$uacStatus = Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLUA' -ErrorAction SilentlyContinue

if ($null -eq $uacStatus) {
    Write-Output "UAC status: NotConfigured"
    exit 1
} elseif ($uacStatus -eq 0) {
    Write-Output "UAC status: Disabled"
    exit 1
} else {
    Write-Output "UAC status: Enabled"
    exit 0
}
