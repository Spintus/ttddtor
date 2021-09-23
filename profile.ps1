#  Copyright (c) Microsoft Corporation.  All rights reserved.
#
# THIS SAMPLE CODE AND INFORMATION IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND,
# WHETHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
# IF THIS CODE AND INFORMATION IS MODIFIED, THE ENTIRE RISK OF USE OR RESULTS IN
# CONNECTION WITH THE USE OF THIS CODE AND INFORMATION REMAINS WITH THE USER.

### PowerShell v5.1 Profile
### Version 1.43 - Will Marcum <marcumwill@gmail.com>
###
### This file should be stored in $PROFILE.CurrentUserAllHosts
### If $PROFILE.CurrentUserAllHosts doesn't exist, you can make one with the following:
###    New-Item $PROFILE.CurrentUserAllHosts -ItemType File -Force
### This will create the file and the containing subdirectory if it doesn't already 
###
### As a reminder, to enable unsigned script execution of local scripts on client Windows, 
### you need to run this line (or similar) from an elevated PowerShell prompt:
###   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
### This is the default policy on Windows Server 2012 R2 and above for server Windows. For 
### more information about execution policies, run Get-Help about_Execution_Policies.


#region Windows Console API

# Get access to the Win32 console functions via P/Invoke. For info on these functions, see:
# https://docs.microsoft.com/en-us/windows/console/console-functions
$cSharp = @'
using System;
using System.Text;
using System.Runtime.InteropServices;
// HISTORY
///
// Version 0.1: wherin PInvoke.net snippets are copied in, and missing functions coded and submitted to PInvoke.net
// 11/21/2012 Correcting signature for GetConsoleScreenBufferInfoEx and cleaned up CONSOLE_SCREEN_BUFFER_INFO_EX.ColorTable
namespace ConsoleClassLibrary
{
    /// <summary>
    ///
    /// --- begin MSDN ---
    /// http://msdn.microsoft.com/en-us/library/ms682073(VS.85).aspx
    /// Console Functions
    /// The following functions are used to access a console.
    /// --- end MSDN ---
    ///
    /// </summary>
    public class ConsoleFunctions
    {
        // http://pinvoke.net/default.aspx/kernel32/AddConsoleAlias.html
        [DllImport("kernel32", SetLastError = true)]
        public static extern bool AddConsoleAlias(
            string Source,
            string Target,
            string ExeName
        );
        // http://pinvoke.net/default.aspx/kernel32/AllocConsole.html
        [DllImport("kernel32", SetLastError = true)]
        public static extern bool AllocConsole();
        // http://pinvoke.net/default.aspx/kernel32/AttachConsole.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool AttachConsole(
            uint dwProcessId
        );
        // No pinvoke page! #!!!
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool ClosePseudoConsole(
            IntPtr hPC
        );
        // No pinvoke page! #!!!
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool CreatePseudoConsole(
            COORD      size,
            IntPtr     hInput,
            IntPtr     hOutput,
            uint       dwFlags,
            out IntPtr phPC
        );
        // http://pinvoke.net/default.aspx/kernel32/CreateConsoleScreenBuffer.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern IntPtr CreateConsoleScreenBuffer(
            uint   dwDesiredAccess,
            uint   dwShareMode,
            IntPtr lpSecurityAttributes,
            uint   dwFlags,
            IntPtr lpScreenBufferData
        );
        // http://pinvoke.net/default.aspx/kernel32/FillConsoleOutputAttribute.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool FillConsoleOutputAttribute(
            IntPtr   hConsoleOutput,
            ushort   wAttribute,
            uint     nLength,
            COORD    dwWriteCoord,
            out uint lpNumberOfAttrsWritten
        );
        // http://pinvoke.net/default.aspx/kernel32/FillConsoleOutputCharacter.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool FillConsoleOutputCharacter(
            IntPtr   hConsoleOutput,
            char     cCharacter,
            uint     nLength,
            COORD    dwWriteCoord,
            out uint lpNumberOfCharsWritten
        );
        // http://pinvoke.net/default.aspx/kernel32/FlushConsoleInputBuffer.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool FlushConsoleInputBuffer(
            IntPtr hConsoleInput
        );
        // http://pinvoke.net/default.aspx/kernel32/FreeConsole.html
        [DllImport("kernel32.dll", SetLastError = true, ExactSpelling = true)]
        public static extern bool FreeConsole();
        // http://pinvoke.net/default.aspx/kernel32/GenerateConsoleCtrlEvent.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool GenerateConsoleCtrlEvent(
            uint dwCtrlEvent,
            uint dwProcessGroupId
        );
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleAlias.html
        [DllImport("kernel32", SetLastError = true)]
        public static extern bool GetConsoleAlias(
            string            Source,
            out StringBuilder TargetBuffer,
            uint              TargetBufferLength,
            string            ExeName
        );
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleAliases.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern uint GetConsoleAliases(
            StringBuilder[] lpTargetBuffer,
            uint            targetBufferLength,
            string          lpExeName
        );
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleAliasesLength.html
        [DllImport("kernel32", SetLastError = true)]
        public static extern uint GetConsoleAliasesLength(
            string ExeName
        );
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleAliasExes.html
        [DllImport("kernel32", SetLastError = true)]
        public static extern uint GetConsoleAliasExes(
            out StringBuilder ExeNameBuffer,
            uint              ExeNameBufferLength
        );
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleAliasExesLength.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern uint GetConsoleAliasExesLength();
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleCP.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern uint GetConsoleCP();
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleCursorInfo.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool GetConsoleCursorInfo(
            IntPtr                  hConsoleOutput,
            out CONSOLE_CURSOR_INFO lpConsoleCursorInfo
        );
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleDisplayMode.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool GetConsoleDisplayMode(
            out uint ModeFlags
        );
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleFontSize.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern COORD GetConsoleFontSize(
            IntPtr hConsoleOutput,
            Int32  nFont
        );
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleHistoryInfo.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool GetConsoleHistoryInfo(
            out CONSOLE_HISTORY_INFO ConsoleHistoryInfo
        );
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleMode.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool GetConsoleMode(
            IntPtr   hConsoleHandle,
            out uint lpMode
        );
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleOriginalTitle.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern uint GetConsoleOriginalTitle(
            out StringBuilder ConsoleTitle,
            uint              Size
        );
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleOutputCP.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern uint GetConsoleOutputCP();
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleProcessList.html
        // TODO: Test - what's an out uint[] during interop? This probably isn't quite right, but provides a starting point:
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern uint GetConsoleProcessList(
            out uint[] ProcessList,
            uint       ProcessCount
        );
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleScreenBufferInfo.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool GetConsoleScreenBufferInfo(
            IntPtr                         hConsoleOutput,
            out CONSOLE_SCREEN_BUFFER_INFO lpConsoleScreenBufferInfo
        );
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleScreenBufferInfoEx.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool GetConsoleScreenBufferInfoEx(
            IntPtr                            hConsoleOutput,
            ref CONSOLE_SCREEN_BUFFER_INFO_EX lpConsoleScreenBufferInfoEx
        );
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleSelectionInfo.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool GetConsoleSelectionInfo(
            CONSOLE_SELECTION_INFO ConsoleSelectionInfo
        );
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleTitle.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern uint GetConsoleTitle(
            [Out] StringBuilder lpConsoleTitle,
            uint                nSize
        );
        // http://pinvoke.net/default.aspx/kernel32/GetConsoleWindow.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern IntPtr GetConsoleWindow();
        // http://pinvoke.net/default.aspx/kernel32/GetCurrentConsoleFont.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool GetCurrentConsoleFont(
            IntPtr                hConsoleOutput,
            bool                  bMaximumWindow,
            out CONSOLE_FONT_INFO lpConsoleCurrentFont
        );
        // http://pinvoke.net/default.aspx/kernel32/GetCurrentConsoleFontEx.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool GetCurrentConsoleFontEx(
            IntPtr                   ConsoleOutput,
            bool                     MaximumWindow,
            out CONSOLE_FONT_INFO_EX ConsoleCurrentFont
        );
        // http://pinvoke.net/default.aspx/kernel32/GetLargestConsoleWindowSize.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern COORD GetLargestConsoleWindowSize(
            IntPtr hConsoleOutput
        );
        // http://pinvoke.net/default.aspx/kernel32/GetNumberOfConsoleInputEvents.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool GetNumberOfConsoleInputEvents(
            IntPtr   hConsoleInput,
            out uint lpcNumberOfEvents
        );
        // http://pinvoke.net/default.aspx/kernel32/GetNumberOfConsoleMouseButtons.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool GetNumberOfConsoleMouseButtons(
            ref uint lpNumberOfMouseButtons
        );
        // http://pinvoke.net/default.aspx/kernel32/GetStdHandle.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern IntPtr GetStdHandle(
            int nStdHandle
        );
        // http://pinvoke.net/default.aspx/kernel32/HandlerRoutine.html
        // Delegate type to be used as the Handler Routine for SCCH
        public delegate bool ConsoleCtrlDelegate(CtrlTypes CtrlType);
        // http://pinvoke.net/default.aspx/kernel32/PeekConsoleInput.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool PeekConsoleInput(
            IntPtr               hConsoleInput,
            [Out] INPUT_RECORD[] lpBuffer,
            uint                 nLength,
            out uint             lpNumberOfEventsRead
        );
        // http://pinvoke.net/default.aspx/kernel32/ReadConsole.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool ReadConsole(
            IntPtr              hConsoleInput,
            [Out] StringBuilder lpBuffer,
            uint                nNumberOfCharsToRead,
            out uint            lpNumberOfCharsRead,
            IntPtr              lpReserved
        );
        // http://pinvoke.net/default.aspx/kernel32/ReadConsoleInput.html
        [DllImport("kernel32.dll", EntryPoint = "ReadConsoleInputW", CharSet = CharSet.Unicode)]
        public static extern bool ReadConsoleInput(
            IntPtr               hConsoleInput,
            [Out] INPUT_RECORD[] lpBuffer,
            uint                 nLength,
            out uint             lpNumberOfEventsRead
        );
        // http://pinvoke.net/default.aspx/kernel32/ReadConsoleOutput.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool ReadConsoleOutput(
            IntPtr            hConsoleOutput,
            [Out] CHAR_INFO[] lpBuffer,
            COORD             dwBufferSize,
            COORD             dwBufferCoord,
            ref SMALL_RECT    lpReadRegion
        );
        // http://pinvoke.net/default.aspx/kernel32/ReadConsoleOutputAttribute.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool ReadConsoleOutputAttribute(
            IntPtr         hConsoleOutput,
            [Out] ushort[] lpAttribute,
            uint           nLength,
            COORD          dwReadCoord,
            out uint       lpNumberOfAttrsRead
        );
        // http://pinvoke.net/default.aspx/kernel32/ReadConsoleOutputCharacter.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool ReadConsoleOutputCharacter(
            IntPtr              hConsoleOutput,
            [Out] StringBuilder lpCharacter,
            uint                nLength,
            COORD               dwReadCoord,
            out uint            lpNumberOfCharsRead
        );
        // No pinvoke page! #!!!
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool ResizePseudoConsole(
            IntPtr hPC,
            COORD  size
        );
        // http://pinvoke.net/default.aspx/kernel32/ScrollConsoleScreenBuffer.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool ScrollConsoleScreenBuffer(
            IntPtr              hConsoleOutput,
            [In] ref SMALL_RECT lpScrollRectangle,
            IntPtr              lpClipRectangle,
            COORD               dwDestinationOrigin,
            [In] ref CHAR_INFO  lpFill
        );
        // http://pinvoke.net/default.aspx/kernel32/SetConsoleActiveScreenBuffer.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetConsoleActiveScreenBuffer(
            IntPtr hConsoleOutput
        );
        // http://pinvoke.net/default.aspx/kernel32/SetConsoleCP.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetConsoleCP(
            uint wCodePageID
        );
        // http://pinvoke.net/default.aspx/kernel32/SetConsoleCtrlHandler.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetConsoleCtrlHandler(
            ConsoleCtrlDelegate HandlerRoutine,
            bool                Add
        );
        // http://pinvoke.net/default.aspx/kernel32/SetConsoleCursorInfo.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetConsoleCursorInfo(
            IntPtr                       hConsoleOutput,
            [In] ref CONSOLE_CURSOR_INFO lpConsoleCursorInfo
        );
        // http://pinvoke.net/default.aspx/kernel32/SetConsoleCursorPosition.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetConsoleCursorPosition(
            IntPtr hConsoleOutput,
            COORD  dwCursorPosition
        );
        // http://pinvoke.net/default.aspx/kernel32/SetConsoleDisplayMode.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetConsoleDisplayMode(
            IntPtr    ConsoleOutput,
            uint      Flags,
            out COORD NewScreenBufferDimensions
        );
        // http://pinvoke.net/default.aspx/kernel32/SetConsoleHistoryInfo.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetConsoleHistoryInfo(
            CONSOLE_HISTORY_INFO ConsoleHistoryInfo
        );
        // http://pinvoke.net/default.aspx/kernel32/SetConsoleMode.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetConsoleMode(
            IntPtr hConsoleHandle,
            uint   dwMode
        );
        // http://pinvoke.net/default.aspx/kernel32/SetConsoleOutputCP.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetConsoleOutputCP(
            uint wCodePageID
        );
        // http://pinvoke.net/default.aspx/kernel32/SetConsoleScreenBufferInfoEx.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetConsoleScreenBufferInfoEx(
            IntPtr                        hConsoleOutput,
            CONSOLE_SCREEN_BUFFER_INFO_EX lpConsoleScreenBufferInfoEx
        );
        // http://pinvoke.net/default.aspx/kernel32/SetConsoleScreenBufferSize.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetConsoleScreenBufferSize(
            IntPtr hConsoleOutput,
            COORD  dwSize
        );
        // http://pinvoke.net/default.aspx/kernel32/SetConsoleTextAttribute.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetConsoleTextAttribute(
            IntPtr hConsoleOutput,
            ushort wAttributes
        );
        // http://pinvoke.net/default.aspx/kernel32/SetConsoleTitle.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetConsoleTitle(
            string lpConsoleTitle
        );
        // http://pinvoke.net/default.aspx/kernel32/SetConsoleWindowInfo.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetConsoleWindowInfo(
            IntPtr              hConsoleOutput,
            bool                bAbsolute,
            [In] ref SMALL_RECT lpConsoleWindow
        );
        // http://pinvoke.net/default.aspx/kernel32/SetCurrentConsoleFontEx.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetCurrentConsoleFontEx(
            IntPtr               ConsoleOutput,
            bool                 MaximumWindow,
            CONSOLE_FONT_INFO_EX ConsoleCurrentFontEx
        );
        // http://pinvoke.net/default.aspx/kernel32/SetStdHandle.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool SetStdHandle(
            uint   nStdHandle,
            IntPtr hHandle
        );
        // http://pinvoke.net/default.aspx/kernel32/WriteConsole.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool WriteConsole(
            IntPtr   hConsoleOutput,
            string   lpBuffer,
            uint     nNumberOfCharsToWrite,
            out uint lpNumberOfCharsWritten,
            IntPtr   lpReserved
        );
        // http://pinvoke.net/default.aspx/kernel32/WriteConsoleInput.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool WriteConsoleInput(
            IntPtr         hConsoleInput,
            INPUT_RECORD[] lpBuffer,
            uint           nLength,
            out uint       lpNumberOfEventsWritten
        );
        // http://pinvoke.net/default.aspx/kernel32/WriteConsoleOutput.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool WriteConsoleOutput(
            IntPtr         hConsoleOutput,
            CHAR_INFO[]    lpBuffer,
            COORD          dwBufferSize,
            COORD          dwBufferCoord,
            ref SMALL_RECT lpWriteRegion
        );
        // http://pinvoke.net/default.aspx/kernel32/WriteConsoleOutputAttribute.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool WriteConsoleOutputAttribute(
            IntPtr   hConsoleOutput,
            ushort[] lpAttribute,
            uint     nLength,
            COORD    dwWriteCoord,
            out uint lpNumberOfAttrsWritten
        );
        // http://pinvoke.net/default.aspx/kernel32/WriteConsoleOutputCharacter.html
        [DllImport("kernel32.dll", SetLastError = true)]
        public static extern bool WriteConsoleOutputCharacter(
            IntPtr   hConsoleOutput,
            string   lpCharacter,
            uint     nLength,
            COORD    dwWriteCoord,
            out uint lpNumberOfCharsWritten
        );
        [StructLayout(LayoutKind.Sequential)]
        public struct COORD
        {
            public short X;
            public short Y;
        }
        public struct SMALL_RECT
        {
            public short Left;
            public short Top;
            public short Right;
            public short Bottom;
        }
        public struct CONSOLE_SCREEN_BUFFER_INFO
        {
            public COORD      dwSize;
            public COORD      dwCursorPosition;
            public short      wAttributes;
            public SMALL_RECT srWindow;
            public COORD      dwMaximumWindowSize;
        }
        [StructLayout(LayoutKind.Sequential)]
        public struct CONSOLE_SCREEN_BUFFER_INFO_EX
        {
            public uint       cbSize;
            public COORD      dwSize;
            public COORD      dwCursorPosition;
            public ushort     wAttributes;
            public SMALL_RECT srWindow;
            public COORD      dwMaximumWindowSize;
            public ushort     wPopupAttributes;
            public bool       bFullscreenSupported;
            [MarshalAs(UnmanagedType.ByValArray, SizeConst = 16)]
            public COLORREF[] ColorTable;
            public static CONSOLE_SCREEN_BUFFER_INFO_EX Create()
            {
                return new CONSOLE_SCREEN_BUFFER_INFO_EX { cbSize = 96 };
            }
        }
        //[StructLayout(LayoutKind.Sequential)]
        //struct COLORREF
        //{
        //    public byte R;
        //    public byte G;
        //    public byte B;
        //}
        [StructLayout(LayoutKind.Sequential)]
        public struct COLORREF
        {
            public uint ColorDWORD;
            public COLORREF(System.Drawing.Color color)
            {
                ColorDWORD = (uint)color.R + (((uint)color.G) << 8) + (((uint)color.B) << 16);
            }
            public System.Drawing.Color GetColor()
            {
                return System.Drawing.Color.FromArgb((int)(0x000000FFU & ColorDWORD),
                    (int)(0x0000FF00U & ColorDWORD) >> 8, (int)(0x00FF0000U & ColorDWORD) >> 16);
            }
            public void SetColor(System.Drawing.Color color)
            {
                ColorDWORD = (uint)color.R + (((uint)color.G) << 8) + (((uint)color.B) << 16);
            }
        }
        [StructLayout(LayoutKind.Sequential)]
        public struct CONSOLE_FONT_INFO
        {
            public int   nFont;
            public COORD dwFontSize;
        }
        [StructLayout(LayoutKind.Sequential)]
        public unsafe struct CONSOLE_FONT_INFO_EX
        {
            public uint   cbSize;
            public uint   nFont;
            public COORD  dwFontSize;
            public ushort FontFamily;
            public ushort FontWeight;
            fixed char    FaceName[LF_FACESIZE];
            const int     LF_FACESIZE = 32;
        }
        [StructLayout(LayoutKind.Explicit)]
        public struct INPUT_RECORD
        {
            [FieldOffset(0)]
            public ushort                    EventType;
            [FieldOffset(4)]
            public KEY_EVENT_RECORD          KeyEvent;
            [FieldOffset(4)]
            public MOUSE_EVENT_RECORD        MouseEvent;
            [FieldOffset(4)]
            public WINDOW_BUFFER_SIZE_RECORD WindowBufferSizeEvent;
            [FieldOffset(4)]
            public MENU_EVENT_RECORD         MenuEvent;
            [FieldOffset(4)]
            public FOCUS_EVENT_RECORD        FocusEvent;
        };
        [StructLayout(LayoutKind.Explicit, CharSet = CharSet.Unicode)]
        public struct KEY_EVENT_RECORD
        {
            [FieldOffset(0), MarshalAs(UnmanagedType.Bool)]
            public bool   bKeyDown;
            [FieldOffset(4), MarshalAs(UnmanagedType.U2)]
            public ushort wRepeatCount;
            [FieldOffset(6), MarshalAs(UnmanagedType.U2)]
            //public VirtualKeys wVirtualKeyCode;
            public ushort wVirtualKeyCode;
            [FieldOffset(8), MarshalAs(UnmanagedType.U2)]
            public ushort wVirtualScanCode;
            [FieldOffset(10)]
            public char   UnicodeChar;
            [FieldOffset(12), MarshalAs(UnmanagedType.U4)]
            //public ControlKeyState dwControlKeyState;
            public uint   dwControlKeyState;
        }
        [StructLayout(LayoutKind.Sequential)]
        public struct MOUSE_EVENT_RECORD
        {
            public COORD dwMousePosition;
            public uint  dwButtonState;
            public uint  dwControlKeyState;
            public uint  dwEventFlags;
        }
        public struct WINDOW_BUFFER_SIZE_RECORD
        {
            public COORD dwSize;
            public WINDOW_BUFFER_SIZE_RECORD(short x, short y)
            {
                dwSize = new COORD();
                dwSize.X = x;
                dwSize.Y = y;
            }
        }
        [StructLayout(LayoutKind.Sequential)]
        public struct MENU_EVENT_RECORD
        {
            public uint dwCommandId;
        }
        [StructLayout(LayoutKind.Sequential)]
        public struct FOCUS_EVENT_RECORD
        {
            public uint bSetFocus;
        }
        //CHAR_INFO struct, which was a union in the old days
        // so we want to use LayoutKind.Explicit to mimic it as closely
        // as we can
        [StructLayout(LayoutKind.Explicit)]
        public struct CHAR_INFO
        {
            [FieldOffset(0)]
            char   UnicodeChar;
            [FieldOffset(0)]
            char   AsciiChar;
            [FieldOffset(2)] //2 bytes seems to work properly
            UInt16 Attributes;
        }
        [StructLayout(LayoutKind.Sequential)]
        public struct CONSOLE_CURSOR_INFO
        {
            uint Size;
            bool Visible;
        }
        [StructLayout(LayoutKind.Sequential)]
        public struct CONSOLE_HISTORY_INFO
        {
            ushort cbSize;
            ushort HistoryBufferSize;
            ushort NumberOfHistoryBuffers;
            uint   dwFlags;
        }
        [StructLayout(LayoutKind.Sequential)]
        public struct CONSOLE_SELECTION_INFO
        {
            uint Flags;
            COORD      SelectionAnchor;
            SMALL_RECT Selection;
            // Flags values:
            const uint CONSOLE_MOUSE_DOWN            = 0x0008; // Mouse is down
            const uint CONSOLE_MOUSE_SELECTION       = 0x0004; //Selecting with the mouse
            const uint CONSOLE_NO_SELECTION          = 0x0000; //No selection
            const uint CONSOLE_SELECTION_IN_PROGRESS = 0x0001; //Selection has begun
            const uint CONSOLE_SELECTION_NOT_EMPTY   = 0x0002; //Selection rectangle is not empty
        }
        // Enumerated type for the control messages sent to the handler routine
        public enum CtrlTypes : uint
        {
            CTRL_C_EVENT      = 0,
            CTRL_BREAK_EVENT,
            CTRL_CLOSE_EVENT,
            CTRL_LOGOFF_EVENT = 5,
            CTRL_SHUTDOWN_EVENT
        }
    }
}
'@
# Above code modified from: http://pinvoke.net/default.aspx/kernel32/ConsoleFunctions.html
# As written on pinvoke.net, code does not play well with PowerShell. Tweaks include:
#   - Formatting a bit for readability
#   - Made everything public to fix compilation error (functions, enums, structs).
#   - Slightly modified CONSOLE_SCREEN_BUFFER_INFO_EX struct to fix what seems to be a typo on line 525.
#   - Changed CONSOLE_FONT_INFO_EX struct to use int for LF_FACESIZE instead of uint.
#   - Modified method signatures for correct parameter naming:
#       • GetConsoleScreenBufferInfoEx
#       • SetConsoleScreenBufferInfoEx
#   - Added signatures for missing methods (new in RS5):
#       • ClosePseudoConsole
#       • CreatePseudoConsole
#       • ResizePseudoConsole
$path = 'C:\Windows\Microsoft.NET\Framework\v4.0.30319'
$assemblies = @("$path\System.Drawing.dll")
$cp = [System.CodeDom.Compiler.CompilerParameters]::new($assemblies)
$cp.CompilerOptions = '/unsafe'
Add-Type -TypeDefinition $cSharp -CompilerParameters $cp
Remove-Variable cSharp
Remove-Variable path
Remove-Variable assemblies
Remove-Variable cp

