<#
.SYNOPSIS
    Displays a toast notification when a system reboot is required.

.DESCRIPTION
    This script generates a toast notification with the title "Reboot Required" and a message indicating that the system has been running for over 7 days. 
    It uses the Windows.UI.Notifications API to display the notification to the user.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses the `Windows.UI.Notifications` namespace to show a toast notification.
        - Toast notifications are commonly used to alert users of important system events.
        - The script is intended to prompt users to reboot their systems if the system has been running for more than 7 days.
#>

# Define the toast notification content
$Group = "System Alerts"
$Title = "Reboot Required"
$Message = "Your system has been running for over 7 days. Please reboot to ensure optimal performance."

# Create the toast notification
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
$template = [Windows.UI.Notifications.ToastTemplateType]::ToastText02
$toastXml = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent($template)
$toastTextElements = $toastXml.GetElementsByTagName("text")
$toastTextElements.Item(0).AppendChild($toastXml.CreateTextNode($Title)) | Out-Null
$toastTextElements.Item(1).AppendChild($toastXml.CreateTextNode($Message)) | Out-Null
$toast = [Windows.UI.Notifications.ToastNotification]::new($toastXml)
$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($Group)
$notifier.Show($toast)
