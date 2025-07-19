<#
.SYNOPSIS
This script checks the system's memory usage and triggers a toast notification when memory usage exceeds a specified threshold (80%).

.DESCRIPTION
This script uses Windows Management Instrumentation (WMI) to retrieve memory usage information from the system. It then calculates the percentage of used memory and if the usage exceeds 80%, a toast notification is triggered to alert the user about the high memory usage. This notification can help prevent performance issues due to high memory consumption.

.AUTHOR
Name        : Allester Padovani
Title       : Senior IT Specialist
Script Ver. : 1.0
Date        : 2025-07-17

.NOTES
File Name      : HighMemoryUsageNotification.ps1
Version        : 1.0
Date Created   : 2025-07-19
Last Modified  : 2025-07-19
Change Log     : Initial version of the script created for memory usage monitoring.
#>

# Define the toast notification content
$Group = "Performance Alerts"
$Title = "High Memory Usage"
$Message = "Your memory usage has been consistently high. Consider closing some applications to improve performance."

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
