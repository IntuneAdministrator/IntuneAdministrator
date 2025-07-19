<#
.SYNOPSIS
    Sends a toast notification for printer issues.

.DESCRIPTION
    This script creates and sends a toast notification on the system to alert the user about printer issues.
    It displays a custom message with a title indicating the printer problems. The notification is created using
    Windows 10/11's built-in notification system.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 10 and Windows 11 systems.
    Usage        : Local execution on systems with PowerShell 5.0 or higher.
#>

# Define the toast notification content
$Group = "Printer Alerts"
$Title = "Printer Issues Detected"
$Message = "There are issues with your printer. Please check the printer status and resolve any errors."

# Check if the required assembly is available
try {
    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
} catch {
    Write-Error "Required Windows.UI.Notifications assembly is not available on this system."
    exit 1
}

# Create the toast notification
$template = [Windows.UI.Notifications.ToastTemplateType]::ToastText02
$toastXml = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent($template)
$toastTextElements = $toastXml.GetElementsByTagName("text")
$toastTextElements.Item(0).AppendChild($toastXml.CreateTextNode($Title)) | Out-Null
$toastTextElements.Item(1).AppendChild($toastXml.CreateTextNode($Message)) | Out-Null
$toast = [Windows.UI.Notifications.ToastNotification]::new($toastXml)
$notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($Group)

# Show the toast notification
$notifier.Show($toast)
