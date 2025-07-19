<#
.SYNOPSIS
    Displays a toast notification for battery health warnings.

.DESCRIPTION
    This script checks the battery health and generates a toast notification to alert the user when the battery health falls below 50%. 
    It uses the `Windows.UI.Notifications` API to display the notification with a message prompting the user to replace their battery.

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
        - Toast notifications are commonly used to alert users of important system events, like battery health warnings.
        - The script displays a warning message when battery health is below 50%, prompting the user to take action.
#>

# Define the toast notification content
$Group = "Battery Alerts"
$Title = "Battery Health Warning"
$Message = "Your battery health is below 50%. Consider replacing it to avoid unexpected shutdowns."

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
