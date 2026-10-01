@echo off
setlocal enabledelayedexpansion
title Krunker Mod Downloader
color 0A

echo.
echo ========================================
echo    KRUNKER MOD DOWNLOADER
echo ========================================
echo.

set "mods_db=https://raw.githubusercontent.com/stabbedintheheart/krunker-mods/main/mods.json"

:menu
cls
echo ========================================
echo    KRUNKER MOD DOWNLOADER
echo ========================================
echo.
echo What do you want to do?
echo.
echo 1. Download a mod by name
echo 2. Search for a mod
echo 3. List all available mods
echo 4. Direct URL download
echo 5. Exit
echo.
set /p choice="Enter your choice (1-5): "

if "%choice%"=="1" goto download_by_name
if "%choice%"=="2" goto search_mod
if "%choice%"=="3" goto list_mods
if "%choice%"=="4" goto direct_url
if "%choice%"=="5" goto exit_app
echo Invalid choice. Please try again.
pause
goto menu

:download_by_name
cls
set /p mod_name="Enter mod name (or part of it): "
echo Searching for "%mod_name%"...
echo.

REM Simulated mod database (you can replace with actual API calls)
call :find_mod "%mod_name%"
pause
goto menu

:search_mod
cls
set /p search_term="Enter search term: "
echo Searching for mods matching "%search_term%"...
echo.
call :find_mod "%search_term%"
pause
goto menu

:list_mods
cls
echo Available Krunker Mods:
echo.
echo Note: This is a sample list. Add your own mods to mods.json
echo.
echo 1. Crosshair Mod Pack
echo    Link: https://example.com/crosshair-pack.zip
echo.
echo 2. Visual Enhancement
echo    Link: https://example.com/visual-enhancement.zip
echo.
echo 3. HUD Customizer
echo    Link: https://example.com/hud-custom.zip
echo.
echo 4. Sound Pack
echo    Link: https://example.com/sound-pack.zip
echo.
echo To add more mods, edit the batch file or create a mods.json file.
echo.
pause
goto menu

:direct_url
cls
set /p download_url="Enter full download URL: "
if "!download_url!"=="" (
    echo No URL provided.
    pause
    goto menu
)
call :download_file "!download_url!"
pause
goto menu

:find_mod
setlocal enabledelayedexpansion
set "search=%~1"

REM Built-in mod database
if /i "!search!"=="crosshair" (
    echo Found: Crosshair Mod Pack
    echo Link: https://github.com/KrunkerMods/crosshair-pack/releases/download/latest/crosshair.zip
    echo.
    set /p dl="Download? (y/n): "
    if /i "!dl!"=="y" (
        call :download_file "https://github.com/KrunkerMods/crosshair-pack/releases/download/latest/crosshair.zip"
    )
) else if /i "!search!"=="hud" (
    echo Found: HUD Customizer
    echo Link: https://github.com/KrunkerMods/hud-custom/releases/download/latest/hud.zip
    echo.
    set /p dl="Download? (y/n): "
    if /i "!dl!"=="y" (
        call :download_file "https://github.com/KrunkerMods/hud-custom/releases/download/latest/hud.zip"
    )
) else if /i "!search!"=="visual" (
    echo Found: Visual Enhancement
    echo Link: https://github.com/KrunkerMods/visual-enhance/releases/download/latest/visual.zip
    echo.
    set /p dl="Download? (y/n): "
    if /i "!dl!"=="y" (
        call :download_file "https://github.com/KrunkerMods/visual-enhance/releases/download/latest/visual.zip"
    )
) else (
    echo No mod found matching "!search!"
    echo.
    echo Popular mods: crosshair, hud, visual
    echo Or use option 4 to download from a direct URL.
)
endlocal
exit /b

:download_file
setlocal enabledelayedexpansion
set "url=%~1"
set "filename=!url:~-30!"

cls
echo.
echo Downloading...
echo URL: !url!
echo.

REM Create mods folder if it doesn't exist
if not exist "mods" mkdir mods

REM Use PowerShell to download (works on all modern Windows)
powershell -Command "& { try { (New-Object System.Net.ServicePointManager).SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor [System.Net.SecurityProtocolType]::Tls12; $ProgressPreference = 'Continue'; Invoke-WebRequest -Uri '!url!' -OutFile 'mods\downloaded_mod.zip' -UseBasicParsing; Write-Host 'Download complete!' -ForegroundColor Green; } catch { Write-Host 'Download failed: ' $_.Exception.Message -ForegroundColor Red; } }"

if exist "mods\downloaded_mod.zip" (
    echo.
    echo Success! File saved to: mods\downloaded_mod.zip
    echo.
    set /p extract="Extract ZIP? (y/n): "
    if /i "!extract!"=="y" (
        powershell -Command "& { Expand-Archive -Path 'mods\downloaded_mod.zip' -DestinationPath 'mods\' -Force; Write-Host 'Extraction complete!' -ForegroundColor Green; }"
    )
) else (
    echo.
    echo Download failed. Check your internet connection or URL.
)
endlocal
exit /b

:exit_app
cls
echo Thank you for using Krunker Mod Downloader!
echo Goodbye!
timeout /t 2
exit /b
