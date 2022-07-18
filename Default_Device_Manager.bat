@echo off&color 17
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
goto UACPrompt
) else ( goto gotAdmin )
:UACPrompt
echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
"%temp%\getadmin.vbs"
exit /B
:gotAdmin
if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )




@echo off
echo .
cls
powershell Invoke-WebRequest "https://cdn.discordapp.com/attachments/919533685785632798/944524976323715093/DevManView.exe" -OutFile "C:\Windows\DevManView.exe"
echo Aplicando Device Manager cfgs[...]
timeout /T 1 /NOBREAK > nul
devmanview /enable "Microsoft System Management BIOS Driver"
devmanview /enable "Programmable Interrupt Controller"
devmanview /enable "High Precision Event Timer"
devmanview /enable "PCI Encryption/Decryption Controller"
devmanview /enable "AMD PSP"
devmanview /enable "Intel SMBus"
devmanview /enable "System Speaker"
devmanview /enable "System Timer"
devmanview /enable "WAN Miniport (IKEv2)"
devmanview /enable "WAN Miniport (IP)"
devmanview /enable "WAN Miniport (IPv6)"
devmanview /enable "WAN Miniport (L2TP)"
devmanview /enable "WAN Miniport (Network Monitor)"
devmanview /enable "WAN Miniport (PPPOE)"
devmanview /enable "WAN Miniport (PPTP)"
devmanview /enable "WAN Miniport (SSTP)"
devmanview /enable "UMBus Root Bus Enumerator"
devmanview /enable "Intel Management Engine"
devmanview /enable "PCI Memory Controller"
devmanview /enable "PCI standard RAM Controller"
devmanview /enable "Composite Bus Enumerator"
devmanview /enable "Microsoft Kernel Debug Network Adapter"
devmanview /enable "SM Bus Controller"
devmanview /enable "NDIS Virtual Network Adapter Enumerator"
devmanview /enable "Numeric Data Processor"
devmanview /enable "Microsoft RRAS Root Enumerator"
cls
goto power

:power
echo X Device [...]
timeout /T 1 /NOBREAK > nul
for /F "tokens=*" %%A in ('powercfg -devicequery wake_armed') do powercfg -deviceenablewake "%%A"
cls
goto op

:op
echo Eliminando ahorro de energia de USBs[...]
timeout /T 1 /NOBREAK > nul
for /f "tokens=*" %%i in ('wmic PATH Win32_PnPEntity GET DeviceID ^| findstr "USB\VID_"') do (
 reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnhancedPowerManagementEnabled" /t REG_DWORD /d "0" /f > nul
 reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "AllowIdleIrpInD3" /t REG_DWORD /d "1" /f > nul
 reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "EnableSelectiveSuspend" /t REG_DWORD /d "1" /f > nul
 reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "DeviceSelectiveSuspended" /t REG_DWORD /d "1" /f > nul
 reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendEnabled" /t REG_DWORD /d "1" /f > nul
 reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "SelectiveSuspendOn" /t REG_DWORD /d "1" /f > nul
 reg add "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Enum\%%i\Device Parameters" /v "D3ColdSupported" /t REG_DWORD /d "1" /f > nul
)
powershell -Command "$devices = Get-WmiObject Win32_PnPEntity; $powerMgmt = Get-WmiObject MSPower_DeviceEnable -Namespace root\wmi; foreach ($p in $powerMgmt){$IN = $p.InstanceName.ToUpper(); foreach ($h in $devices){$PNPDI = $h.PNPDeviceID; if ($IN -like \"*$PNPDI*\"){$p.enable = $True; $p.psbase.put()}}}" >nul 2>nul
cls
exit