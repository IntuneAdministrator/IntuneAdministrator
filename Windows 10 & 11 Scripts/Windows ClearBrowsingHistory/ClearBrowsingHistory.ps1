<#
.SYNOPSIS
    Closes Outlook and resets all email rules to default using the /cleanrules switch.

.DESCRIPTION
    Checks if Microsoft Outlook is running and forcefully closes it to avoid conflicts.
    After ensuring Outlook is closed, it restarts Outlook with the /cleanrules switch to clear all user-defined rules.
    Displays a Windows Forms message box to inform the user that the reset was successful.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 with Office 365 Outlook Desktop  
    Requires     : Outlook installed and accessible via system PATH  
                   .NET Framework for Windows Forms message boxes  
#>

# Load Windows Forms to enable displaying message boxes
# This cmdlet loads the necessary Windows Forms assembly for displaying message boxes to the user
# It is essential for notifying users of script completion or any errors during execution.
Add-Type -AssemblyName System.Windows.Forms  # Load Windows Forms to interact with message boxes

# Function to clear Microsoft Edge browsing and session data
function Clear-EdgeData {
    Write-Output "`n--- Microsoft Edge Data Cleanup ---"  # Output to indicate Edge data cleanup is starting

    # Define the path where Microsoft Edge stores user data for the Default profile
    $EdgeDataPath = "$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default"  # Path to Edge's default user data folder
    
    # Check if the Edge user data path exists
    if (Test-Path $EdgeDataPath) {
        # List of files and folders to delete that contain Edge's browsing data
        $itemsToDelete = @(
            "$EdgeDataPath\History",                  # History file
            "$EdgeDataPath\Cookies",                  # Cookies file
            "$EdgeDataPath\Downloads",                # Downloads file
            "$EdgeDataPath\Media History",            # Media history file
            "$EdgeDataPath\Visited Links",            # Visited links file
            "$EdgeDataPath\Top Sites",                # Top sites data
            "$EdgeDataPath\Network Action Predictor", # Network Action Predictor data
            "$EdgeDataPath\Preferences",              # Preferences (settings) file
            "$EdgeDataPath\Sessions",                 # Session data
            "$EdgeDataPath\QuotaManager",             # Quota Manager data
            "$EdgeDataPath\Service Worker"            # Service Worker data
        )

        # Loop through each item in the deletion list and remove it if it exists
        foreach ($item in $itemsToDelete) {
            if (Test-Path $item) {  # Check if the item exists
                # Delete the item recursively, forcefully, and silently (ignore errors if item cannot be deleted)
                Remove-Item $item -Recurse -Force -ErrorAction SilentlyContinue
                Write-Output "Deleted: $item"  # Output each deleted item
            }
        }

        Write-Output "Microsoft Edge browser history and related data cleaned."  # Notify that Edge data cleanup is complete
    } else {
        Write-Warning "Edge data folder not found. Skipping Edge cleanup."  # Warning message if the Edge data folder is not found
    }

    # Clear Media Foundation data (related to Windows Media Player)
    Write-Output "Clearing Media Foundation data..."
    # Delete all files in the Media Player folder related to Windows Media Player caching or session data
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Media Player\*.*" -Recurse -Force -ErrorAction SilentlyContinue
}

# Function to clear Internet Explorer browsing and session data
function Clear-InternetExplorerData {
    Write-Output "`n--- Internet Explorer Data Cleanup ---"  # Output to indicate IE data cleanup is starting

    # Define the flags for different types of data to clear: Temp Files, Cookies, History, Form Data, Passwords, Downloads
    # The values are the sum of individual flags representing each data type.
    $flags = 1 + 2 + 8 + 16 + 32 + 16384  # Sum of the flags to clear all selected data (Temp Files, Cookies, History, etc.)

    # Execute the ClearMyTracksByProcess function from InetCpl.cpl (Internet Options) to clear specified data types
    # This cmdlet clears Internet Explorer browsing data by passing the necessary flag values.
    RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess $flags

    # Disable "Preserve Favorites website data" by modifying registry settings
    # This registry modification ensures that the browsing history is cleared every time Internet Explorer is closed.
    $regPath = "HKCU:\Software\Microsoft\Internet Explorer\Privacy"  # Path to Internet Explorer's Privacy settings in the registry
    # Ensure the registry path exists (create it if it doesn't)
    New-Item -Path $regPath -Force | Out-Null
    # Set the registry key to automatically clear browsing history upon exit
    Set-ItemProperty -Path $regPath -Name "ClearBrowsingHistoryOnExit" -Value 1

    Write-Output "Internet Explorer history, cookies, and saved data cleaned."  # Notify that IE cleanup is complete
}

# Run the Edge and Internet Explorer data cleanup functions
Clear-EdgeData  # Call the function to clean Edge data
Clear-InternetExplorerData  # Call the function to clean Internet Explorer data

# Display a final message box informing the user that the cleanup was successful
# The message box will show that both Edge and Internet Explorer browsing data were cleaned.
[System.Windows.Forms.MessageBox]::Show(
    "Microsoft Edge and Internet Explorer browsing data were successfully cleaned.",  # Message to display
    "Cleanup Complete",  # Title of the message box
    [System.Windows.Forms.MessageBoxButtons]::OK,  # Button options (OK button)
    [System.Windows.Forms.MessageBoxIcon]::Information  # Icon type (information icon)
)

# Exit the script after completion
exit  # Terminate the script after successful cleanup
