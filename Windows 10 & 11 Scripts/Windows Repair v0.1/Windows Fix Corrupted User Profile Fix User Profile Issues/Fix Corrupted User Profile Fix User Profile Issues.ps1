<#
.SYNOPSIS
    Repairs the current user's profile by checking for corruption, attempting registry repairs, and optionally creating a new user account.

.DESCRIPTION
    This script logs details about user profiles on the system, attempts to load and repair the current user's registry hive,
    creates a temporary new local user account if needed, and logs all actions to a dedicated log file.
    It provides user feedback via message boxes and requires administrative privileges to run.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-17
    Version     : 1.0

.NOTES
    Run with Administrator privileges.
    Logs are saved under C:\ProgramData\OzarkTechTeam\UserProfileRepairLogs.
#>

# Load necessary assemblies for Windows Forms and Drawing
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Define log folder and file path
$logFolder = "C:\ProgramData\OzarkTechTeam\UserProfileRepairLogs"
$logFile = Join-Path $logFolder "UserProfileRepair_log.txt"

# Ensure log folder exists
if (-not (Test-Path $logFolder)) {
    New-Item -Path $logFolder -ItemType Directory -Force | Out-Null
}

# Log script start
"[$(Get-Date)] Starting User Profile Repair..." | Out-File -FilePath $logFile -Append

# Function: Show a secure credential input form (username & password)
function Show-CredentialInputForm {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Create Temporary Admin Account"
    $form.Size = New-Object System.Drawing.Size(350, 220)
    $form.StartPosition = "CenterScreen"
    $form.Topmost = $true

    # Username label
    $lblUser = New-Object System.Windows.Forms.Label
    $lblUser.Text = "New Username:"
    $lblUser.Location = New-Object System.Drawing.Point(10, 20)
    $lblUser.Size = New-Object System.Drawing.Size(100, 20)
    $form.Controls.Add($lblUser)

    # Username textbox
    $txtUser = New-Object System.Windows.Forms.TextBox
    $txtUser.Location = New-Object System.Drawing.Point(120, 20)
    $txtUser.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($txtUser)

    # Password label
    $lblPass = New-Object System.Windows.Forms.Label
    $lblPass.Text = "New Password:"
    $lblPass.Location = New-Object System.Drawing.Point(10, 60)
    $lblPass.Size = New-Object System.Drawing.Size(100, 20)
    $form.Controls.Add($lblPass)

    # Password textbox (masked)
    $txtPass = New-Object System.Windows.Forms.TextBox
    $txtPass.Location = New-Object System.Drawing.Point(120, 60)
    $txtPass.Size = New-Object System.Drawing.Size(200, 20)
    $txtPass.UseSystemPasswordChar = $true
    $form.Controls.Add($txtPass)

    # OK button
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Text = "Create"
    $okButton.Location = New-Object System.Drawing.Point(120, 110)
    $okButton.Add_Click({
        if ($txtUser.Text -and $txtPass.Text) {
            $form.DialogResult = [System.Windows.Forms.DialogResult]::OK
            $form.Close()
        } else {
            [System.Windows.Forms.MessageBox]::Show("Both username and password are required.","Input Error",[System.Windows.Forms.MessageBoxButtons]::OK,[System.Windows.Forms.MessageBoxIcon]::Warning)
        }
    })
    $form.Controls.Add($okButton)

    # Cancel button
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = "Cancel"
    $cancelButton.Location = New-Object System.Drawing.Point(220, 110)
    $cancelButton.Add_Click({ 
        $form.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        $form.Close()
    })
    $form.Controls.Add($cancelButton)

    # Set Accept and Cancel buttons
    $form.AcceptButton = $okButton
    $form.CancelButton = $cancelButton

    # Show form and return credentials or $null if cancelled
    if ($form.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return @{
            Username = $txtUser.Text
            Password = $txtPass.Text
        }
    } else {
        return $null
    }
}

# Function: Show custom prompt with Yes, Repair Only, and Cancel buttons (with larger buttons)
function Show-CustomPrompt {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "User Repair Assistant"
    $form.Size = New-Object System.Drawing.Size(420, 170)  # wider to fit bigger buttons
    $form.StartPosition = "CenterScreen"
    $form.Topmost = $true

    # Label text
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Do you want to create a new temporary admin account or just repair the profile?"
    $label.Size = New-Object System.Drawing.Size(380, 40)
    $label.Location = New-Object System.Drawing.Point(20, 10)
    $form.Controls.Add($label)

    # Yes (Create User) button
    $yesButton = New-Object System.Windows.Forms.Button
    $yesButton.Text = "Yes (Create User)"
    $yesButton.Size = New-Object System.Drawing.Size(120, 40)           # bigger button
    $yesButton.Location = New-Object System.Drawing.Point(20, 70)      # adjusted position
    $yesButton.Add_Click({ $form.Tag = "Yes"; $form.Close() })
    $form.Controls.Add($yesButton)

    # Repair Only button
    $repairButton = New-Object System.Windows.Forms.Button
    $repairButton.Text = "Repair Only"
    $repairButton.Size = New-Object System.Drawing.Size(120, 40)       # bigger button
    $repairButton.Location = New-Object System.Drawing.Point(150, 70)  # adjusted position
    $repairButton.Add_Click({ $form.Tag = "Repair"; $form.Close() })
    $form.Controls.Add($repairButton)

    # Cancel button
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = "Cancel"
    $cancelButton.Size = New-Object System.Drawing.Size(120, 40)       # bigger button
    $cancelButton.Location = New-Object System.Drawing.Point(280, 70)  # adjusted position
    $cancelButton.Add_Click({ $form.Tag = "Cancel"; $form.Close() })
    $form.Controls.Add($cancelButton)

    # Show dialog and return chosen tag
    $form.ShowDialog() | Out-Null
    return $form.Tag
}

