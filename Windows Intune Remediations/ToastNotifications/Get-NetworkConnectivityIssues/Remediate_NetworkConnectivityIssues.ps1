<#
.SYNOPSIS
This script creates a toast notification to alert the user about network connectivity issues.

.DESCRIPTION
This script defines a toast notification with a specific title and message related to network connectivity issues. It creates the notification using the `Windows.UI.Notifications.ToastNotificationManager` and shows it to the user to notify them about the network issues.

.AUTHOR
Name        : Allester Padovani
Title       : Senior IT Specialist
Script Ver. : 1.0
Date        : 2025-07-17

.NOTES
File Name      : NetworkConnectivityAlert.ps1
Version        : 1.0
Date Created   : 2025-07-19
Last Modified  : 2025-07-19
Change Log     : Initial version of the script to alert users about network connectivity issues.
#>

# Define the toast notification content
$Group = "Network Alerts"
$Title = "Network Connectivity Issues"
$Message = "Your system is experiencing network connectivity issues. Please check your network connection."

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
