@echo off
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
color 17
cls

:start
echo elige
echo.
echo 1 = Eliminar archivos temp
echo 2 = Eliminar archivos log
echo 3 = Eliminar archivos prefetch
echo 4 = Eliminar archivos Recycle bin
echo 5 = Eliminar archivos de Windows Update Cache
echo 6 = Eliminar archivos Internet temp
echo 7 = Flush DNS
echo.
set /p clean=:

if "%clean%"=="0" goto temp
if "%clean%"=="1" goto temp
if "%clean%"=="2" goto log
if "%clean%"=="3" goto prefetch
if "%clean%"=="4" goto Recycle
if "%clean%"=="5" goto Update
if "%clean%"=="6" goto Internet
if "%clean%"=="7" goto Flush

cls
color 4
echo entrada inválida, reintentando...
timeout /T 3 /NOBREAK > nul
cls
goto start

:temp
cls
RD /S /Q %temp%
MKDIR %temp%
takeown /f "%temp%" /r /d y
takeown /f "C:\Windows\Temp" /r /d y
RD /S /Q C:\Windows\Temp
MKDIR C:\Windows\Temp
takeown /f "C:\Windows\Temp" /r /d y
takeown /f %temp% /r /d y
cls
echo Archivos temp eliminados!
timeout /T 2 /NOBREAK > nul
cls
goto start

:log
cls
cd/
@echo
del *.log /a /s /q /f
cls
echo Archivos log eliminados!
timeout /T 2 /NOBREAK > nul
cls
goto start

:prefetch
cls
del C:\Windows\prefetch\*.*/s/q
cls
echo Archivos prefetch eliminados!
timeout /T 2 /NOBREAK > nul
cls
goto start

:Recycle
cls
rd /s /q %SYSTEMDRIVE%\$Recycle.bin
cls
echo Archivos Recycle bin eliminados!
timeout /T 2 /NOBREAK > nul
cls
goto start

:Update
cls
net stop wuauserv
net stop UsoSvc
rd /s /q C:\Windows\SoftwareDistribution
md C:\Windows\SoftwareDistribution
cls
echo Archivos Deleted Windows Update Cache eliminados!
timeout /T 2 /NOBREAK > nul
cls
goto start

:Internet
cls
rd /s /q "C:\Users\%username%\AppData\Local\Microsoft\Windows\INetCache\IE"
md C:\Users\%username%\AppData\Local\Microsoft\Windows\INetCache\IE
cls
echo Archivos Internet temp eliminados!
timeout /T 2 /NOBREAK > nul
cls
goto start

:Flush
cls
ipconfig /flushdns
cls
echo DNS flush!
timeout /T 2 /NOBREAK > nul
cls
goto start




