<#
.SYNOPSIS
    Cloud Control Center - Microsoft 365 & Intune Dashboard UI

.DESCRIPTION
    A modern PowerShell WinForms application that provides a clickable
    dashboard for Microsoft cloud services including Intune, Entra ID,
    Defender, Exchange Online, Purview, Azure Portal, and more.

    Built with a light-mode Fluent-style interface to simulate a
    Microsoft 365 admin experience.

.NOTES
    Author: Allester Padovani
    Focus: Intune | Microsoft 365 | Entra ID | Security | Automation
    Requires: Windows PowerShell 5.1 or PowerShell 7 (Windows only UI support)
    UI Framework: System.Windows.Forms
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# =========================
# MARGINS (CONTROL CENTER LAYOUT)
# =========================
$marginLeft = 30
$marginTop = 25
$marginRight = 30
$marginBottom = 25

$tileWidth = 200
$tileHeight = 85
$tileGapX = 20
$tileGapY = 25

$formColumns = 4

# =========================
# FORM
# =========================
$form = New-Object Windows.Forms.Form
$form.Text = "Cloud Control Center"
$form.BackColor = [Drawing.Color]::FromArgb(245,245,245)
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false
$form.StartPosition = "CenterScreen"

# =========================
# HEADER
# =========================
$title = New-Object Windows.Forms.Label
$title.Text = "Cloud Control Center"
$title.Font = New-Object Drawing.Font("Segoe UI Semibold",18,[Drawing.FontStyle]::Bold)
$title.ForeColor = [Drawing.Color]::FromArgb(30,30,30)
$title.AutoSize = $true
$title.Location = New-Object Drawing.Point($marginLeft, $marginTop)
$form.Controls.Add($title)

$sub = New-Object Windows.Forms.Label
$sub.Text = "Intune • Entra ID • Defender • Microsoft 365"
$sub.Font = New-Object Drawing.Font("Segoe UI",10)
$sub.ForeColor = [Drawing.Color]::DimGray
$sub.AutoSize = $true
$sub.Location = New-Object Drawing.Point($marginLeft, ($marginTop + 35))
$form.Controls.Add($sub)

# =========================
# TILE FUNCTION
# =========================
function New-FluentTile {
    param($text,$url,$x,$y)

    $btn = New-Object Windows.Forms.Button
    $btn.Size = New-Object Drawing.Size($tileWidth,$tileHeight)
    $btn.Location = New-Object Drawing.Point($x,$y)

    $btn.FlatStyle = "Flat"
    $btn.FlatAppearance.BorderSize = 0
    $btn.BackColor = [Drawing.Color]::White
    $btn.Font = New-Object Drawing.Font("Segoe UI",10,[Drawing.FontStyle]::Bold)
    $btn.Text = $text
    $btn.Tag = $url
    $btn.Cursor = "Hand"

    $btn.Add_Click({ Start-Process $this.Tag })

    $btn.Add_MouseEnter({ $this.BackColor = [Drawing.Color]::FromArgb(225,240,255) })
    $btn.Add_MouseLeave({ $this.BackColor = [Drawing.Color]::White })

    $form.Controls.Add($btn)
}

# =========================
# TILE GRID START POSITION
# =========================
$gridStartY = 90

$tiles = @(
    @("Microsoft 365 Admin","https://admin.microsoft.com/"),
    @("Entra ID","https://entra.microsoft.com/"),
    @("Intune","https://intune.microsoft.com/"),
    @("Defender","https://security.microsoft.com/"),

    @("Exchange Admin","https://admin.exchange.microsoft.com/"),
    @("Purview","https://compliance.microsoft.com/"),
    @("Windows 365","https://windows365.microsoft.com/"),
    @("Azure Portal","https://portal.azure.com/"),

    @("PowerShell Docs","https://learn.microsoft.com/powershell/"),
    @("Windows Terminal","https://learn.microsoft.com/windows/terminal/"),
    @("GitHub","https://github.com/IntuneAdministrator"),
    @("LinkedIn","https://www.linkedin.com/in/allester-padovani/")
)

# =========================
# CREATE GRID
# =========================
$maxCols = $formColumns
$i = 0

foreach ($tile in $tiles) {

    $row = [math]::Floor($i / $maxCols)
    $col = $i % $maxCols

    $x = $marginLeft + ($col * ($tileWidth + $tileGapX))
    $y = $gridStartY + ($row * ($tileHeight + $tileGapY))

    New-FluentTile $tile[0] $tile[1] $x $y

    $i++
}

# =========================
# ABOUT TEXT (BOTTOM CENTER)
# =========================
$rows = [math]::Ceiling($tiles.Count / $formColumns)
$gridBottom = $gridStartY + ($rows * ($tileHeight + $tileGapY)) - $tileGapY

$about = New-Object Windows.Forms.Label
$about.Size = New-Object Drawing.Size(900,80)
$about.TextAlign = 'MiddleCenter'
$about.ForeColor = [Drawing.Color]::FromArgb(60,60,60)
$about.Font = New-Object Drawing.Font("Segoe UI",9)

$about.Text = @"
Cloud & Endpoint Engineer specializing in:
Microsoft Intune • Entra ID • Defender • Microsoft 365 • PowerShell automation

"If it works smoothly, nobody notices. If it breaks, I fix it fast."
"@

$about.Location = New-Object Drawing.Point($marginLeft, ($gridBottom + 10))
$form.Controls.Add($about)

# =========================
# EXACT FORM SIZING (ALL SIDES BALANCED)
# =========================
$formWidth = ($marginLeft * 2) + ($formColumns * $tileWidth) + (($formColumns - 1) * $tileGapX)

$formHeight = $about.Location.Y + $about.Height + $marginBottom

$form.ClientSize = New-Object Drawing.Size($formWidth, $formHeight)

# =========================
# SHOW
# =========================
[void]$form.ShowDialog()