#endregion


#region Color Utilities

#region Color Defs

# Load system.drawing first to prevent type-related complaints.
$assembly = 'System.Drawing, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a'
[void] [System.Reflection.Assembly]::Load($assembly)
Remove-Variable assembly
# [void] [System.Reflection.Assembly]::LoadWithPartialName('System.Drawing')

# PowerShell Default colors
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $PS_BLACK          = [System.Drawing.Color]::FromArgb(0xff000000)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $PS_DARKBLUE       = [System.Drawing.Color]::FromArgb(0xff000080)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $PS_DARKGREEN      = [System.Drawing.Color]::FromArgb(0xff008000)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $PS_DARKCYAN       = [System.Drawing.Color]::FromArgb(0xff008080)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $PS_DARKRED        = [System.Drawing.Color]::FromArgb(0xff800000)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $PS_DARKMAGENTA    = [System.Drawing.Color]::FromArgb(0xff012456)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $PS_DARKYELLOW     = [System.Drawing.Color]::FromArgb(0xffeeedf0)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $PS_GRAY           = [System.Drawing.Color]::FromArgb(0xffc0c0c0)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $PS_DARKGRAY       = [System.Drawing.Color]::FromArgb(0xff808080)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $PS_BLUE           = [System.Drawing.Color]::FromArgb(0xff0000ff)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $PS_GREEN          = [System.Drawing.Color]::FromArgb(0xff00ff00)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $PS_CYAN           = [System.Drawing.Color]::FromArgb(0xff00ffff)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $PS_RED            = [System.Drawing.Color]::FromArgb(0xffff0000)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $PS_MAGENTA        = [System.Drawing.Color]::FromArgb(0xffff00ff)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $PS_YELLOW         = [System.Drawing.Color]::FromArgb(0xffffff00)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $PS_WHITE          = [System.Drawing.Color]::FromArgb(0xffffffff)

