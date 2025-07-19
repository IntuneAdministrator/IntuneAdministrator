<#
.SYNOPSIS
    Checks if a specific certificate is installed in the local machine’s personal store.

.DESCRIPTION
    Searches the LocalMachine\My certificate store for a certificate with the specified subject name.
    Outputs whether the certificate is installed and returns exit code 0 if found, otherwise 1.
    Designed for Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires read access to the local machine certificate store. Suitable for local or remote execution.
#>

# Check if the certificate is installed
$cert = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Subject -eq "CN=CorporateCert" }
if ($cert) {
    Write-Output "Certificate is installed"
    exit 0
} else {
    Write-Output "Certificate is not installed"
    exit 1
}
