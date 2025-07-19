<#
.SYNOPSIS
    Resets and restarts the Windows Search service, clearing its database and reinitializing indexing.

.DESCRIPTION
    This script disables and stops the Windows Search service, resets its setup state in the registry,
    deletes the search index database files, and then re-enables and restarts the service with delayed-auto start.
    It uses a loop to ensure the service successfully starts and displays a message box upon completion.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-17
    Version     : 1.0

.NOTES
    Requires running with Administrator privileges.
    Compatible with Windows 11 24H2 and later.
    Uses .NET Framework for Windows Forms.
#>

# Load Windows Forms to use MessageBox functionality
Add-Type -AssemblyName System.Windows.Forms

# Disable and stop the Windows Search service
sc.exe config wsearch start= disabled | Out-Null
sc.exe stop wsearch | Out-Null

# Reset the setup status in the registry
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Search" -Name "SetupCompletedSuccessfully" -Type DWord -Value 0

# Remove search index database files
Remove-Item -Path "$env:ProgramData\Microsoft\Search\Data\Applications\Windows\Windows.db" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:ProgramData\Microsoft\Search\Data\Applications\Windows\Windows-gather.db" -Force -ErrorAction SilentlyContinue

# Attempt to re-enable and start the service with retry logic
do {
    sc.exe config wsearch start= delayed-auto | Out-Null
    sc.exe start wsearch | Out-Null
    Start-Sleep -Seconds 2
    $service = Get-Service -Name wsearch -ErrorAction SilentlyContinue
} while ($service.Status -ne 'Running')

# Show completion message to user
[System.Windows.Forms.MessageBox]::Show(
    "Windows Search service restarted successfully.`nThe fix can take up to 7 days.",
    "Process Complete",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)