# Solarized theme colors
# https://github.com/neilpa/cmd-colors-solarized
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $SOLARIZED_BASE03  = [System.Drawing.Color]::FromArgb(0x00002b36)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $SOLARIZED_BASE02  = [System.Drawing.Color]::FromArgb(0x00073642)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $SOLARIZED_BASE01  = [System.Drawing.Color]::FromArgb(0x00586e75)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $SOLARIZED_BASE00  = [System.Drawing.Color]::FromArgb(0x00657b83)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $SOLARIZED_BASE0   = [System.Drawing.Color]::FromArgb(0x00839496)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $SOLARIZED_BASE1   = [System.Drawing.Color]::FromArgb(0x0093a1a1)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $SOLARIZED_BASE2   = [System.Drawing.Color]::FromArgb(0x00eee8d5)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $SOLARIZED_BASE3   = [System.Drawing.Color]::FromArgb(0x00fdf6e3)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $SOLARIZED_YELLOW  = [System.Drawing.Color]::FromArgb(0x00b58900)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $SOLARIZED_ORANGE  = [System.Drawing.Color]::FromArgb(0x00cb4b16)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $SOLARIZED_RED     = [System.Drawing.Color]::FromArgb(0x00dc322f)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $SOLARIZED_MAGENTA = [System.Drawing.Color]::FromArgb(0x00d33682)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $SOLARIZED_VIOLET  = [System.Drawing.Color]::FromArgb(0x006c71c4)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $SOLARIZED_BLUE    = [System.Drawing.Color]::FromArgb(0x00268bd2)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $SOLARIZED_CYAN    = [System.Drawing.Color]::FromArgb(0x002aa198)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $SOLARIZED_GREEN   = [System.Drawing.Color]::FromArgb(0x00859900)

