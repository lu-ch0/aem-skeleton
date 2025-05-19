@echo off
setlocal enabledelayedexpansion

REM Rutas de los JARs y logs
set "SCRIPT_DIR=%~dp0"
set "AUTHOR_JAR=%SCRIPT_DIR%author\aem-author-p4502.jar"
set "PUBLISH_JAR=%SCRIPT_DIR%publish\aem-publish-p4503.jar"

set "LOGS_DIR=%SCRIPT_DIR%logs"
if not exist "%LOGS_DIR%" mkdir "%LOGS_DIR%"

set "AUTHOR_LOG=%LOGS_DIR%\author.log"
set "PUBLISH_LOG=%LOGS_DIR%\publish.log"
set "AUTHOR_PID=%LOGS_DIR%\author.pid"
set "PUBLISH_PID=%LOGS_DIR%\publish.pid"

REM Comandos java para ejecutar
set "AUTHOR_CMD=java -jar \"%AUTHOR_JAR%\" -r author,stage -fork -forkargs -- -Xdebug -Xrunjdwp:transport=dt_socket,address=30303,suspend=n,server=y -Dfile.encoding=UTF8"
set "PUBLISH_CMD=java -jar \"%PUBLISH_JAR%\""

REM Funciones simuladas con etiquetas y llamadas CALL

:START_AUTHOR
if not exist "%AUTHOR_JAR%" (
    echo ERROR: Author JAR not found at "%AUTHOR_JAR%"
    goto :MENU
)
start /b cmd /c "%AUTHOR_CMD% > \"%AUTHOR_LOG%\" 2>&1"
echo %ERRORLEVEL% > "%AUTHOR_PID%"
echo Author started.
goto :MENU

:START_PUBLISH
if not exist "%PUBLISH_JAR%" (
    echo ERROR: Publish JAR not found at "%PUBLISH_JAR%"
    goto :MENU
)
start /b cmd /c "%PUBLISH_CMD% > \"%PUBLISH_LOG%\" 2>&1"
echo %ERRORLEVEL% > "%PUBLISH_PID%"
echo Publish started.
goto :MENU

:STOP_AUTHOR
if exist "%AUTHOR_PID%" (
    for /f "usebackq" %%a in ("%AUTHOR_PID%") do set PID=%%a
    taskkill /PID %PID% /F >nul 2>&1 && (
        echo Author stopped.
        del "%AUTHOR_PID%"
    ) || echo Could not stop Author.
) else (
    echo Author is not running.
)
goto :MENU

:STOP_PUBLISH
if exist "%PUBLISH_PID%" (
    for /f "usebackq" %%a in ("%PUBLISH_PID%") do set PID=%%a
    taskkill /PID %PID% /F >nul 2>&1 && (
        echo Publish stopped.
        del "%PUBLISH_PID%"
    ) || echo Could not stop Publish.
) else (
    echo Publish is not running.
)
goto :MENU

:STATUS_AUTHOR
if exist "%AUTHOR_PID%" (
    for /f "usebackq" %%a in ("%AUTHOR_PID%") do set PID=%%a
    tasklist /FI "PID eq %PID%" | findstr %PID% >nul && (
        echo Author is running (PID %PID%)
    ) || (
        echo Author PID file exists but process %PID% is not running.
    )
) else (
    echo Author is not running.
)
goto :STATUS_END

:STATUS_PUBLISH
if exist "%PUBLISH_PID%" (
    for /f "usebackq" %%a in ("%PUBLISH_PID%") do set PID=%%a
    tasklist /FI "PID eq %PID%" | findstr %PID% >nul && (
        echo Publish is running (PID %PID%)
    ) || (
        echo Publish PID file exists but process %PID% is not running.
    )
) else (
    echo Publish is not running.
)
goto :STATUS_END

:STATUS_END
pause
goto :MENU

:HELP
echo Usage:
echo 1. Start Author
echo 2. Start Publish
echo 3. Start Both
echo 4. Stop Author
echo 5. Stop Publish
echo 6. Stop Both
echo 7. Status Author
echo 8. Status Publish
echo 9. Status Both
echo 0. Exit
pause
goto :MENU

:MENU
cls
echo ===========================
echo AEM Instance Control Menu
echo ===========================
echo 1. Start Author
echo 2. Start Publish
echo 3. Start Both
echo 4. Stop Author
echo 5. Stop Publish
echo 6. Stop Both
echo 7. Status Author
echo 8. Status Publish
echo 9. Status Both
echo 0. Exit
set /p choice=Choose an option: 

if "%choice%"=="1" goto :START_AUTHOR
if "%choice%"=="2" goto :START_PUBLISH
if "%choice%"=="3" (
    call :START_AUTHOR
    call :START_PUBLISH
    goto :MENU
)
if "%choice%"=="4" goto :STOP_AUTHOR
if "%choice%"=="5" goto :STOP_PUBLISH
if "%choice%"=="6" (
    call :STOP_AUTHOR
    call :STOP_PUBLISH
    goto :MENU
)
if "%choice%"=="7" (
    call :STATUS_AUTHOR
)
if "%choice%"=="8" (
    call :STATUS_PUBLISH
)
if "%choice%"=="9" (
    call :STATUS_AUTHOR
    call :STATUS_PUBLISH
    goto :MENU
)
if "%choice%"=="0" exit /b

echo Invalid option.
pause
goto :MENU
