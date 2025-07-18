<#
.SYNOPSIS
    Scans battery health (for laptops) and recent CMOS/BIOS-related system event logs.

.DESCRIPTION
    Detects whether the device is portable based on chassis type. If a battery is present, it gathers detailed battery health statistics and displays them.
    Additionally, it scans the last 100 entries in the system event log for CMOS, BIOS, RTC, or battery-related messages on all devices.
    Displays results in GUI message boxes and handles any runtime errors gracefully.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-16

.NOTES
    Compatibility: Windows 11 24H2 and above  
    Requires     : CIM/WMI access, system log access, Windows Forms support
#>

# Load the required assembly to display Windows Forms message boxes
Add-Type -AssemblyName System.Windows.Forms

# Define a reusable function to display information message boxes with a default title
function Show-MessageBox {
    param (
        [string]$Text,             # Text to display in the message box
        [string]$Title = "Information"  # Optional title of the message box
    )
    [System.Windows.Forms.MessageBox]::Show(
        $Text,
        $Title,
        [System.Windows.Forms.MessageBoxButtons]::OK,
        [System.Windows.Forms.MessageBoxIcon]::Information
    )
}

try {
    # Retrieve the chassis types of the system enclosure to determine device type (laptop vs desktop)
    $chassisTypes = (Get-CimInstance -ClassName Win32_SystemEnclosure).ChassisTypes

    # List of chassis type codes that represent portable devices (laptops, tablets, etc.)
    $portableTypes = 8,9,10,14,30

    # Check if any chassis type matches portable types; if so, treat device as laptop
    $isLaptop = $chassisTypes | Where-Object { $portableTypes -contains $_ } | Measure-Object | Select-Object -ExpandProperty Count
    $isLaptop = $isLaptop -gt 0

    # -------- Part 1: Battery Scanner (Only runs on laptops) --------
    if ($isLaptop) {
        # Query battery info from Win32_Battery class
        $batteries = Get-CimInstance -ClassName Win32_Battery

        # If no batteries found, notify user
        if (-not $batteries -or $batteries.Count -eq 0) {
            Show-MessageBox -Text "No battery detected on this laptop device." -Title "Battery Scanner"
        }
        else {
            # Initialize battery report string
            $batteryReport = ""

            # Loop through each battery found and gather detailed info
            foreach ($battery in $batteries) {
                # Translate battery status codes into human-readable strings
                $batteryStatus = switch ($battery.BatteryStatus) {
                    1 {"Discharging"}
                    2 {"AC Power"}
                    3 {"Fully Charged"}
                    4 {"Low"}
                    5 {"Critical"}
                    6 {"Charging"}
                    7 {"Charging and High"}
                    8 {"Charging and Low"}
                    9 {"Charging and Critical"}
                    10 {"Undefined"}
                    11 {"Partially Charged"}
                    default {"Unknown"}
                }

                # Format estimated charge remaining or show Unknown if missing
                $estimatedChargeRemaining = if ($battery.EstimatedChargeRemaining -ne $null) { "$($battery.EstimatedChargeRemaining)%" } else { "Unknown" }

                # Format estimated runtime in hours and minutes if valid, otherwise Unknown
                $estimatedRunTime = if ($battery.EstimatedRunTime -ne $null -and $battery.EstimatedRunTime -ne 0xFFFFFFFF) {
                    $ts = New-TimeSpan -Minutes $battery.EstimatedRunTime
                    "{0:D2}h {1:D2}m" -f $ts.Hours, $ts.Minutes
                } else {
                    "Unknown"
                }

                # Format design capacity and full charge capacity in mWh or Unknown
                $designCapacity = if ($battery.DesignCapacity) { "$($battery.DesignCapacity) mWh" } else { "Unknown" }
                $fullChargeCapacity = if ($battery.FullChargeCapacity) { "$($battery.FullChargeCapacity) mWh" } else { "Unknown" }

                # Format time on battery and time to full charge in seconds or Unknown
                $timeOnBattery = if ($battery.TimeOnBattery) { "$($battery.TimeOnBattery) seconds" } else { "Unknown" }
                $timeToFullCharge = if ($battery.TimeToFullCharge) { "$($battery.TimeToFullCharge) seconds" } else { "Unknown" }

                # Translate battery chemistry code to human-readable form
                $chemistry = switch ($battery.Chemistry) {
                    1 {"Other"}
                    2 {"Unknown"}
                    3 {"Lead Acid"}
                    4 {"Nickel Cadmium"}
                    5 {"Nickel Metal Hydride"}
                    6 {"Lithium-ion"}
                    7 {"Zinc air"}
                    8 {"Lithium Polymer"}
                    default {"Unknown"}
                }

                # Append detailed info for the current battery to the report string
                $batteryReport += @"
Battery Name: $($battery.Name)
Status: $($battery.Status)
Battery Status: $batteryStatus
Estimated Charge Remaining: $estimatedChargeRemaining
Estimated Run Time: $estimatedRunTime
Design Capacity: $designCapacity
Full Charge Capacity: $fullChargeCapacity
Time On Battery: $timeOnBattery
Time To Full Charge: $timeToFullCharge
Chemistry: $chemistry
---------------------------------------------
"@
            }

            # Show the complete battery report in a message box
            Show-MessageBox -Text $batteryReport -Title "Battery Scanner Results"
        }
    }
    else {
        # Inform user if system is a desktop or other non-portable device
        Show-MessageBox -Text "This system is detected as a Desktop / Non-portable device." -Title "Battery Scanner"
    }

    # -------- Part 2: CMOS Battery / BIOS Event Log Scanner (Runs on all systems) --------

    # Retrieve last 100 system event log entries filtering on CMOS, BIOS, battery, or RTC keywords (case-insensitive)
    $events = Get-WinEvent -LogName System -MaxEvents 100 | Where-Object {
        $_.Message -match '(?i)CMOS|BIOS|battery|RTC'
    }

    if (-not $events) {
        # Inform user if no related system events are found
        Show-MessageBox -Text "No CMOS battery, BIOS, or RTC related warnings/errors found in the last 100 system events." -Title "CMOS / BIOS Scan"
    }
    else {
        # Build report of recent related system events with time, ID, level, and truncated message
        $eventReport = "Recent CMOS / BIOS / Battery Related System Events:`n`n"

        foreach ($event in $events) {
            $time = $event.TimeCreated.ToString("yyyy-MM-dd HH:mm:ss")
            $id = $event.Id
            $level = $event.LevelDisplayName
            $message = if ($event.Message.Length -gt 300) {
                $event.Message.Substring(0,300) + "..."
            } else {
                $event.Message
            }

            $eventReport += "Time: $time`nEvent ID: $id`nLevel: $level`nMessage: $message`n-----------------------------`n"
        }

        # Show the event log report in a message box
        Show-MessageBox -Text $eventReport -Title "CMOS / BIOS Event Log Scan Results"
    }
}
catch {
    # If an error occurs during execution, display it in a message box
    Show-MessageBox -Text "An error occurred while running the scanners:`n$($_.Exception.Message)" -Title "Error"
}
