<#
.SYNOPSIS
    Schedules daily quick scans and weekly full scans for Windows Defender.

.DESCRIPTION
    This script configures Windows Defender to perform quick scans daily and full scans weekly.
    The quick scan is scheduled to run 24 hours from the current time, and the full scan is scheduled to run 7 days from the current time.
    If successful, the script exits with code 0.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses the `Set-MpPreference` cmdlet to schedule quick and full scans.
        - Ensure that you have administrative privileges to modify Windows Defender settings.
        - The scheduled scan times are relative to the current time (quick scan in 24 hours, full scan in 7 days).
#>

# Schedule quick scans daily and full scans weekly
Set-MpPreference -ScanScheduleQuickScanTime (Get-Date).AddDays(1).TimeOfDay
Set-MpPreference -ScanScheduleFullScanTime (Get-Date).AddDays(7).TimeOfDay
exit 0
