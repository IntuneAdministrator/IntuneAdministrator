<#
.SYNOPSIS
    Enables BitLocker encryption on the system drive (C:) with TPM protector.

.DESCRIPTION
    Activates BitLocker on the C: drive using XtsAes256 encryption method.
    Encrypts only used disk space for faster deployment.
    Protects the drive with TPM hardware security.
    Intended for Windows 11 24H2 and newer environments.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-17

.NOTES
    Compatibility: Windows 11 24H2 and above
    Usage        : Local execution or remote deployment via Intune/GPO
#>

# Enable BitLocker on the system drive
Enable-BitLocker -MountPoint "C:" -EncryptionMethod XtsAes256 -UsedSpaceOnly -TpmProtector

Write-Output "BitLocker has been enabled on the system drive."
