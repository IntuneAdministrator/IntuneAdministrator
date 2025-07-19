<#
.SYNOPSIS
    Creates a toast notification when antivirus is disabled.

.DESCRIPTION
    This script checks if antivirus is disabled on the system, and if so, generates a toast notification
    to alert the user about the issue, urging them to enable the antivirus for protection.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The notification group is labeled "Security Alerts."
        - The message notifies the user that the antivirus is disabled and urges them to enable it.
        - The toast notification uses Windows native API for display.
#>

# Define the toast notification content
$Group = "Security Alerts"
$Title = "Antivirus Disabled"
$Message = "Your antivirus is currently disabled. Please enable it to protect your system from threats."

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
