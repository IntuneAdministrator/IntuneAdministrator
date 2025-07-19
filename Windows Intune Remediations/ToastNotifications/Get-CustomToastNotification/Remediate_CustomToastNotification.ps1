<#
.SYNOPSIS
    Displays a custom toast notification with a title and message.

.DESCRIPTION
    This script generates a toast notification using the Windows.UI.Notifications API. 
    The notification includes a custom title, message, and a group for categorizing the notification.

    The notification will pop up on the user's screen, providing an alert with the given title and message.

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
        - This script is customizable for different scenarios (error messages, alerts, etc.).
#>

# Define the toast notification content
# Group defines the notification grouping (eg. category). This allows for multiple use cases, which all align within the same group.
# Title defines the heading of the Toast Notification.
# Message defines the contents of the Toast Notification 

$Group = "This is a Notification!"
$Title = "This is the Title!"
$Message = "This is the Message!"

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