# Old BI colors
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $BI_GUNMETAL       = [System.Drawing.Color]::FromArgb(0x0049494A)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $BI_BLACK          = [System.Drawing.Color]::FromArgb(0x00000000)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $BI_WHITE          = [System.Drawing.Color]::FromArgb(0x00FFFFFF)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $BI_SURFACE        = [System.Drawing.Color]::FromArgb(0x004A6A9A)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $BI_METROLOGY      = [System.Drawing.Color]::FromArgb(0x00647A67)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $BI_QUAZAR         = [System.Drawing.Color]::FromArgb(0x00A7A9AC)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $BI_ACCENT         = [System.Drawing.Color]::FromArgb(0x00E3811C)

# New BI/IDI colors
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $BI_BLUE           = [System.Drawing.Color]::FromArgb(0x004A6A9A)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $BI_GREY           = [System.Drawing.Color]::FromArgb(0x006A737B)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $IDI_ORANGE        = [System.Drawing.Color]::FromArgb(0x00F37321)

# New BI/IDI Non-standard colors (used in official logos/docs but can't find in styleguide)
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $MEDIUM_GREY       = [System.Drawing.Color]::FromArgb(0x00515959) # "Powered By.."
[ConsoleClassLibrary.ConsoleFunctions+COLORREF] $DARK_GREY         = [System.Drawing.Color]::FromArgb(0x00222222) # Background

