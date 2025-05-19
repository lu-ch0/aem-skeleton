@echo off
setlocal enabledelayedexpansion

REM Si no hay argumento, preguntar la ruta
if "%~1"=="" (
  set /p JAR_PATH=Please enter the full path to the downloaded AEM JAR: 
) else (
  set "JAR_PATH=%~1"
)

REM Comprobar si el archivo existe
if not exist "%JAR_PATH%" (
  echo ERROR: File not found at "%JAR_PATH%"
  pause
  exit /b 1
)

REM Crear carpetas si no existen
if not exist author mkdir author
if not exist publish mkdir publish
if not exist logs mkdir logs
if not exist dispatcher mkdir dispatcher

REM Copiar JARs
copy /Y "%JAR_PATH%" "author\aem-author-p4502.jar" >nul
copy /Y "%JAR_PATH%" "publish\aem-publish-p4503.jar" >nul

REM Eliminar archivo original
del /Q "%JAR_PATH%"

echo Setup completed successfully.
echo JAR copied to:
echo   ^> .\author\aem-author-p4502.jar
echo   ^> .\publish\aem-publish-p4503.jar
echo Original file deleted.

REM Eliminar carpeta .git si existe
if exist .git (
  echo Removing Git information to make this instance standalone...
  rmdir /S /Q .git
)

pause
endlocal
