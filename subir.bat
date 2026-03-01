@echo off
setlocal

:: Verificar si Git está inicializado
if not exist ".git" (
    echo [ERROR] No se detecto un repositorio Git en esta carpeta.
    echo Por favor, sigue las instrucciones del README.md para vincularlo a GitHub.
    echo.
    pause
    exit /b
)

:: Mostrar el repositorio actual
echo === Repositorio Remoto Actual ===
git remote -v
echo.

set /p msg="Introduce el mensaje del commit: "
if "%msg%"=="" set msg="Actualización automática"

echo.
echo === Agregando cambios ===
git add .

echo.
echo === Creando commit ===
git commit -m "%msg%"

echo.
echo === Subiendo a GitHub ===
git push

echo.
echo === ¡Hecho! ===
pause