#endregion


#region Reference ColorTables

# Reference (default-valued) InfoEx
$defaultInfoEx = [ConsoleClassLibrary.ConsoleFunctions+CONSOLE_SCREEN_BUFFER_INFO_EX]::Create()
[ConsoleClassLibrary.ConsoleFunctions+COLORREF[]] $defaultInfoEx.ColorTable = @()
0..15 | Foreach-Object {$defaultInfoEx.ColorTable += New-Object ConsoleClassLibrary.ConsoleFunctions+COLORREF}
$defaultInfoEx.ColorTable[00] = $PS_BLACK       # Black
$defaultInfoEx.ColorTable[01] = $PS_DARKBLUE    # DarkBlue
$defaultInfoEx.ColorTable[02] = $PS_DARKGREEN   # DarkGreen
$defaultInfoEx.ColorTable[03] = $PS_DARKCYAN    # DarkCyan
$defaultInfoEx.ColorTable[04] = $PS_DARKRED     # DarkRed
$defaultInfoEx.ColorTable[05] = $PS_DARKMAGENTA # DarkMagenta
$defaultInfoEx.ColorTable[06] = $PS_DARKYELLOW  # DarkYellow
$defaultInfoEx.ColorTable[07] = $PS_GRAY        # Gray
$defaultInfoEx.ColorTable[08] = $PS_DARKGRAY    # DarkGray
$defaultInfoEx.ColorTable[09] = $PS_BLUE        # Blue
$defaultInfoEx.ColorTable[10] = $PS_GREEN       # Green
$defaultInfoEx.ColorTable[11] = $PS_CYAN        # Cyan
$defaultInfoEx.ColorTable[12] = $PS_RED         # Red
$defaultInfoEx.ColorTable[13] = $PS_MAGENTA     # Magenta
$defaultInfoEx.ColorTable[14] = $PS_YELLOW      # Yellow
$defaultInfoEx.ColorTable[15] = $PS_WHITE       # White

