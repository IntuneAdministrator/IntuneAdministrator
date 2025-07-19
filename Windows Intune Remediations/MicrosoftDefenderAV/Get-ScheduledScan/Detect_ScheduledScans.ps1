<#
.SYNOPSIS
    Checks if scheduled scans are configured in Windows Defender.

.DESCRIPTION
    This script checks whether the quick scan schedule is configured in Windows Defender.
    If a quick scan schedule is set, the script outputs "Scheduled scans are configured" and exits with code 0.
    If no schedule is set, it outputs "Scheduled scans are not configured" and exits with code 1.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses the `Get-MpPreference` cmdlet to check the quick scan schedule time.
        - Ensure that Windows Defender is installed and up-to-date on the system.
#>

# Check if scheduled scans are configured
$scanSchedule = Get-MpPreference | Select-Object -ExpandProperty ScanScheduleQuickScanTime

if ($scanSchedule) {
    Write-Output "Scheduled scans are configured."
    exit 0
} else {
    Write-Output "Scheduled scans are not configured."
    exit 1
}
