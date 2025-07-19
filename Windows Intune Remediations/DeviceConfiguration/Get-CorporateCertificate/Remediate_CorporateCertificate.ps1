<#
.SYNOPSIS
    Installs a corporate certificate into the local machine’s personal certificate store.

.DESCRIPTION
    Imports the specified certificate file (.cer) into the LocalMachine\My certificate store.
    Ensures the system trusts certificates issued by the corporate authority.
    Intended for Windows 11 24H2 and newer.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges. Suitable for local or remote deployment via Intune/GPO.
#>

# Install the certificate
Import-Certificate -FilePath "C:\Path\To\CorporateCert.cer" -CertStoreLocation Cert:\LocalMachine\My
Write-Output "Certificate installed"
