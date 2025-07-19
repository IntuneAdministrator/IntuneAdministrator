<#
.SYNOPSIS
    Retrieves certificates nearing expiry from the local machine's certificate store.

.DESCRIPTION
    This script checks the certificates in the `LocalMachine\My` certificate store to identify those that are 
    set to expire within the next 30 days. The details, including the subject and expiry date, are exported to a CSV file.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - Administrative privileges are required to access certificates in the `LocalMachine` store.
        - The script checks certificates that expire within 30 days and exports the relevant details to a CSV file.
#>

# Check for certificates nearing expiry
$certificates = Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.NotAfter -lt (Get-Date).AddDays(30) } | Select-Object Subject, NotAfter

# Output the certificates nearing expiry
# Write-Output $certificates

$csvPath = "C:\temp\CertificateExpiryStatus.csv"

$certificates | Export-Csv -Path $csvPath -NoTypeInformation
Write-Output "Certificate Expiry status exported to $csvPath"

Exit 0
