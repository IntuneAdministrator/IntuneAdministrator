<#
.SYNOPSIS
    Opens the 'Windows Security' settings page with user confirmation.

.DESCRIPTION
    Prompts the user to confirm opening the Windows Security settings.
    If the user agrees, launches the settings page and logs the action to the Application event log.
    If the user declines, exits without opening the page.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-18
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2
    Requires     : PowerShell with System.Windows.Forms loaded and permission to write event logs
#>

# Load Windows Forms assembly for message boxes
Add-Type -AssemblyName System.Windows.Forms

# Since there are no buttons in this script, width settings don't apply,
# but to match your layout request, if you had buttons, set their width like:
# $buttonAutoPlay.Width = 320
# $buttonBluetooth.Width = 320
# ...

# If you had a window, you could add:
# $window.SizeToContent = 'WidthAndHeight'

# Prompt user for confirmation
$userChoice = [System.Windows.Forms.MessageBox]::Show(
    "Do you want to open the Windows Security settings page?",
    "Confirm Open",
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Question
)

if ($userChoice -eq [System.Windows.Forms.DialogResult]::Yes) {
    # Open the Windows Security settings page
    Start-Process "ms-settings:windowsdefender"

    # Log the action to the Application event log
    try {
        Write-EventLog -LogName Application -Source "Windows Security Settings" -EntryType Information -EventId 1000 -Message "Opened Windows Security settings."
    } catch {
        Write-Warning "Failed to write to event log: $_"
    }
} else {
    Write-Host "Operation cancelled by user."
}

exit
