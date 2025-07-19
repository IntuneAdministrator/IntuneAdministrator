<#
.SYNOPSIS
This script checks for network connectivity by pinging google.com.

.DESCRIPTION
This script uses the `Test-Connection` cmdlet to ping google.com and checks if the system has network connectivity. If the ping fails, it outputs a message indicating network connectivity issues and exits with a status code of 1. If the ping is successful, it exits with a status code of 0.

.AUTHOR
Name        : Allester Padovani
Title       : Senior IT Specialist
Script Ver. : 1.0
Date        : 2025-07-17

.NOTES
File Name      : CheckNetworkConnectivity.ps1
Version        : 1.0
Date Created   : 2025-07-19
Last Modified  : 2025-07-19
Change Log     : Initial version of the script to check network connectivity by pinging google.com.
#>

# Check network connectivity by pinging google.com
$pingResult = Test-Connection -ComputerName google.com -Count 2 -Quiet

# If ping fails, output message and exit with status code 1
if (-not $pingResult) {
    Write-Output "Network connectivity issues"
    exit 1
} else {
    # If ping is successful, exit with status code 0
    exit 0
}
