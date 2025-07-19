<#
.SYNOPSIS
    Cleans user temp files, Windows temp files, prefetch data, and recycle bin contents on Windows 11 24H2.

.DESCRIPTION
    Removes temporary files and folders safely from key system locations to free up space and improve performance.
    Includes error handling and a completion message box for user feedback.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-16
    Version     : 1.0

.NOTES
    Run with Administrator privileges to ensure full access.
#>

# Get current username
# The script uses the environment variable `$env:USERNAME` to determine the current user's username.
# This is important for targeting the user's temporary files and directories in a personalized manner.
$user = $env:USERNAME

# Define paths to key directories to clear
# These paths include the user's temporary files, system-wide temp files, prefetch data, and the recycle bin.
# These locations store cached and temporary data that can safely be removed to free up space and improve system performance.
$userTemp = "C:\Users\$user\AppData\Local\Temp"  # User-specific temporary folder
$windowsTemp = "C:\Windows\Temp"  # System-wide temporary folder
$prefetch = "C:\Windows\Prefetch"  # Prefetch data, which speeds up application launch by storing frequently used data
$recycleBin = "C:\$Recycle.bin"  # Recycle Bin directory for all users

# Function to safely remove files and folders
# This function recursively clears the contents of a specified folder. It’s used for cleaning up temp folders.
function Clear-Folder {
    param ([string]$path)  # Accepts a parameter for the path to the folder that needs to be cleared

    # Check if the folder exists before attempting removal
    if (Test-Path $path) {
        try {
            # Remove all files and subfolders within the specified folder
            # The `-Recurse` flag ensures that all nested files and folders are removed,
            # and `-Force` is used to delete files even if they are hidden or read-only.
            # `-ErrorAction SilentlyContinue` ensures that the script continues even if an error occurs (e.g., file locked).
            Remove-Item "$path\*" -Recurse -Force -ErrorAction SilentlyContinue
        } catch {
            # If the folder cannot be cleared, a warning with the error message is logged.
            Write-Warning "Failed to clear $path: $($_.Exception.Message)"
        }
    } else {
        # If the folder doesn't exist, inform the user that there’s nothing to clear.
        Write-Host "Path does not exist: $path"
    }
}

# Clear Temp folders and Prefetch data
# Calls the `Clear-Folder` function to delete the contents of the specified directories.
# This removes unnecessary temporary files that can accumulate over time, freeing up system resources.
Clear-Folder $userTemp  # Clear the user's temp folder
Clear-Folder $windowsTemp  # Clear the system-wide temp folder
Clear-Folder $prefetch  # Clear the prefetch folder, which stores frequently used files for quicker access

# Remove recycle bin contents
# Check if the Recycle Bin exists at the specified path, and if it does, attempt to clear its contents.
# The Recycle Bin is where deleted files are temporarily stored before being permanently deleted.
if (Test-Path $recycleBin) {
    try {
        # Remove all items from the Recycle Bin folder recursively and forcefully.
        # `-Recurse` ensures that all files and folders are deleted, and `-Force` allows the removal of even hidden files.
        # `-ErrorAction SilentlyContinue` suppresses any errors (e.g., if files are in use or locked).
        Remove-Item "$recycleBin\*" -Recurse -Force -ErrorAction SilentlyContinue
    } catch {
        # If the operation fails, a warning with the error message is displayed.
        Write-Warning "Failed to clear Recycle Bin: $($_.Exception.Message)"
    }
} else {
    # If the Recycle Bin path doesn't exist, notify the user that the path could not be found.
    Write-Host "Recycle Bin path not found: $recycleBin"
}

# Show completion message box
# Use Windows Forms to display a message box to the user, indicating that the cleanup is complete.
# A message box improves user experience by providing feedback after the script finishes.
Add-Type -AssemblyName "System.Windows.Forms"  # Load the Windows Forms assembly to use MessageBox functionality

# Show the completion message box
[System.Windows.Forms.MessageBox]::Show(
    'Temporary files, prefetch data, and recycle bin have been cleaned successfully.',  # Content to display in the message box
    'Cleanup Complete',  # Title of the message box
    [System.Windows.Forms.MessageBoxButtons]::OK,  # Button to show (OK button)
    [System.Windows.Forms.MessageBoxIcon]::Information  # Icon to show (Information icon)
)
