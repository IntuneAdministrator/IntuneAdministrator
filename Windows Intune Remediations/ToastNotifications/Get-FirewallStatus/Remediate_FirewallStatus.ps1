<#
.SYNOPSIS
    Displays a toast notification for a disabled firewall.

.DESCRIPTION
    This script triggers a toast notification when the firewall is disabled, alerting the user to enable it for protection.
    The notification contains a message informing the user about the disabled firewall.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11 with Windows Firewall
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script uses Windows toast notifications to alert the user of the disabled firewall status.
#>

# Define the toast notification content
$Group = "Security Alerts"
$Title = "Firewall Disabled"
$Message = "Your firewall is currently disabled. Please enable it to protect your system from threats."

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
