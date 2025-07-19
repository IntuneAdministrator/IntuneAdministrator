<#
.SYNOPSIS
    Copies a company Word template to the local Office templates directory.

.DESCRIPTION
    Checks for the existence of the specified template file in a central network share.
    Copies the template file to the local Office template directory, overwriting if it exists.
    Ensures the latest company template is available for users.
    Designed for Windows 11 24H2 and later environments.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires network access and appropriate permissions to copy files.
#>

$SourcePath = "\\server\share\Templates\CompanyLetter.dotx"
$DestinationPath = "C:\Program Files\Microsoft Office\root\Templates\1033\CompanyLetter.dotx"

if (Test-Path -Path $SourcePath) {
    Copy-Item -Path $SourcePath -Destination $DestinationPath -Force
    Write-Host "Template file copied to: $DestinationPath"
} else {
    Write-Host "Template file not found in the central repository."
}
