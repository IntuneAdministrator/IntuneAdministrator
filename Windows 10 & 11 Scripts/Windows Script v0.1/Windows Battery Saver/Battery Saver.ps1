<#
.SYNOPSIS
    Prompts the user to open the Battery Saver settings page if a battery is detected.

.DESCRIPTION
    Uses CIM to check for the presence of a battery on the device. If a battery exists, prompts the user with a confirmation dialog.
    Upon user approval, opens the Battery Saver settings page and logs the action to the Application event log.
    If no battery is found, informs the user. Handles errors gracefully and logs them when possible.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-15
    Version     : 1.0

.NOTES
    Compatibility: Windows 11 24H2 and above  
    Requires     : Permissions to write to the event log and start processes
#>

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

# Create a simple WPF window with SizeToContent for layout control
$window = New-Object System.Windows.Window
$window.Title = "Battery Saver Check"
$window.SizeToContent = "WidthAndHeight"
$window.ResizeMode = 'NoResize'
$window.WindowStartupLocation = 'CenterScreen'

$panel = New-Object System.Windows.Controls.StackPanel
$panel.Margin = [System.Windows.Thickness]::new(20)
$panel.HorizontalAlignment = "Center"
$panel.VerticalAlignment = "Center"

# Add a title
$title = New-Object System.Windows.Controls.TextBlock
$title.Text = "Battery Saver Tool"
$title.FontSize = 16
$title.FontWeight = "Bold"
$title.TextAlignment = "Center"
$title.Margin = "0,0,0,20"
$title.HorizontalAlignment = "Center"
$panel.Children.Add($title)

# Add a fixed-width button to trigger the check
$buttonCheckBattery = New-Object System.Windows.Controls.Button
$buttonCheckBattery.Content = "Check Battery & Open Settings"
$buttonCheckBattery.Width = 320
$buttonCheckBattery.Margin = [System.Windows.Thickness]::new(10)
$buttonCheckBattery.HorizontalAlignment = "Center"

$buttonCheckBattery.Add_Click({
    # Define event log source name
    $eventSource = "Battery Saver Settings"

    try {
        # Query for battery presence using CIM
        $batteryStatus = Get-CimInstance -ClassName Win32_Battery

        if ($batteryStatus) {
            $response = [System.Windows.Forms.MessageBox]::Show(
                "A battery is detected on this device.`nDo you want to open the Battery Saver settings page?",
                "Open Battery Saver Settings",
                [System.Windows.Forms.MessageBoxButtons]::YesNo,
                [System.Windows.Forms.MessageBoxIcon]::Question
            )

            if ($response -eq [System.Windows.Forms.DialogResult]::Yes) {
                if (-not [System.Diagnostics.EventLog]::SourceExists($eventSource)) {
                    New-EventLog -LogName Application -Source $eventSource
                }

                Start-Process "ms-settings:batterysaver"

                Write-EventLog -LogName Application -Source $eventSource -EntryType Information -EventId 1000 -Message "User opened Battery Saver settings."
            } else {
                Write-Host "User canceled opening Battery Saver settings."
            }
        } else {
            [System.Windows.Forms.MessageBox]::Show(
                "This device does not have a battery. Battery Saver settings are unavailable.",
                "No Battery Detected",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Information
            )
        }
    }
    catch {
        $errorMsg = "An error occurred: $($_.Exception.Message)"
        Write-Error $errorMsg

        if ([System.Diagnostics.EventLog]::SourceExists($eventSource)) {
            Write-EventLog -LogName Application -Source $eventSource -EntryType Error -EventId 1001 -Message $errorMsg
        }
    }
})

$panel.Children.Add($buttonCheckBattery)

# Footer
$footer = New-Object System.Windows.Controls.TextBlock
$footer.Text = "Allester Padovani - Senior IT Specialist"
$footer.FontSize = 12
$footer.FontStyle = [System.Windows.FontStyles]::Italic
$footer.Margin = "0,20,0,10"
$footer.HorizontalAlignment = "Center"
$panel.Children.Add($footer)

# Set content and show window
$window.Content = $panel
$window.ShowDialog()
