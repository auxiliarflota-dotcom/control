@echo off
setlocal enabledelayedexpansion

:: Version: 1.1.2

:: Verificar si Git esta inicializado
if not exist ".git" (
    echo [ERROR] No se detecto un repositorio Git en esta carpeta.
    echo.
    pause
    exit /b
)

:: Extraer version actual
set "current_version=0.0.0"
for /f "tokens=3" %%a in ('findstr /L /C:":: Version:" "%~f0"') do set "current_version=%%a"

echo === Repositorio: analistaFlota ===
echo Version actual: %current_version%
echo.

set /p "new_version=Introduce la nueva version (ej: 1.1.3) o Enter para mantener: "
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
echo === Sincronizando con GitHub (Pull) ===
git pull --rebase origin main

echo.
echo === Subiendo a GitHub (Push) ===
git push origin main
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [ERROR] No se pudieron subir los cambios. 
    echo Revisa tu conexion o si hay conflictos pendientes.
    pause
    exit /b
)

:: Actualizar version en el archivo al final
if not "%new_version%"=="%current_version%" (
    echo.
    echo Actualizando version en el script...
    set "MYPATH=%~f0"
    powershell -Command "$p = $env:MYPATH; $c = (Get-Content $p); $c = $c -replace ':: Version: %current_version%', ':: Version: %new_version%'; Set-Content -Path $p -Value $c -Encoding ASCII"
)

echo.
echo === Hecho! Version: %new_version% ===
pause
