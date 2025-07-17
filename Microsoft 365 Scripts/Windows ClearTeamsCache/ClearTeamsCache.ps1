<#
.SYNOPSIS
    Terminates all Microsoft Teams processes and clears Teams cache folders.

.DESCRIPTION
    This script finds and forcefully stops all running Teams and Teams-related processes.
    It then removes local and roaming Teams cache directories to resolve issues related to corrupted or bloated cache data.
    Finally, it notifies the user with a Windows Forms message box upon successful completion of the cleanup.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 10/11 with Microsoft Teams desktop client
    Requires     : PowerShell with System.Windows.Forms assembly available
                   User permissions to terminate processes and delete cache folders
#>

# Kill all Teams-related processes
# Get all processes that have "teams" in their name, which captures both Teams and any Teams-related processes.
$teamsProcesses = Get-Process | Where-Object { $_.ProcessName -like "*teams*" }

# Loop through each Teams-related process and attempt to stop it
foreach ($process in $teamsProcesses) {
    # Output information to the console to indicate which process is being terminated.
    Write-Host "Terminating process: $($process.ProcessName) (ID: $($process.Id))"
    
    try {
        # Attempt to stop the process forcefully by its process ID
        # The `-Force` parameter ensures that even unresponsive processes are terminated.
        # `-ErrorAction Stop` ensures that any error encountered is caught in the catch block.
        Stop-Process -Id $process.Id -Force -ErrorAction Stop
    } catch {
        # If the process could not be stopped, output a warning message with the error details.
        Write-Warning "Failed to terminate process: $($_.Exception.Message)"
    }
}

# Define cache paths for Teams
# These paths represent the locations where Teams stores its local and roaming cache data on the machine.
$localTeamsPath = "$env:LOCALAPPDATA\Packages\MSTeams_8wekyb3d8bbwe"  # Local cache for Teams (per user profile)
$roamingTeamsPath = "$env:APPDATA\Microsoft\Teams"  # Roaming cache for Teams (app data that roams with user profile)

# Function to remove Teams cache directories if they exist
# The function accepts the path to the cache directory and deletes it if it exists.
function Remove-TeamsCache {
    param([string]$path)  # Accepts the path to the cache folder as a parameter

    # Check if the specified path exists
    if (Test-Path $path) {
        # Inform the user that we are about to remove the cache directory.
        Write-Host "Removing Teams cache at: $path"
        
        try {
            # Attempt to remove the directory and all its contents forcefully and recursively.
            # `-Recurse` ensures that all files and subdirectories are deleted.
            # `-Force` is used to remove files that might be read-only or in use.
            Remove-Item -Path $path -Recurse -Force -ErrorAction Stop
        } catch {
            # If removal fails, output a warning with the error message.
            Write-Warning "Failed to remove $path: $($_.Exception.Message)"
        }
    } else {
        # If the path doesn't exist, inform the user that there is nothing to delete.
        Write-Host "Path does not exist: $path"
    }
}

# Clear both the local and roaming Teams cache directories
# Call the Remove-TeamsCache function to remove both the local and roaming cache directories.
Remove-TeamsCache -path $localTeamsPath
Remove-TeamsCache -path $roamingTeamsPath

# Display a message box to the user indicating the cleanup is complete
# Load Windows Forms to use MessageBox functionality for providing feedback to the user.
Add-Type -AssemblyName "System.Windows.Forms"

# Show the completion message in a message box
[System.Windows.Forms.MessageBox]::Show(
    'Teams-related temporary files and cache have been cleaned successfully.',  # Content to display in the message box
    'Cleanup Complete',  # Title of the message box
    [System.Windows.Forms.MessageBoxButtons]::OK,  # Button type to display (OK button)
    [System.Windows.Forms.MessageBoxIcon]::Information  # Icon type to display (Information icon)
)
