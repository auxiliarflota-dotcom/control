@echo off
setlocal
set REPO_URL=https://github.com/auxiliarflota-dotcom/control.git
set USER_NAME=temporalMegalogistik
set USER_EMAIL=temporalmegalogistik@gmail.com

echo === Verificando instalacion de Git ===
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Git no esta instalado en tu sistema.
    echo Por favor, descargalo e instalalo desde: https://git-scm.com/download/win
    echo Despues de instalarlo, reinicia esta ventana y vuelve a intentarlo.
    echo.
    pause
    exit /b
)

echo === Configurando credenciales de Git ===
git config --global user.name "%USER_NAME%"
git config --global user.email "%USER_EMAIL%"

echo.
echo === Iniciando vinculacion con GitHub ===
if not exist ".git" (
    git init
)

echo.
echo === Configurando repositorio remoto ===
git remote remove origin >nul 2>nul
git remote add origin %REPO_URL%

echo.
echo === Configurando rama principal ===
git branch -M main

echo.
echo === Sincronizando estructura organizada ===
echo Se subira el nuevo orden (carpetas css/ y views/) a GitHub.
echo.
git add .
git commit -m "Organizacion de proyecto: Carpetas css y views"
git push -u origin main --force

echo.
echo === ¡Listo! Ahora tu GitHub tiene la version organizada ===
echo Ya puedes usar subir.bat para tus cambios diarios.
pause
