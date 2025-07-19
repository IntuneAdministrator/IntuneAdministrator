<#
.SYNOPSIS
    Applies a Windows Defender Application Control (WDAC) policy.

.DESCRIPTION
    Copies the specified WDAC policy binary (.cip file) to the active policy folder.
    Uses ciTool.exe to update the WDAC policy with the provided binary.
    Notifies that a system reboot is required for the changes to take effect.
    Designed for Windows 11 24H2 and newer systems.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Requires administrative privileges. Suitable for local or remote deployment via Intune/GPO.
#>

# Define the path to the WDAC policy binary file
$policyBinaryPath = "C:\Path\To\Your\Policy.cip"

# Copy the policy binary to the correct location
$destinationFolder = "$env:windir\System32\CodeIntegrity\CIPolicies\Active\"
Copy-Item -Path $policyBinaryPath -Destination $destinationFolder

# Enable WDAC policy
Start-Process -FilePath "powershell.exe" -ArgumentList "-Command", "ciTool.exe --update-policy $policyBinaryPath" -NoNewWindow -Wait

Write-Output "WDAC policy has been applied. A system reboot is required for changes to take effect."