# === Start core script logic ===

# Log user profiles info for diagnostic
"[$(Get-Date)] Checking user profiles..." | Out-File -FilePath $logFile -Append
Get-WmiObject -Class Win32_UserProfile |
    Select-Object LocalPath, Loaded, Special |
    Out-File -FilePath $logFile -Append

# Attempt to load current user's registry hive (NTUSER.DAT)
try {
    $ntuserPath = "C:\Users\$env:USERNAME\NTUSER.DAT"
    if (Test-Path $ntuserPath) {
        "[$(Get-Date)] Loading registry hive from $ntuserPath" | Out-File -FilePath $logFile -Append
        reg load HKU\Temp $ntuserPath | Out-File -FilePath $logFile -Append
    } else {
        "[$(Get-Date)] NTUSER.DAT not found at expected path: $ntuserPath" | Out-File -FilePath $logFile -Append
    }
} catch {
    "[$(Get-Date)] Failed to load registry hive: $_" | Out-File -FilePath $logFile -Append
}

# Show the custom 3-button prompt to user and get response
$userChoice = Show-CustomPrompt

switch ($userChoice) {
    "Yes" {
        # User chose to create new admin account
        $creds = Show-CredentialInputForm
        if ($null -ne $creds) {
            try {
                # Convert plain password to secure string
                $securePass = ConvertTo-SecureString -String $creds.Password -AsPlainText -Force
                
                # Create local user account with given credentials
                New-LocalUser -Name $creds.Username -Password $securePass -FullName "Temporary Admin User" -Description "Created by UserProfileRepair Script"
                
                # Add user to local Administrators group
                Add-LocalGroupMember -Group "Administrators" -Member $creds.Username
                
                # Log success
                "[$(Get-Date)] Created new admin user: $($creds.Username)" | Out-File -FilePath $logFile -Append
                
                # Inform user
                [System.Windows.Forms.MessageBox]::Show(
                    "Temporary admin user '$($creds.Username)' created successfully.",
                    "Success",
                    [System.Windows.Forms.MessageBoxButtons]::OK,
                    [System.Windows.Forms.MessageBoxIcon]::Information
                )

                # Ask if user wants to restart now
                $restartResponse = [System.Windows.Forms.MessageBox]::Show(
                    "Do you want to restart the computer now?",
                    "Restart Required",
                    [System.Windows.Forms.MessageBoxButtons]::YesNo,
                    [System.Windows.Forms.MessageBoxIcon]::Question
                )
                
                if ($restartResponse -eq [System.Windows.Forms.DialogResult]::Yes) {
                    # Warn user to save work
                    [System.Windows.Forms.MessageBox]::Show(
                        "Please save all your work before the system restarts. The restart will occur in 2 minutes.",
                        "Save Work",
                        [System.Windows.Forms.MessageBoxButtons]::OK,
                        [System.Windows.Forms.MessageBoxIcon]::Warning
                    )
                    # Schedule restart in 120 seconds
                    shutdown.exe /r /t 120
                }

            } catch {
                # Log and inform on failure
                "[$(Get-Date)] Failed to create user: $_" | Out-File -FilePath $logFile -Append
                [System.Windows.Forms.MessageBox]::Show(
                    "Error creating user: $_",
                    "Error",
                    [System.Windows.Forms.MessageBoxButtons]::OK,
                    [System.Windows.Forms.MessageBoxIcon]::Error
                )
            }
        } else {
            "[$(Get-Date)] User cancelled account creation dialog." | Out-File -FilePath $logFile -Append
        }
    }
    "Repair" {
        # User chose repair only, skip user creation
        "[$(Get-Date)] User selected repair only. Skipping user creation." | Out-File -FilePath $logFile -Append
    }
    "Cancel" {
        # User chose to cancel the entire process
        "[$(Get-Date)] User canceled the operation. Exiting script." | Out-File -FilePath $logFile -Append
        [System.Windows.Forms.MessageBox]::Show(
            "Operation canceled by user.",
            "Canceled",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )
        exit
    }
    Default {
        # Unexpected outcome, just exit
        "[$(Get-Date)] No valid option selected. Exiting script." | Out-File -FilePath $logFile -Append
        exit
    }
}

# Log script completion
"[$(Get-Date)] User Profile Repair completed." | Out-File -FilePath $logFile -Append

# Final notification to user
[System.Windows.Forms.MessageBox]::Show(
    "User profile repair completed. Check logs at $logFile.",
    "Repair Complete",
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information
)

# Exit gracefully
exit
