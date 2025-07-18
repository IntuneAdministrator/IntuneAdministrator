<#
.SYNOPSIS
    Displays detailed BIOS information using a Windows Forms message box.

.DESCRIPTION
    Retrieves BIOS data using the Win32_BIOS CIM class and displays key properties
    such as serial number, manufacturer, version, and release date in a message box.
    Useful for diagnostics, inventory, or troubleshooting scripts.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-18

.NOTES
    Compatible with Windows 10/11
    Requires .NET Framework for Windows Forms
#>

# Load Windows Forms assembly for GUI message box
Add-Type -AssemblyName System.Windows.Forms

# Retrieve all BIOS information properties from Win32_BIOS CIM class
$bios = Get-CimInstance -ClassName Win32_BIOS

# Prepare a formatted multi-line message with relevant BIOS properties
# Displaying properties commonly used in IT diagnostics and inventory
$message = @"
BIOS Information:

Serial Number        : $($bios.SerialNumber)
Manufacturer         : $($bios.Manufacturer)
BIOS Version         : $($bios.SMBIOSBIOSVersion)
BIOS Release Date    : $($bios.ReleaseDate)
BIOS ListOfLanguages : $($bios.ListOfLanguages -join ', ')
BIOS Manufacturer    : $($bios.Manufacturer)
BIOS PrimaryBIOS     : $($bios.PrimaryBIOS)
BIOS ReleaseDate     : $($bios.ReleaseDate)
BIOS SMBIOSMajorVersion : $($bios.SMBIOSMajorVersion)
BIOS SMBIOSMinorVersion : $($bios.SMBIOSMinorVersion)
BIOS SoftwareElementID  : $($bios.SoftwareElementID)
BIOS SoftwareElementState : $($bios.SoftwareElementState)
BIOS TargetOperatingSystem : $($bios.TargetOperatingSystem)

"@

# Set the message box title
$title = "Detailed BIOS Information"

# Show the information in a message box with an Information icon and OK button
[System.Windows.Forms.MessageBox]::Show($message, $title,
    [System.Windows.Forms.MessageBoxButtons]::OK,
    [System.Windows.Forms.MessageBoxIcon]::Information)
