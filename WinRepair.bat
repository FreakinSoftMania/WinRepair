@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:-------------------------------------- 
title WinRepair v1.0.0
echo WinRepair v1.0.0 by FreakinSoftMania
echo Repair your PC efficient and automatically!
set /p scanandrepair=Would you like to scan and repair your computer [Y/N]? 
if /I %scanandrepair%==Y goto scanandrepair
if /I %scanandrepair%==N goto exit
:scanandrepair
echo Starting scan and repair...
sfc /scannow
echo Starting corruption scan...
DISM /Online /Cleanup-Image /CheckHealth
echo Starting Windows image corruption scan...
DISM /Online /Cleanup-Image /ScanHealth
echo Replacing Windows image...
DISM /Online /Cleanup-Image /RestoreHealth /Source:repairSource\install.wim
echo Repair done!
set /p staratgithub=Would you like to go to the GitHub project page and give the project a star [Y/N]?
if /I %staratgithub%==Y goto repairexit
if /I %staratgithub%==N goto repairexit1
:exit
echo See you soon!
timeout 3 /nobreak >nul
exit
:repairexit
open https://github.com/FreakinSoftMania/WinRepair
exit
:repairexit1
exit