# Solarized InfoEx
# https://ethanschoonover.com/solarized/
$solarizedInfoEx = [ConsoleClassLibrary.ConsoleFunctions+CONSOLE_SCREEN_BUFFER_INFO_EX]::Create()
[ConsoleClassLibrary.ConsoleFunctions+COLORREF[]] $solarizedInfoEx.ColorTable = @()
0..15 | Foreach-Object {$solarizedInfoEx.ColorTable += New-Object ConsoleClassLibrary.ConsoleFunctions+COLORREF}
$solarizedInfoEx.ColorTable[00] = $SOLARIZED_VIOLET  # Black
$solarizedInfoEx.ColorTable[01] = $SOLARIZED_BASE0   # DarkBlue
$solarizedInfoEx.ColorTable[02] = $SOLARIZED_BASE01  # DarkGreen
$solarizedInfoEx.ColorTable[03] = $SOLARIZED_BASE1   # DarkCyan
$solarizedInfoEx.ColorTable[04] = $SOLARIZED_ORANGE  # DarkRed
$solarizedInfoEx.ColorTable[05] = $SOLARIZED_BASE03  # DarkMagenta
$solarizedInfoEx.ColorTable[06] = $SOLARIZED_BASE00  # DarkYellow
$solarizedInfoEx.ColorTable[07] = $SOLARIZED_BASE2   # Gray
$solarizedInfoEx.ColorTable[08] = $SOLARIZED_BASE02  # DarkGray
$solarizedInfoEx.ColorTable[09] = $SOLARIZED_BLUE    # Blue
$solarizedInfoEx.ColorTable[10] = $SOLARIZED_GREEN   # Green
$solarizedInfoEx.ColorTable[11] = $SOLARIZED_CYAN    # Cyan
$solarizedInfoEx.ColorTable[12] = $SOLARIZED_RED     # Red
$solarizedInfoEx.ColorTable[13] = $SOLARIZED_MAGENTA # Magenta
$solarizedInfoEx.ColorTable[14] = $SOLARIZED_YELLOW  # Yellow
$solarizedInfoEx.ColorTable[15] = $SOLARIZED_BASE3   # White

#endregion


#region Palette Functions

function Set-ColorPSDefault
{
    if ([System.Version](Get-Module PSReadline).Version -ge [System.Version]'2.1.0')
    {
        Set-PSReadLineOption -Colors @{
            Command            = "$([char]0x1b)[93m"
            Comment            = "$([char]0x1b)[32m"
            ContinuationPrompt = "$([char]0x1b)[33m"
            Default            = "$([char]0x1b)[33m"
            Emphasis           = "$([char]0x1b)[96m"
            Error              = "$([char]0x1b)[91m"
            InlinePrediction   = "$([char]0x1b)[38;5;238m"
            Keyword            = "$([char]0x1b)[92m"
            Member             = "$([char]0x1b)[97m"
            Number             = "$([char]0x1b)[97m"
            Operator           = "$([char]0x1b)[90m"
            Parameter          = "$([char]0x1b)[90m"
            Selection          = "$([char]0x1b)[35;43m"
            String             = "$([char]0x1b)[36m"
            Type               = "$([char]0x1b)[37m"
            Variable           = "$([char]0x1b)[92m"
        }
    }

    $outHandle = [ConsoleClassLibrary.ConsoleFunctions]::GetStdHandle(-11)
    $bufferInfoEx = [ConsoleClassLibrary.ConsoleFunctions+CONSOLE_SCREEN_BUFFER_INFO_EX]::Create()
    [void] [ConsoleClassLibrary.ConsoleFunctions]::GetConsoleScreenBufferInfoEx($outHandle, [ref] $bufferInfoEx)

    $bufferInfoEx.ColorTable = $defaultInfoEx.ColorTable
    $bufferInfoEx.wAttributes = [int16]0x40 + [int16]0x10 + [int16]0x4 + [int16]0x2

    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
    {
        $bufferInfoEx.ColorTable[5] = $PS_DARKRED
    }

    [void] [ConsoleClassLibrary.ConsoleFunctions]::SetConsoleTextAttribute($outHandle, $bufferInfoEx.wAttributes)
    [void] [ConsoleClassLibrary.ConsoleFunctions]::SetConsoleScreenBufferInfoEx($outHandle, $bufferInfoEx)

    # Host Foreground
    $Host.UI.RawUI.ForegroundColor            = 'DarkYellow'
    $Host.PrivateData.ErrorForegroundColor    = 'Red'
    $Host.PrivateData.WarningForegroundColor  = 'Yellow'
    $Host.PrivateData.DebugForegroundColor    = 'Yellow'
    $Host.PrivateData.VerboseForegroundColor  = 'Yellow'
    $Host.PrivateData.ProgressForegroundColor = 'Yellow'

    # Host Background
    $Host.UI.RawUI.BackgroundColor            = 'DarkMagenta'
    $Host.PrivateData.ErrorBackgroundColor    = 'Black'
    $Host.PrivateData.WarningBackgroundColor  = 'Black'
    $Host.PrivateData.DebugBackgroundColor    = 'Black'
    $Host.PrivateData.VerboseBackgroundColor  = 'Black'
    $Host.PrivateData.ProgressBackgroundColor = 'DarkCyan'
}

