<#
.SYNOPSIS
    Simulates the keypress Ctrl + Shift + Win + B to trigger a graphics driver reset in Windows.

.DESCRIPTION
    This PowerShell script injects inline C# to simulate the key combination Ctrl + Shift + Win + B,
    which resets the display driver and can resolve graphics-related issues without restarting the system.
    A message box confirms the action's completion.

.AUTHOR
    Name        : Allester Padovani
    Title       : Senior IT Specialist
    Script Ver. : 1.0
    Date        : 2025-07-18

.NOTES
    Requires Administrator privileges to simulate keystrokes using Windows API.
    Compatible with Windows 10/11 and later.
    Useful for troubleshooting black screens or stuck display states.
#>

# Inline C# code to simulate key presses using Windows API
# This C# code will be used to send virtual keypresses (Ctrl + Shift + Win + B)
$source = @"
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace KeyboardSend
{
    public class KeyboardSend
    {
        // Import the Windows API function that simulates keyboard events
        [DllImport("user32.dll")]
        public static extern void keybd_event(byte bVk, byte bScan, int dwFlags, int dwExtraInfo);

        // Constants for the key event actions
        private const int KEYEVENTF_EXTENDEDKEY = 1; // Key down event
        private const int KEYEVENTF_KEYUP = 2; // Key up event

        // Method to simulate a key down event
        public static void KeyDown(Keys vKey)
        {
            keybd_event((byte)vKey, 0, KEYEVENTF_EXTENDEDKEY, 0);
        }

        // Method to simulate a key up event
        public static void KeyUp(Keys vKey)
        {
            keybd_event((byte)vKey, 0, KEYEVENTF_EXTENDEDKEY | KEYEVENTF_KEYUP, 0);
        }
    }
}
"@

# Add the C# code to the PowerShell session as a .NET assembly
# This makes the "KeyboardSend" class available to PowerShell for simulating key events
Add-Type -TypeDefinition $source -ReferencedAssemblies "System.Windows.Forms"

# Function to simulate the key combination for graphics driver reset (Ctrl + Shift + Win + B)
Function Press-GraphicsResetKeys {
    # Simulate Ctrl key press
    [KeyboardSend.KeyboardSend]::KeyDown([System.Windows.Forms.Keys]::ControlKey)
    Start-Sleep -Milliseconds 100  # Small delay to ensure keypress is registered

    # Simulate Shift key press
    [KeyboardSend.KeyboardSend]::KeyDown([System.Windows.Forms.Keys]::ShiftKey)
    Start-Sleep -Milliseconds 100

    # Simulate Win key press (Left Windows key)
    [KeyboardSend.KeyboardSend]::KeyDown([System.Windows.Forms.Keys]::LWin)
    Start-Sleep -Milliseconds 100

    # Simulate B key press
    [KeyboardSend.KeyboardSend]::KeyDown([System.Windows.Forms.Keys]::B)
    Start-Sleep -Milliseconds 100

    # Release all keys in reverse order (ensure each key is released after press)
    [KeyboardSend.KeyboardSend]::KeyUp([System.Windows.Forms.Keys]::B)
    Start-Sleep -Milliseconds 100
    [KeyboardSend.KeyboardSend]::KeyUp([System.Windows.Forms.Keys]::LWin)
    Start-Sleep -Milliseconds 100
    [KeyboardSend.KeyboardSend]::KeyUp([System.Windows.Forms.Keys]::ShiftKey)
    Start-Sleep -Milliseconds 100
    [KeyboardSend.KeyboardSend]::KeyUp([System.Windows.Forms.Keys]::ControlKey)
}

# Run the function to simulate the keypress (Ctrl + Shift + Win + B)
Press-GraphicsResetKeys

# Show a MessageBox to inform the user that the audio drivers have been successfully updated.
[System.Windows.Forms.MessageBox]::Show(
    "Graphics card reset (Ctrl + Shift + Win + B) process completed successfully.",  # Message to be displayed in the box
    "Graphics Card Reset",  # Title of the MessageBox
    [System.Windows.Forms.MessageBoxButtons]::OK,  # Button type (OK button only)
    [System.Windows.Forms.MessageBoxIcon]::Information  # Icon type (Information icon)
)
