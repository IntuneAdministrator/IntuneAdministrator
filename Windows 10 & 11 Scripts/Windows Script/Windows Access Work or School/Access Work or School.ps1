<#
.SYNOPSIS
    Access Work or School & Azure AD Join Utilities Dashboard for Windows 11 24H2.

.DESCRIPTION
    Provides a WPF GUI with buttons to:
    - Check Azure AD / Workplace Join status and show detailed info
    - Open 'Access Work or School' settings page
    - Open 'Accounts' settings page
    - Open 'Workplace Join' related logs (Event Viewer or CMD)
    Each button logs its action to the Application event log.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-15
    Version     : 1.0

.NOTES
    Requires PowerShell 5.1+, Windows 11 24H2 or later.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Log-Action {
    param ([string]$message, [string]$source = "PowerShell - Work/School Dashboard")

    $logName = "Application"
    if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
        try { New-EventLog -LogName $logName -Source $source } catch {}
    }

    Write-EventLog -LogName $logName -Source $source -EntryType Information -EventId 1000 -Message $message
}

function Show-WorkSchoolStatus {
    try {
        $dsregStatus = dsregcmd /status 2>&1

        $aadJoined = $dsregStatus | Select-String -Pattern "^AzureAdJoined\s*:\s*" | ForEach-Object { ($_ -split ":")[1].Trim() }
        $workplaceJoined = $dsregStatus | Select-String -Pattern "^WorkplaceJoined\s*:\s*" | ForEach-Object { ($_ -split ":")[1].Trim() }

        $messageLines = @(
            "Azure AD Joined     : $aadJoined"
            "Workplace Joined    : $workplaceJoined"
        )

        if ($aadJoined -eq "YES" -or $workplaceJoined -eq "YES") {
            $messageLines += "`n✅ A work or school account is connected."
            $icon = [System.Windows.Forms.MessageBoxIcon]::Information
            $buttons = [System.Windows.Forms.MessageBoxButtons]::OK

            [System.Windows.Forms.MessageBox]::Show(
                ($messageLines -join "`n"),
                "Work/School Account Status",
                $buttons,
                $icon
            )
        }
        else {
            $messageLines += "`nNo work or school account is connected."
            $messageLines += "You can open the 'Access Work or School' settings page to connect."

            [System.Windows.Forms.MessageBox]::Show(
                ($messageLines -join "`n"),
                "Work/School Account Status",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Warning
            )
        }
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show(
            "An error occurred while checking account status:`n$_",
            "Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
    }
}

# Create WPF Window
$window = New-Object System.Windows.Window
$window.Title = "Access Work or School Dashboard"
$window.ResizeMode = [System.Windows.ResizeMode]::NoResize
$window.WindowStartupLocation = [System.Windows.WindowStartupLocation]::CenterScreen
$window.SizeToContent = 'WidthAndHeight'  # Let window auto-size to fit all content

# Main stack panel
$stackPanel = New-Object System.Windows.Controls.StackPanel
$stackPanel.Orientation = [System.Windows.Controls.Orientation]::Vertical
$stackPanel.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$stackPanel.VerticalAlignment = [System.Windows.VerticalAlignment]::Center
$window.Content = $stackPanel

# Header
$textBlockHeader = New-Object System.Windows.Controls.TextBlock
$textBlockHeader.Text = "Access Work or School Utilities"
$textBlockHeader.FontSize = 16
$textBlockHeader.FontWeight = [System.Windows.FontWeights]::Bold
$textBlockHeader.TextAlignment = [System.Windows.TextAlignment]::Center
$textBlockHeader.Margin = [System.Windows.Thickness]::new(0, 0, 0, 20)
$stackPanel.Children.Add($textBlockHeader)

# Button: Check Work/School Account Status
$buttonCheckStatus = New-Object System.Windows.Controls.Button
$buttonCheckStatus.Content = "Check Work/School Account Status"
$buttonCheckStatus.Width = 320
$buttonCheckStatus.Margin = [System.Windows.Thickness]::new(10)
$buttonCheckStatus.Add_Click({
    Show-WorkSchoolStatus
    Log-Action "Checked Work/School account status." "Work/School Dashboard"
})
$stackPanel.Children.Add($buttonCheckStatus)

# Button: Open Access Work or School Settings
$buttonAccessWorkSchool = New-Object System.Windows.Controls.Button
$buttonAccessWorkSchool.Content = "Open Access Work or School Settings"
$buttonAccessWorkSchool.Width = 320
$buttonAccessWorkSchool.Margin = [System.Windows.Thickness]::new(10)
$buttonAccessWorkSchool.Add_Click({
    Start-Process "ms-settings:workplace"
    Log-Action "Opened Access Work or School settings." "Work/School Dashboard"
})
$stackPanel.Children.Add($buttonAccessWorkSchool)

# Button: Open Accounts Settings
$buttonAccountsSettings = New-Object System.Windows.Controls.Button
$buttonAccountsSettings.Content = "Open Accounts Settings"
$buttonAccountsSettings.Width = 320
$buttonAccountsSettings.Margin = [System.Windows.Thickness]::new(10)
$buttonAccountsSettings.Add_Click({
    Start-Process "ms-settings:accounts"
    Log-Action "Opened Accounts settings." "Work/School Dashboard"
})
$stackPanel.Children.Add($buttonAccountsSettings)

# Button: Open Workplace Join Logs (Event Viewer)
$buttonOpenWorkplaceLogs = New-Object System.Windows.Controls.Button
$buttonOpenWorkplaceLogs.Content = "Open Workplace Join Logs (Event Viewer)"
$buttonOpenWorkplaceLogs.Width = 320
$buttonOpenWorkplaceLogs.Margin = [System.Windows.Thickness]::new(10)
$buttonOpenWorkplaceLogs.Add_Click({
    Start-Process "eventvwr.msc"
    Log-Action "Opened Event Viewer for Workplace Join logs." "Work/School Dashboard"
})
$stackPanel.Children.Add($buttonOpenWorkplaceLogs)

# Button: Open Command Prompt
$buttonCmd = New-Object System.Windows.Controls.Button
$buttonCmd.Content = "Open Command Prompt"
$buttonCmd.Width = 320
$buttonCmd.Margin = [System.Windows.Thickness]::new(10)
$buttonCmd.Add_Click({
    Start-Process "cmd.exe"
    Log-Action "Opened Command Prompt." "Work/School Dashboard"
})
$stackPanel.Children.Add($buttonCmd)

# Footer
$textBlockFooter = New-Object System.Windows.Controls.TextBlock
$textBlockFooter.Text = "Allester Padovani, Senior IT Specialist"
$textBlockFooter.FontSize = 12
$textBlockFooter.FontStyle = [System.Windows.FontStyles]::Italic
$textBlockFooter.Foreground = [System.Windows.Media.Brushes]::Black
$textBlockFooter.HorizontalAlignment = [System.Windows.HorizontalAlignment]::Center
$textBlockFooter.Margin = [System.Windows.Thickness]::new(0, 20, 0, 5)
$stackPanel.Children.Add($textBlockFooter)

# Show the WPF window
$window.ShowDialog()