function Set-ColorSolarizedDark
{
    if ([System.Version](Get-Module PSReadline).Version -ge [System.Version]'2.1.0')
    {
        Set-PSReadLineOption -Colors @{
            Command            = "$([char]0x1b)[93;45m"  # Yellow
            Comment            = "$([char]0x1b)[32;45m"  # DarkGreen
            ContinuationPrompt = "$([char]0x1b)[34;45m"  # DarkBlue
            Default            = "$([char]0x1b)[34;45m"  # DarkBlue
            Emphasis           = "$([char]0x1b)[96;45m"  # Cyan
            Error              = "$([char]0x1b)[91;45m"  # Red
            InlinePrediction   = "$([char]0x1b)[96;45m"  # Cyan
            Keyword            = "$([char]0x1b)[92;45m"  # Green
            Member             = "$([char]0x1b)[36;45m"  # DarkCyan
            Number             = "$([char]0x1b)[36;45m"  # DarkCyan
            Operator           = "$([char]0x1b)[32;45m"  # DarkGreen
            Parameter          = "$([char]0x1b)[32;45m"  # DarkGreen
            Selection          = "$([char]0x1b)[30;107m" # Black on White
            String             = "$([char]0x1b)[94;45m"  # Blue
            Type               = "$([char]0x1b)[33;45m"  # DarkYellow
            Variable           = "$([char]0x1b)[92;45m"  # Green
        }
    }

    $outHandle = [ConsoleClassLibrary.ConsoleFunctions]::GetStdHandle(-11)
    $bufferInfoEx = [ConsoleClassLibrary.ConsoleFunctions+CONSOLE_SCREEN_BUFFER_INFO_EX]::Create()
    [void] [ConsoleClassLibrary.ConsoleFunctions]::GetConsoleScreenBufferInfoEx($outHandle, [ref] $bufferInfoEx)

    $bufferInfoEx.ColorTable = $solarizedInfoEx.ColorTable
    $bufferInfoEx.ColorTable[5] = $SOLARIZED_BASE03
    $bufferInfoEx.ColorTable[15] = $SOLARIZED_BASE3
    $bufferInfoEx.wAttributes = [int16]0x4 + [int16]0x2

    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
    {
        $bufferInfoEx.ColorTable[5] = $PS_DARKRED
    }

    [void] [ConsoleClassLibrary.ConsoleFunctions]::SetConsoleTextAttribute($outHandle, $bufferInfoEx.wAttributes)
    [void] [ConsoleClassLibrary.ConsoleFunctions]::SetConsoleScreenBufferInfoEx($outHandle, $bufferInfoEx)

    # Host Foreground
    $Host.UI.RawUI.ForegroundColor            = 'DarkBlue'
    $Host.PrivateData.ErrorForegroundColor    = 'Red'
    $Host.PrivateData.WarningForegroundColor  = 'Yellow'
    $Host.PrivateData.DebugForegroundColor    = 'Green'
    $Host.PrivateData.VerboseForegroundColor  = 'Blue'
    $Host.PrivateData.ProgressForegroundColor = 'Gray'

    # Host Background
    $Host.UI.RawUI.BackgroundColor            = 'DarkMagenta'
    $Host.PrivateData.ErrorBackgroundColor    = 'DarkGray'
    $Host.PrivateData.WarningBackgroundColor  = 'DarkGray'
    $Host.PrivateData.DebugBackgroundColor    = 'DarkGray'
    $Host.PrivateData.VerboseBackgroundColor  = 'DarkGray'
    $Host.PrivateData.ProgressBackgroundColor = 'Cyan'
}

function Set-ColorSolarizedLight
{
    if ([System.Version](Get-Module PSReadline).Version -ge [System.Version]'2.1.0')
    {
        Set-PSReadLineOption -Colors @{
            Command            = "$([char]0x1b)[93;45m" # Yellow
            Comment            = "$([char]0x1b)[32;45m" # DarkGreen
            ContinuationPrompt = "$([char]0x1b)[33;45m" # DarkYellow
            Default            = "$([char]0x1b)[33;45m" # DarkYellow
            Emphasis           = "$([char]0x1b)[96;45m" # Cyan
            Error              = "$([char]0x1b)[91;45m" # Red
            InlinePrediction   = "$([char]0x1b)[96;45m" # Cyan
            Keyword            = "$([char]0x1b)[92;45m" # Green
            Member             = "$([char]0x1b)[32;45m" # DarkGreen
            Number             = "$([char]0x1b)[32;45m" # DarkGreen
            Operator           = "$([char]0x1b)[36;45m" # DarkCyan
            Parameter          = "$([char]0x1b)[36;45m" # DarkCyan
            Selection          = "$([char]0x1b)[37;107m" # White on Black
            String             = "$([char]0x1b)[94;45m" # Blue
            Type               = "$([char]0x1b)[34;45m" # DarkBlue
            Variable           = "$([char]0x1b)[92;45m" # Green
        }
    }

    $outHandle = [ConsoleClassLibrary.ConsoleFunctions]::GetStdHandle(-11)
    $bufferInfoEx = [ConsoleClassLibrary.ConsoleFunctions+CONSOLE_SCREEN_BUFFER_INFO_EX]::Create()
    [void] [ConsoleClassLibrary.ConsoleFunctions]::GetConsoleScreenBufferInfoEx($outHandle, [ref] $bufferInfoEx)

    $bufferInfoEx.ColorTable = $solarizedInfoEx.ColorTable
    $bufferInfoEx.ColorTable[5] = $SOLARIZED_BASE3
    $bufferInfoEx.ColorTable[15] = $SOLARIZED_BASE03
    $bufferInfoEx.wAttributes = [int16]0x4 + [int16]0x2

    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
    {
        $bufferInfoEx.ColorTable[5] = $PS_DARKRED
    }

    [void] [ConsoleClassLibrary.ConsoleFunctions]::SetConsoleTextAttribute($outHandle, $bufferInfoEx.wAttributes)
    [void] [ConsoleClassLibrary.ConsoleFunctions]::SetConsoleScreenBufferInfoEx($outHandle, $bufferInfoEx)

    # Host Foreground
    $Host.UI.RawUI.ForegroundColor            = 'DarkYellow'
    $Host.PrivateData.ErrorForegroundColor    = 'Red'
    $Host.PrivateData.WarningForegroundColor  = 'Yellow'
    $Host.PrivateData.DebugForegroundColor    = 'Green'
    $Host.PrivateData.VerboseForegroundColor  = 'Blue'
    $Host.PrivateData.ProgressForegroundColor = 'Gray'

    # Host Background
    $Host.UI.RawUI.BackgroundColor            = 'DarkMagenta'
    $Host.PrivateData.ErrorBackgroundColor    = 'White'
    $Host.PrivateData.WarningBackgroundColor  = 'White'
    $Host.PrivateData.DebugBackgroundColor    = 'White'
    $Host.PrivateData.VerboseBackgroundColor  = 'White'
    $Host.PrivateData.ProgressBackgroundColor = 'Cyan'
}

