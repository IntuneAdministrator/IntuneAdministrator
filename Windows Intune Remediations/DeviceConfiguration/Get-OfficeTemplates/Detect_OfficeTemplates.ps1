<#
.SYNOPSIS
    Checks for the existence of a company Word template in the local Office templates directory.

.DESCRIPTION
    Verifies if the specified template file exists at the local path.
    Outputs the status and returns exit code 0 if found, otherwise 1.
    Designed for Windows 11 24H2 and later systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution with appropriate permissions.
#>

$TemplatePath = "C:\Program Files\Microsoft Office\root\Templates\1033\CompanyLetter.dotx"
if (Test-Path -Path $TemplatePath) {
    Write-Host "Template file exists: $TemplatePath"
    exit 0
} else {
    Write-Host "Template file not found: $TemplatePath"
    exit 1
}
