@echo off

rem This file is UTF-8 encoded, so we need to update the current code page while executing it
for /f "tokens=2 delims=:." %%a in ('"%SystemRoot%\System32\chcp.com"') do (
    set _OLD_CODEPAGE=%%a
)
if defined _OLD_CODEPAGE (
    "%SystemRoot%\System32\chcp.com" 65001 > nul
)

set VIRTUAL_ENV=__VENV_DIR__

if not defined PROMPT set PROMPT=$P$G

if defined _OLD_VIRTUAL_PROMPT set PROMPT=%_OLD_VIRTUAL_PROMPT%
if defined _OLD_VIRTUAL_PYTHONHOME set PYTHONHOME=%_OLD_VIRTUAL_PYTHONHOME%

set _OLD_VIRTUAL_PROMPT=%PROMPT%
set PROMPT=__VENV_PROMPT__%PROMPT%

if defined PYTHONHOME set _OLD_VIRTUAL_PYTHONHOME=%PYTHONHOME%
set PYTHONHOME=

if defined _OLD_VIRTUAL_PATH set PATH=%_OLD_VIRTUAL_PATH%
if not defined _OLD_VIRTUAL_PATH set _OLD_VIRTUAL_PATH=%PATH%
set PATH=%VIRTUAL_ENV%\bin;%PATH%

if defined _OLD_DEPOT_PATH set JULIA_DEPOT_PATH=%_OLD_DEPOT_PATH%
if not defined _OLD_DEPOT_PATH set _OLD_DEPOT_PATH=%JULIA_DEPOT_PATH%
set JULIA_DEPOT_PATH=__DEPOT_DIR__

if defined _OLD_LOAD_PATH set JULIA_LOAD_PATH=%_OLD_LOAD_PATH%
if not defined _OLD_LOAD_PATH set _OLD_LOAD_PATH=%JULIA_LOAD_PATH%
set JULIA_LOAD_PATH=":"

:END
if defined _OLD_CODEPAGE (
    "%SystemRoot%\System32\chcp.com" %_OLD_CODEPAGE% > nul
    set _OLD_CODEPAGE=
)
