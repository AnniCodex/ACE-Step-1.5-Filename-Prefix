@echo off
REM ACE-Step 1.5 - Filename Prefix + Models in JSON
REM Removes the patches (restores the original files). Run it BEFORE updating ACE-Step.
setlocal
set "HERE=%~dp0"

set "ROOT="
if exist "%HERE%..\acestep\ui\gradio" set "ROOT=%HERE%.."
if exist "%HERE%acestep\ui\gradio" set "ROOT=%HERE%."
if not defined ROOT (
    echo ERROR: ACE-Step-1.5 folder not found.
    echo Put this folder inside the ACE-Step-1.5 folder, next to start_gradio_ui.bat.
    goto :end
)
cd /d "%ROOT%"

set "GITEXE=git"
if exist "%CD%\PortableGit\bin\git.exe" set "GITEXE=%CD%\PortableGit\bin\git.exe"
set "GIT="%GITEXE%" -c safe.directory=%CD:\=/%"
%GIT% --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: git not found.
    goto :end
)

for %%P in ("%HERE%patches\*.patch") do (
    echo.
    echo === %%~nxP
    %GIT% apply --check -R "%%~fP" >nul 2>&1
    if errorlevel 1 (
        echo     not applied ^(or files edited by hand^), skipped.
    ) else (
        %GIT% apply -R -v "%%~fP"
        echo     REMOVED.
    )
)

:end
echo.
pause
