<#
.SYNOPSIS
    Closes all running Outlook processes and clears the Outlook cache folder.

.DESCRIPTION
    The script detects any running Outlook processes, including classic and New Outlook versions, and forcefully terminates them.
    After ensuring Outlook is fully closed, it clears the local Outlook cache folder stored under the user's LocalAppData directory.
    This helps resolve issues related to corrupted cache or Outlook performance problems.
    Finally, it notifies the user via a Windows Forms message box that the cache clearance and Outlook closure have completed successfully.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 10/11, Outlook Classic and New Outlook clients
    Requires     : PowerShell with access to System.Windows.Forms assembly
                   Appropriate permissions to terminate processes and delete user cache files
#>

# Load Windows Forms to enable MessageBox functionality (for user notifications)
# This is necessary to provide a pop-up message at the end of the script for user notification.
Add-Type -AssemblyName "System.Windows.Forms"

# Define the path where Outlook stores its cache files.
# The cache is stored in the LOCALAPPDATA folder, and this variable will be used for clearing it later.
$outlookCachePath = "$env:LOCALAPPDATA\Microsoft\Outlook"

# Function to kill a process by its Process Id (PID)
# This function is designed to stop any process by its unique Process ID (PID).
function Kill-ProcessById {
    param (
        [int]$Id,        # Process ID to be terminated, provided by the calling function
        [string]$Name     # Name of the process being killed, for logging purposes
    )

    try {
        # Attempt to stop the process using its ID.
        # -Force forces termination even if the process is not responding.
        # -ErrorAction Stop ensures that any error stops the script execution and jumps to the catch block.
        Write-Host "Killing process: $Name (ID: $Id)"
        Stop-Process -Id $Id -Force -ErrorAction Stop  # Forcefully stop the process
    } catch {
        # Handle any errors that occur during the process termination (e.g., process not found).
        # The error message from the exception is logged for debugging purposes.
        Write-Warning "Failed to kill $Name: $($_.Exception.Message)"
    }
}

# Function to clear Outlook's cache folder.
# This function checks if the Outlook cache folder exists, then removes it.
function Clear-OutlookCache {
    # Verify if the Outlook cache folder exists before attempting to remove it.
    # If the folder doesn't exist, the function will notify the user without trying to delete it.
    if (Test-Path $outlookCachePath) {
        try {
            # Proceed to remove the cache folder and all its contents recursively.
            # -Recurse removes all files and subdirectories.
            # -Force ensures that read-only files are also deleted.
            Write-Host "Clearing Outlook cache at: $outlookCachePath"
            Remove-Item -Path $outlookCachePath -Recurse -Force -ErrorAction Stop  # Force delete all files
        } catch {
            # If there is an issue removing the cache (e.g., access denied), a warning message is shown.
            Write-Warning "Failed to clear cache: $($_.Exception.Message)"
        }
    } else {
        # If the Outlook cache folder does not exist, notify the user that no action is needed.
        Write-Host "Outlook cache folder not found: $outlookCachePath"
    }
}

# Try to find the process for Classic Outlook (using specific Office path).
# This identifies the classic version of Outlook installed in the Office path, for processes related to older versions.
$classicOutlook = Get-Process -ErrorAction SilentlyContinue | Where-Object {
    $_.ProcessName -eq "OUTLOOK" -and ($_.Path -match "Microsoft Office\\root\\Office")  # Match classic Office Outlook path
}

if ($classicOutlook) {
    # If Classic Outlook is found, attempt to kill each instance of it.
    foreach ($proc in $classicOutlook) {
        Kill-ProcessById -Id $proc.Id -Name $proc.ProcessName  # Kill the process using the defined function
    }
} else {
    # If Classic Outlook is not found, attempt to find and kill any other Outlook processes (e.g., New Outlook).
    # This handles situations where the user may have switched to the New Outlook client or if multiple versions exist.
    $allOutlook = Get-Process -ErrorAction SilentlyContinue | Where-Object {
        $_.ProcessName -like "*outlook*"  # Match any Outlook process, including New Outlook
    }

    # Loop through all found Outlook processes and kill each one.
    foreach ($proc in $allOutlook) {
        Kill-ProcessById -Id $proc.Id -Name $proc.ProcessName  # Terminate the Outlook process
    }
}

# Now clear the Outlook cache after ensuring that the Outlook process is no longer running.
Clear-OutlookCache  # Function call to clear cache

# Display a message box to notify the user of successful completion.
# The message box will indicate that the cleanup has been completed, and no further actions are required.
[System.Windows.Forms.MessageBox]::Show(
    'Outlook has been closed and cache cleared successfully.',  # Message content displayed to the user
    'Cleanup Complete',                                      # Title of the message box
    [System.Windows.Forms.MessageBoxButtons]::OK,            # Button displayed in the MessageBox (OK button)
    [System.Windows.Forms.MessageBoxIcon]::Information        # Icon displayed in the MessageBox (Information icon)
)