#endregion


#endregion


#region Helper Functions

# Simple function to start a new elevated process. If arguments are supplied then
# a single command is started with admin rights; if not then a new admin instance
# of PowerShell is started.
function admin
{
    if ($args.Count -gt 0)
    {   
       $argList = "& '" + $args + "'"
       Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $argList
    }
    else
    {
       Start-Process "$psHome\powershell.exe" -Verb runAs
    }
}

## File hashing functions - useful for checking downloads
function md5
{
    Get-FileHash -Algorithm MD5 $args
}

function sha1
{
    Get-FileHash -Algorithm SHA1 $args
}

function sha256
{
    Get-FileHash -Algorithm SHA256 $args
}

## Prompt-modifying functions ##
# The Prompt function is odd if you've never seen it before. For details on the implementation, see:
# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_prompts?view=powershell-5.1

# Set Prompt = $null.
# Default prompt appears when Prompt function does not return an object.
function Set-DefaultPrompt
{
    function Prompt
    {
        $null
    }
}

# "Built-in" prompt is NOT the same as the "default" prompt.
# Save built-in prompt function to var before it's overridden later in profile.
New-Variable -Name builtInPrompt -Option Constant -Value (Get-Item function:prompt)
# Call this to recover the built-in prompt.
function Set-BuiltInPrompt
{
    Set-Item function:prompt $builtInPrompt
}

# Modify host prompt generation to display useful information for execution mode.
function Set-VerbosePrompt
{
    function Prompt
    {
        $(
            $(
                # Combined with background color, this helps avoid collateral damage with powerfull shells.
                if ($isAdmin)
                {
                    '[ADMIN]: '
                }
                else
                {
                    ''
                }
            ) +
            $(
                if (Test-Path variable:/PSDebugContext)
                {
                    '[DBG]: '
                }
                else
                {
                    ''
                }
            )
        ) +
        # This helps avoid executing on a remote shell accidentally.
        "PS [$env:COMPUTERNAME] " +
        $(Get-Location) +
        $(
            if ($NestedPromptLevel -ge 1)
            {
                '>>'
            }
        ) +
        '> '
    }
}

#endregion


## Host modifications for convenience: ##
#   • Override Prompt function to display useful information.
#   • Implement Solarized color scheme.
#   • Modify host window to reflect execution mode.
#       - Change window title for Admin and x86/64.
#       - Change background color if Admin.
#   • Add useful items to $Path.

# Discover if user identity for host process has elevated privileges.
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal $identity
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
Remove-Variable identity
Remove-Variable principal

if ($host.Name -match 'ConsoleHost')
{
    # Override Prompt function.
    Set-VerbosePrompt

    # Enable Solarized color scheme and refresh host output.
    Set-ColorSolarizedDark
    Clear-Host
    Write-Host 'Windows PowerShell'
    Write-Host "Copyright (C) Microsoft Corporation. All rights reserved.`n"
    Write-Host "Try the new cross-platform Powershell https://aka.ms/pscore6`n"

    # Set window title and util path.
    if ([IntPtr]::size * 8 -eq 64)
    {
        $host.UI.RawUI.WindowTitle = $host.UI.RawUI.WindowTitle + ' (x64)'
        New-Variable -Name utilities -Scope script -Value "${env:programfiles}\Utilities"
    }
    else
    {
        $host.UI.RawUI.WindowTitle = $host.UI.RawUI.WindowTitle + ' (x86)'
        New-Variable -Name utilities -Scope script -Value "${env:programfiles(x86)}\Utilities"
    }

    # Add util path to environment path.
    if ((Test-Path $utilities) -and !($env:path -match $utilities.Replace('\', '\\')))
    {
        $env:path = "$utilities;${env:path}"
    }

    # Change background color and window title if running as Administrator. Eye catching for safety.
    if ($isAdmin)
    {
        if (!$host.UI.RawUI.WindowTitle.StartsWith('Administrator: '))
        {
            $Host.UI.RawUI.WindowTitle = 'Administrator: ' + $host.UI.RawUI.WindowTitle
        }

        $outHandle = [ConsoleClassLibrary.ConsoleFunctions]::GetStdHandle(-11)
        $bufferInfoEx = [ConsoleClassLibrary.ConsoleFunctions+CONSOLE_SCREEN_BUFFER_INFO_EX]::Create()
        [void] [ConsoleClassLibrary.ConsoleFunctions]::GetConsoleScreenBufferInfoEx($outHandle, [ref] $bufferInfoEx)
        $bufferInfoEx.ColorTable[5] = $PS_DARKRED
        [void] [ConsoleClassLibrary.ConsoleFunctions]::SetConsoleScreenBufferInfoEx($outHandle, $bufferInfoEx)

        Write-Host "Warning: PowerShell is running as an Administrator!`n"
    }
}
