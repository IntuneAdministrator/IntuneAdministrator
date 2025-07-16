<#
.SYNOPSIS
    Checks if the device is Azure AD or Workplace joined, shows status, and optionally opens settings.

.DESCRIPTION
    Uses 'dsregcmd /status' to determine device join state. Displays results in a message box.
    If no work or school account is connected, prompts user to open the 'Access Work or School' settings page.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.1
    Date        : 2025-07-17

.NOTES
    Compatible with Windows 11 24H2 and above.
#>

# Load Windows Forms assembly for GUI MessageBox
Add-Type -AssemblyName System.Windows.Forms

try {
    # Run dsregcmd /status and capture output
    $dsregStatus = dsregcmd /status 2>&1

    # Parse Azure AD Join status
    $aadJoined = $dsregStatus |
        Select-String -Pattern "^AzureAdJoined\s*:\s*" |
        ForEach-Object { ($_ -split ":")[1].Trim() }

    # Parse Workplace Join status
    $workplaceJoined = $dsregStatus |
        Select-String -Pattern "^WorkplaceJoined\s*:\s*" |
        ForEach-Object { ($_ -split ":")[1].Trim() }

    # Compose status message
    $messageLines = @(
        "Azure AD Joined     : $aadJoined"
        "Workplace Joined    : $workplaceJoined"
    )

    if ($aadJoined -eq "YES" -or $workplaceJoined -eq "YES") {
        $messageLines += "`n✅ A work or school account is connected."
        $icon = [System.Windows.Forms.MessageBoxIcon]::Information
        $buttons = [System.Windows.Forms.MessageBoxButtons]::OK

        # Show info message
        [System.Windows.Forms.MessageBox]::Show(
            ($messageLines -join "`n"),
            "Work/School Account Status",
            $buttons,
            $icon
        )
    }
    else {
        $messageLines += "`n⚠️ No work or school account is connected."
        $messageLines += "Would you like to open the 'Access Work or School' settings page?"
        $icon = [System.Windows.Forms.MessageBoxIcon]::Question
        $buttons = [System.Windows.Forms.MessageBoxButtons]::YesNo

        # Ask user if they want to open the settings page
        $result = [System.Windows.Forms.MessageBox]::Show(
            ($messageLines -join "`n"),
            "Work/School Account Status",
            $buttons,
            $icon
        )

        if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
            # User agreed to open settings
            Start-Process "ms-settings:workplace"
        }
    }

}
catch {
    # Handle errors gracefully with a message box
    [System.Windows.Forms.MessageBox]::Show(
        "An error occurred while checking account status:`n$_",
        "Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
}
