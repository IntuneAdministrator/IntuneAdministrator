<#
.SYNOPSIS
    Enables User Account Control (UAC) on the system.

.DESCRIPTION
    Checks the registry key that controls UAC (EnableLUA).
    If UAC is disabled or the key is missing, enables it by setting the registry value to 1.
    Ensures security best practices by enforcing UAC prompts.
    Designed for Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges. Suitable for local or remote deployment via Intune/GPO.
#>

# Check if UAC is enabled
$uacStatus = Get-ItemPropertyValue -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLUA' -ErrorAction SilentlyContinue

if ($null -eq $uacStatus -or $uacStatus -eq 0) {
    # Enable UAC
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name 'EnableLUA' -Value 1
    Write-Output "UAC has been enabled."
} else {
    Write-Output "UAC is already enabled."
}
