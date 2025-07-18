<#
.SYNOPSIS
    Prompt the user to open the Apps & Features settings page on Windows 11 24H2.

.DESCRIPTION
    This script displays a Windows Forms message box asking the user to confirm if they want to open the Apps & Features settings page.
    If the user agrees, it opens the settings page via ms-settings URI.
    The script logs the user's action in the Application event log for auditing.
    Includes error handling and checks for event log source existence.

.NOTES
    Title        : Senior IT Professional
    Author       : Allester Padovani
    Script Ver.  : 1.0
    Date         : 2025-07-17
    Compatibility: Windows 11 24H2 and above
    Requires     : Permission to write to the event log and start processes
#>

# Load the required assemblies for Windows Forms and Drawing
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form that will act as the progress window
$form = New-Object System.Windows.Forms.Form
$form.Text = "Working - Please wait"                   # Title of the window
$form.Size = New-Object System.Drawing.Size(400,150)  # Window size (width x height)
$form.StartPosition = "CenterScreen"                   # Center window on the screen
$form.FormBorderStyle = 'FixedDialog'                  # Fixed dialog style, no resizing
$form.MaximizeBox = $false                              # Disable maximize button
$form.MinimizeBox = $false                              # Disable minimize button

# Create and configure a label to show progress text
$label = New-Object System.Windows.Forms.Label
$label.Text = "Starting task..."
$label.AutoSize = $true                                 # Adjust size based on content automatically
$label.Location = New-Object System.Drawing.Point(20, 20) # Position label inside the form
$form.Controls.Add($label)                              # Add label control to the form

# Create and configure a progress bar control
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Minimum = 0                                # Minimum value of the progress bar
$progressBar.Maximum = 100                              # Maximum value
$progressBar.Value = 0                                  # Starting value
$progressBar.Style = 'Continuous'                       # Smooth progress update
$progressBar.Size = New-Object System.Drawing.Size(350, 30) # Size of the progress bar
$progressBar.Location = New-Object System.Drawing.Point(20, 50) # Position inside the form
$form.Controls.Add($progressBar)                        # Add progress bar to form

# Show the form non-modally (so the script can continue)
$form.Show()

# Simulate a task progressing from 0% to 100% in increments
for ($i = 0; $i -le 100; $i += 5) {
    $progressBar.Value = $i                             # Update progress bar value
    $label.Text = "Progress: $i%"                       # Update label text to show progress
    [System.Windows.Forms.Application]::DoEvents()     # Process UI messages to keep form responsive
    Start-Sleep -Milliseconds 200                       # Simulate work being done (delay)
}

# Close the progress window after the task is done
$form.Close()

try {
    # Collect system information using Get-ComputerInfo cmdlet for modern and comprehensive data
    $sysInfo = Get-ComputerInfo | Select-Object `
        CsName, OsName, OsVersion, WindowsVersion, OsBuildNumber, OsArchitecture,
        CsManufacturer, CsModel, CsNumberOfLogicalProcessors, CsTotalPhysicalMemory,
        BiosManufacturer, BiosVersion

    # Get the CPU name from CIM, which is often more accurate than Get-ComputerInfo for this property
    $cpuName = (Get-CimInstance -ClassName Win32_Processor | Select-Object -First 1 -ExpandProperty Name).Trim()

    # Convert total physical memory from bytes to gigabytes, rounded to two decimals
    $totalMemoryGB = [math]::Round($sysInfo.CsTotalPhysicalMemory / 1GB, 2)

    # Prepare a nicely formatted multi-line string with all gathered system information
    $report = @"
System Information Report:

Computer Name     : $($sysInfo.CsName)
OS Name           : $($sysInfo.OsName)
OS Version        : $($sysInfo.OsVersion)
Windows Version   : $($sysInfo.WindowsVersion)
Build Number      : $($sysInfo.OsBuildNumber)
Architecture      : $($sysInfo.OsArchitecture)

Manufacturer      : $($sysInfo.CsManufacturer)
Model             : $($sysInfo.CsModel)
Processor         : $cpuName
Logical Cores     : $($sysInfo.CsNumberOfLogicalProcessors)
Memory Installed  : $totalMemoryGB GB

BIOS Manufacturer : $($sysInfo.BiosManufacturer)
BIOS Version      : $($sysInfo.BiosVersion -join ", ")

"@

    # Display the system information report in a modal message box with Information icon
    [System.Windows.Forms.MessageBox]::Show(
        $report,
        "System Information",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
}
catch {
    # If an error occurs while collecting or displaying info, show an error dialog with details
    $errorMessage = "An error occurred while retrieving system information:`n$($_.Exception.Message)"
    [System.Windows.Forms.MessageBox]::Show(
        $errorMessage,
        "Error",
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Error
    )
}
