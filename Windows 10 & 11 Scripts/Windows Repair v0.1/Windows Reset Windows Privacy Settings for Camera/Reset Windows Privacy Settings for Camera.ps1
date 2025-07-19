<#
.SYNOPSIS
    Resets camera privacy settings to allow app access on Windows 11 24H2.

.DESCRIPTION
    This script modifies the current user's registry settings to ensure that apps can access the webcam.
    It is designed for IT professionals maintaining Windows 11 24H2 systems, providing user feedback via MessageBox UI.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-18
    Version     : 1.0

.NOTES
    - Requires user context (HKCU) – not system-wide
    - Designed for Windows 11 version 24H2 and later
    - Does not override Group Policy or system-wide camera restrictions
#>

# Load Windows Forms assembly to access message box functionality
Add-Type -AssemblyName System.Windows.Forms

# Define the registry key containing camera privacy permissions for all apps
$privacyKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam"

try {
    # Check if the webcam privacy key exists in the registry
    if (-not (Test-Path $privacyKey)) {
        # If the key doesn't exist, inform the user and stop execution
        [System.Windows.Forms.MessageBox]::Show(
            "Camera privacy settings not found. This may indicate no camera has been used on this account.",
            "No Settings Found",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
        exit 0
    }

    # Retrieve all subkeys under the webcam registry key
    $subKeys = Get-ChildItem -Path $privacyKey

    # Loop through each subkey and update the 'Value' to 'Allow'
    foreach ($key in $subKeys) {
        Set-ItemProperty -Path $key.PSPath -Name "Value" -Value "Allow" -ErrorAction Stop
    }

    # Notify user of success
    [System.Windows.Forms.MessageBox]::Show(
        "Camera privacy settings have been successfully reset. App access is now allowed.",
        "Privacy Settings Updated",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
}
catch {
    # Capture and display any errors encountered during execution
    [System.Windows.Forms.MessageBox]::Show(
        "An error occurred while modifying privacy settings:`n$($_.Exception.Message)",
        "Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
    exit 1
}

# End the script gracefully
exit 0
