<#
.SYNOPSIS
    Sets "Speed & Duplex" to "1 Gbps Full Duplex" for all physical network adapters with a progress bar UI.

.DESCRIPTION
    The script enumerates all physical network adapters, attempts to set the "Speed & Duplex" advanced property to "1 Gbps Full Duplex" if available,
    and shows a responsive Windows Form with a progress bar indicating the operation progress.
    Results for each adapter are collected and displayed in a message box upon completion.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Date        : 2025-07-19
    Version     : 1.0

.NOTES
    Requires administrative privileges.
    Tested on Windows 10/11.
#>

Add-Type -AssemblyName System.Windows.Forms

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Configuring Speed & Duplex"
$form.Size = New-Object System.Drawing.Size(400,150)
$form.StartPosition = "CenterScreen"
$form.Topmost = $true
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.MinimizeBox = $false

# Create progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Minimum = 0
$progressBar.Maximum = 100
$progressBar.Style = 'Continuous'
$progressBar.Width = 350
$progressBar.Height = 30
$progressBar.Location = New-Object System.Drawing.Point(20,40)
$form.Controls.Add($progressBar)

# Create status label
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.AutoSize = $false
$statusLabel.Width = 350
$statusLabel.Height = 20
$statusLabel.Location = New-Object System.Drawing.Point(20,80)
$statusLabel.TextAlign = 'MiddleCenter'
$statusLabel.Text = "Starting..."
$form.Controls.Add($statusLabel)

function Update-UI {
    [System.Windows.Forms.Application]::DoEvents()
}

$form.Show()
Update-UI

# Function to show final results in a message box
function Show-MessageBox {
    param (
        [string]$Text,
        [string]$Title = "Speed & Duplex Configuration Results"
    )
    [System.Windows.Forms.MessageBox]::Show($Text, $Title, 
        [System.Windows.Forms.MessageBoxButtons]::OK, 
        [System.Windows.Forms.MessageBoxIcon]::Information)
}

$resultMessages = @()

try {
    $adapters = Get-NetAdapter | Where-Object { $_.HardwareInterface -eq $true }
    $count = $adapters.Count

    if ($count -eq 0) {
        $form.Close()
        Show-MessageBox -Text "No physical network adapters found on this system."
        exit
    }

    $index = 0
    foreach ($adapter in $adapters) {
        $percent = [math]::Round((++$index / $count) * 100)
        $statusLabel.Text = "Processing adapter '$($adapter.Name)'... $percent%"
        $progressBar.Value = $percent
        Update-UI

        try {
            $advancedProps = Get-NetAdapterAdvancedProperty -Name $adapter.Name
            $speedDuplexProp = $advancedProps | Where-Object {
                $_.DisplayName -match 'Speed.*Duplex'
            }

            if ($null -ne $speedDuplexProp) {
                $desiredValue = "1 Gbps Full Duplex"
                if ($speedDuplexProp.DisplayValue -contains $desiredValue) {
                    Set-NetAdapterAdvancedProperty -Name $adapter.Name `
                        -DisplayName $speedDuplexProp.DisplayName `
                        -DisplayValue $desiredValue -NoRestart -ErrorAction Stop

                    $resultMessages += "Adapter '$($adapter.Name)': Speed & Duplex set to '$desiredValue'."
                }
                else {
                    $availableValues = $speedDuplexProp.DisplayValue -join ", "
                    $resultMessages += "Adapter '$($adapter.Name)': Desired value '$desiredValue' NOT available. Available values: $availableValues"
                }
            }
            else {
                $resultMessages += "Adapter '$($adapter.Name)': 'Speed & Duplex' property not found."
            }
        }
        catch {
            $resultMessages += "Adapter '$($adapter.Name)': Failed to set Speed & Duplex. Error: $_"
        }
    }

    $form.Close()

    if ($resultMessages.Count -eq 0) {
        $resultMessages = @("No adapters were processed.")
    }

    Show-MessageBox -Text ($resultMessages -join "`n")
}
catch {
    $form.Close()
    Show-MessageBox -Text "An unexpected error occurred: $_" -Title "Error"
}
