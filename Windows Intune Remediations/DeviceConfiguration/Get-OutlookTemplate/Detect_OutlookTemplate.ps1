<#
.SYNOPSIS
    Checks if the NormalEmail Outlook template exists in the user’s local Templates folder.

.DESCRIPTION
    Verifies the presence of NormalEmail.dotm in the user’s Microsoft Templates directory.
    Outputs status and returns exit code 0 if found, otherwise 1.
    Designed for Windows 11 24H2 and later.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Runs under the context of the user.
#>

$TemplatePath = "$env:APPDATA\Microsoft\Templates\NormalEmail.dotm"
if (Test-Path -Path $TemplatePath) {
    Write-Host "NormalEmail.dotm template exists: $TemplatePath"
    exit 0
} else {
    Write-Host "NormalEmail.dotm template not found: $TemplatePath"
    exit 1
}
