@echo off
setlocal enabledelayedexpansion

:: Version: 1.0.0

:: Verificar si Git esta inicializado
if not exist ".git" (
    echo [ERROR] No se detecto un repositorio Git en esta carpeta.
    echo.
    pause
    exit /b
)

:: Extraer version actual
set "current_version=0.0.0"
for /f "tokens=3" %%a in ('findstr /C:":: Version:" "%~f0"') do set "current_version=%%a"

echo === Repositorio: analistaFlota ===
echo Version actual: %current_version%
echo.

set /p "new_version=Introduce la nueva version (ej: 1.0.1) o Enter para mantener: "
if "%new_version%"=="" set "new_version=%current_version%"

echo.
set /p "msg=Introduce el mensaje del commit: "
if "%msg%"=="" set "msg=Actualizacion automatica"

echo.
echo === Agregando cambios ===
git add .

echo.
echo === Creando commit ===
git commit -m "[v%new_version%] %msg%"

echo.
echo === Subiendo a GitHub ===
git push

:: Actualizar version en el archivo al final para evitar errores de lectura
if not "%new_version%"=="%current_version%" (
    echo.
    echo Actualizando version en el script...
    set "SCRIPT_PATH=%~f0"
    powershell -Command "$p = $env:SCRIPT_PATH; (Get-Content -Path $p) -replace ':: Version: %current_version%', ':: Version: %new_version%' | Set-Content -Path $p -Encoding ASCII"
)

echo.
echo === Hecho! Version: %new_version% ===
pause
