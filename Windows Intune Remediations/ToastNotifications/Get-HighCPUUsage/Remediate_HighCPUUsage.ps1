<#
.SYNOPSIS
    Displays a toast notification for high CPU usage.

.DESCRIPTION
    This script checks if the CPU usage is high and displays a toast notification if necessary.
    It alerts the user that the CPU usage is high and advises closing unnecessary applications to improve performance.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for monitoring performance and sending alerts to the user.
    Additional Information:
        - This script generates a toast notification with specific performance information when CPU usage exceeds a predefined threshold.
#>

# Check the CPU usage
$cpuUsage = Get-WmiObject -Class Win32_Processor | Select-Object -ExpandProperty LoadPercentage

# If CPU usage is greater than 80%, send a toast notification
if ($cpuUsage -gt 80) {
    # Define the toast notification content
    $Group = "Performance Alerts"
    $Title = "High CPU Usage"
    $Message = "Your CPU usage has been consistently high. Consider closing some applications to improve performance."

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
}
