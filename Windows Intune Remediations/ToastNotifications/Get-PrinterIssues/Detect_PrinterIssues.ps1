<#
.SYNOPSIS
    Checks the printer status for issues and returns an exit code.

.DESCRIPTION
    This script checks the status of all printers on the system and returns an exit code based on whether any printers are experiencing issues.
    It considers any printer with a status other than 'Idle' as having an issue.
    If issues are detected, it returns exit code 1; otherwise, it returns exit code 0.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows systems with PowerShell and `Get-Printer` cmdlet available.
    Usage        : Local execution or deployment in managed environments.
#>

# Retrieve printers with a status other than 'Idle'
$printerStatus = Get-Printer | Where-Object { $_.PrinterStatus -ne 'Idle' }

if ($printerStatus) {
    # Printer issues detected, output message and exit with code 1
    Write-Output "Printer issues detected"
    exit 1
} else {
    # No issues detected, exit with code 0
    exit 0
}
