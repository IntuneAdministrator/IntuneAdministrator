<#
.SYNOPSIS
    Adds or updates a registry key to control AI data analysis settings.

.DESCRIPTION
    This script adds or updates a registry key under the specified path to configure the AI data analysis setting.
    The script ensures that the `DisableAIDataAnalysis` registry key is created with the specified value (`1`) and type (`DWord`).
    If the key already exists, it is updated with the provided value.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script modifies the registry key at the specified path to disable AI data analysis by setting the value to `1`.
        - Administrative privileges may be required to execute this script.
        - Always back up the registry before making changes to avoid unintended issues.
#>

##Enter the path to the registry key
$regpath = "HKCU:\Software\Policies\Microsoft\Windows\WindowsAI"
##Enter the name of the registry key
$regname = "DisableAIDataAnalysis"
##Enter the value of the registry key
$regvalue = "1"
##Enter the type of the registry key
$regtype = "DWord"

# Create or update the registry key
New-ItemProperty -Path $regpath -Name $regname -Value $regvalue -PropertyType $regtype -Force
