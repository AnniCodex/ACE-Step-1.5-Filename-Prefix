@echo off
REM ACE-Step 1.5 - Filename Prefix + Models in JSON
REM Applies every patches\*.patch to the ACE-Step-1.5 folder.
REM Put this folder INSIDE the ACE-Step-1.5 folder (next to start_gradio_ui.bat)
REM and double-click this file. Already-applied patches are skipped.
setlocal
set "HERE=%~dp0"

REM --- find the ACE-Step-1.5 root (parent folder, or this folder) ---
set "ROOT="
if exist "%HERE%..\acestep\ui\gradio" set "ROOT=%HERE%.."
if exist "%HERE%acestep\ui\gradio" set "ROOT=%HERE%."
if not defined ROOT (
    echo ERROR: ACE-Step-1.5 folder not found.
    echo Put this folder inside the ACE-Step-1.5 folder, next to start_gradio_ui.bat.
    goto :end
)
cd /d "%ROOT%"

REM --- git: bundled PortableGit first, then git on PATH ---
set "GITEXE=git"
if exist "%CD%\PortableGit\bin\git.exe" set "GITEXE=%CD%\PortableGit\bin\git.exe"
set "GIT="%GITEXE%" -c safe.directory=%CD:\=/%"
%GIT% --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: git not found. Install Git for Windows or use the portable package with PortableGit.
    goto :end
)

for %%P in ("%HERE%patches\*.patch") do (
    echo.
    echo === %%~nxP
    %GIT% apply --check -R "%%~fP" >nul 2>&1
    if not errorlevel 1 (
        echo     already applied, skipped.
    ) else (
        %GIT% apply --check "%%~fP" >nul 2>&1
        if not errorlevel 1 (
            %GIT% apply -v "%%~fP"
            echo     APPLIED.
        ) else (
            echo     Does not apply cleanly, trying --3way ...
            %GIT% apply --3way -v "%%~fP"
            if errorlevel 1 (
                echo     ERROR: upstream code changed too much. See README.md, section "Troubleshooting".
            )
        )
    )
)

:end
echo.
pause
