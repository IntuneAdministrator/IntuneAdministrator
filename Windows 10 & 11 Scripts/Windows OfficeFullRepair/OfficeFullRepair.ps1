<#
.SYNOPSIS
    Runs a silent full repair of Microsoft Office using OfficeClickToRun.exe, ensuring the script runs with administrator privileges.

.DESCRIPTION
    This script checks if it is running with elevated Administrator rights and, if not, restarts itself with elevated privileges.
    It then silently launches the Microsoft Office full repair process with appropriate command-line arguments.
    After starting the repair process, it waits briefly to ensure the process is initiated and informs the user via a Windows Forms message box.

.NOTES
    - Requires Administrator privileges to launch Office repair.
    - Compatible with Windows 11 24H2 and later.
    - Uses Start-Process with silent parameters.
    - Provides user feedback via GUI message box.
    - Adjust the OfficeClickToRun.exe path and arguments if needed for other versions or languages.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-18
#>

# Check for Administrator rights
# This check ensures that the script is running with administrative privileges.
# If not, it will relaunch itself with elevated permissions.

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    
    # Relaunch the script with Administrator privileges
    # If the script is not running as an Administrator, we use the ProcessStartInfo class to restart the script with elevated privileges.
    # The new instance will run with hidden windows to avoid disturbing the user.
    
    $psi = New-Object System.Diagnostics.ProcessStartInfo  # Create a new ProcessStartInfo object to configure the new process
    $psi.FileName = "powershell.exe"  # Specify that we want to launch PowerShell
    $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$PSCommandPath`""  # Set arguments to run the current script with bypassed execution policy and hidden window
    $psi.Verb = "runas"  # Set the verb to 'runas', which requests elevated (Administrator) privileges
    $psi.WindowStyle = "Hidden"  # Set the new process window style to 'Hidden' to run silently without any GUI
    [System.Diagnostics.Process]::Start($psi) | Out-Null  # Start the new elevated process, suppress any output or error messages
    exit  # Exit the current non-elevated instance of the script to allow the elevated process to continue
}

# Run the Office FullRepair process silently
# Start-Process is used to launch the Office repair tool silently without user intervention.

Start-Process -FilePath "C:\Program Files\Common Files\Microsoft Shared\ClickToRun\OfficeClickToRun.exe" `
    -ArgumentList "scenario=Repair platform=x64 culture=en-us forceappshutdown=True RepairType=FullRepair DisplayLevel=True" `
    -WindowStyle Hidden  # This starts the Office repair process with the necessary arguments. 'Hidden' ensures no window appears to the user.

# Optional wait for user experience (adjust the duration or remove if unnecessary)
# The sleep command here gives the repair tool a few seconds to begin, which can be helpful in ensuring the repair process is properly initiated before notifying the user.
# It is not strictly required and can be omitted or modified based on the environment and system responsiveness.

Start-Sleep -Seconds 5  # Allow time for the Office repair process to start. 5 seconds is typically enough, but this can be adjusted if necessary.

# Show a message box to inform the user that the repair process has been initiated
# The message box is shown to provide feedback to the user, letting them know the repair process has started and that they can continue using the computer.

Add-Type -AssemblyName "System.Windows.Forms"  # Load the Windows Forms assembly to allow displaying message boxes

[System.Windows.Forms.MessageBox]::Show(
    'Microsoft Office Full Repair has been initiated. You may continue using your computer.',  # Text to display in the message box
    'Repair Started',  # Title of the message box
    [System.Windows.Forms.MessageBoxButtons]::OK,  # Display an OK button in the message box
    [System.Windows.Forms.MessageBoxIcon]::Information  # Use an Information icon in the message box to indicate success
)

# End of the script
