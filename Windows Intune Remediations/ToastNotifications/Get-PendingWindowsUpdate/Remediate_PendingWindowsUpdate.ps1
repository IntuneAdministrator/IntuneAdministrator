<#
.SYNOPSIS
This script triggers a toast notification to alert the user about pending Windows updates.

.DESCRIPTION
This script checks for pending Windows updates and displays a toast notification to the user with a warning message if updates are pending. The notification informs the user to install updates in order to keep the system secure and up-to-date.

.AUTHOR
Name        : Allester Padovani
Title       : Senior IT Specialist
Script Ver. : 1.0
Date        : 2025-07-17

.NOTES
File Name      : PendingWindowsUpdatesAlert.ps1
Version        : 1.0
Date Created   : 2025-07-19
Last Modified  : 2025-07-19
Change Log     : Initial version of the script to notify users about pending updates.
#>

# Define the toast notification content
$Group = "Update Alerts"
$Title = "Pending Windows Updates"
$Message = "There are pending Windows updates. Please install them to keep your system secure and up-to-date."

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
