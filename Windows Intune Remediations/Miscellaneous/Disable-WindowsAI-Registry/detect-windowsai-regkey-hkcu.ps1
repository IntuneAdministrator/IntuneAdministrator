<#
.SYNOPSIS
    Checks if a specific registry key value is compliant with the defined setting for AI data analysis.

.DESCRIPTION
    This script checks whether the registry key `DisableAIDataAnalysis` under the specified path exists and has the value `1`.
    If the registry key exists and is set to the desired value, it outputs "Compliant" and exits with code 0.
    If the registry key exists but has a different value, it outputs a warning "Not Compliant" and exits with code 1.
    If the registry key does not exist, it outputs "RegKey Not Found, Compliant" and exits with code 0.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-19

.NOTES
    Compatibility: Windows 10 and Windows 11
    Usage        : Suitable for local or remote execution.
    Additional Information:
        - The script checks the value of the `DisableAIDataAnalysis` registry key to determine compliance with the defined policy.
        - Ensure that you have appropriate permissions to read the registry.
        - Administrative privileges may be required if modifying or checking registry values under certain paths.
#>

##Enter the path to the registry key
$regpath = "HKCU:\Software\Policies\Microsoft\Windows\WindowsAI"
##Enter the name of the registry key
$regname = "DisableAIDataAnalysis"
##Enter the value of the registry key
$regvalue = "1"

# Try to get the registry key value and compare it to the defined value
Try {
    $Registry = Get-ItemProperty -Path $regpath -Name $regname -ErrorAction Stop | Select-Object -ExpandProperty $regname
    If ($Registry -eq $regvalue){
        Write-Output "Compliant"
        Exit 0
    } 
    Write-Warning "Not Compliant"
    Exit 1
} 
Catch {
    Write-Output "RegKey Not Found, Compliant"
    Exit 0
}
