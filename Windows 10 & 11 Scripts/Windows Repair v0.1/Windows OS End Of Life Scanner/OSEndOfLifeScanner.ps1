<#
.SYNOPSIS
    Displays the current Windows OS version, build, install date, and official End-of-Life (EOL) support status using a graphical MessageBox.

.DESCRIPTION
    This PowerShell script retrieves system details such as the OS name, version, build number, and installation date.
    It compares the OS version to a predefined list of known EOL dates (which should be updated as needed).
    Based on the match, it calculates the number of days remaining until the OS reaches its end of support.
    A MessageBox is shown to the user with the results, and recommendations are made if the system is approaching or has passed EOL.

.NOTES
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-18
    Version     : 1.0
    Requirements:
        - PowerShell 5.1+
        - Windows 10/11 OS with CIM/WMI support
        - .NET Windows Forms components (built-in)

    Modify the $eolDates hashtable with official release-specific EOL data from Microsoft for accuracy.

.LINK
    https://github.com/AllesterPadovani-IntuneAdministrator

.EXAMPLE
    Run the script directly in PowerShell:
    PS C:\> .\Check-WinOSEOLStatus.ps1
#>

Add-Type -AssemblyName System.Windows.Forms

function Show-MessageBox {
    param (
        [string]$Text,
        [string]$Title = "OS End-of-Life Scanner Results"
    )
    [System.Windows.Forms.MessageBox]::Show($Text, $Title,
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information)
}

try {
    # Get OS info
    $os = Get-CimInstance -ClassName Win32_OperatingSystem

    if (-not $os) {
        Show-MessageBox -Text "Failed to get OS information." -Title "Error"
        return
    }

    $osName = $os.Caption
    $osVersion = $os.Version
    $osBuild = $os.BuildNumber
    $installDateRaw = $os.InstallDate

    # Convert install date if present
    if ([string]::IsNullOrEmpty($installDateRaw)) {
        $installDate = "Unknown"
    } else {
        try {
            $installDate = [Management.ManagementDateTimeConverter]::ToDateTime($installDateRaw)
        } catch {
            $installDate = "Invalid date format"
        }
    }

    # Define EOL dates for known versions
    $eolDates = @{
        "10.0.19045" = [datetime]"2025-10-14"  # Windows 10 22H2
        "10.0.22621" = [datetime]"2027-10-14"  # Windows 11 22H2
        "10.0.25365" = [datetime]"2029-10-08"  # Windows 11 24H2 (example)
    }

    # Match EOL date
    $matchedEol = $null
    foreach ($key in $eolDates.Keys) {
        if ($osVersion.StartsWith($key)) {
            $matchedEol = $eolDates[$key]
            break
        }
    }

    if (-not $matchedEol) {
        $matchedEol = [datetime]"2100-01-01"  # Placeholder future date
    }

    $daysLeft = if ($matchedEol -is [datetime]) {
        ($matchedEol - (Get-Date)).Days
    }

    # Build the report
    $report = @"
Operating System: $osName
Version: $osVersion (Build $osBuild)
Installation Date: $installDate
Official End of Support Date: $matchedEol
Days Until End of Support: $daysLeft

"@

    if ($daysLeft -eq $null) {
        $report += "EOL date unknown or invalid."
    } elseif ($daysLeft -lt 0) {
        $report += "Your OS is past its End of Life date. Please upgrade immediately."
    } elseif ($daysLeft -le 90) {
        $report += "Your OS support will end soon. Consider upgrading within 3 months."
    } else {
        $report += "Your OS is supported. No immediate action needed."
    }

    # Show MessageBox
    Show-MessageBox -Text $report
}
catch {
    Show-MessageBox -Text "An unexpected error occurred:`n$_" -Title "Error"
}
