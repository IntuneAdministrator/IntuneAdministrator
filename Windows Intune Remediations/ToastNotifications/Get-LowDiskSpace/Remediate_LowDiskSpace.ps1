<#
.SYNOPSIS
    Displays a toast notification warning about low disk space on the C: drive.

.DESCRIPTION
    This script generates a toast notification using the Windows.UI.Notifications API. 
    It alerts the user when the C: drive is running low on space, and it suggests freeing up space to avoid system issues.

    The notification includes a custom title, message, and a group for categorizing the notification.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The `Windows.UI.Notifications` namespace is used to create and show toast notifications.
        - The toast notification will notify users when the C: drive is running low on space.
#>

# Define the toast notification content
$Group = "System Alerts"
$Title = "Low Disk Space"
$Message = "Your C: drive is running low on space. Please free up some space to avoid system issues."

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
