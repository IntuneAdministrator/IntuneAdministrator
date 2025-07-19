<#
.SYNOPSIS
    Copies the NormalEmail Outlook template to the user’s local Templates folder.

.DESCRIPTION
    Checks for the existence of the NormalEmail.dotm template in a central network share.
    Copies the template to the user’s local Microsoft Templates folder, overwriting if necessary.
    Ensures users have the latest Outlook email template.
    Designed for Windows 11 24H2 and later.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Runs under user context with access to network share.
#>

$SourcePath = "\\server\share\Templates\NormalEmail.dotm"
$DestinationPath = "$env:APPDATA\Microsoft\Templates\NormalEmail.dotm"

if (Test-Path -Path $SourcePath) {
    Copy-Item -Path $SourcePath -Destination $DestinationPath -Force
    Write-Host "NormalEmail.dotm template updated."
} else {
    Write-Host "Template file not found in the central repository."
}
