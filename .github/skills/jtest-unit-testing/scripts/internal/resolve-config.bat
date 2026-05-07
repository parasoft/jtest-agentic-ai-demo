@echo off
rem =============================================================================
rem resolve-config.bat  —  Load, parse, and validate all UTA Test Creation settings
rem
rem Called by the skill runner or other scripts before analysis begins.
rem After this script completes, all resolved variables are available as
rem environment variables in the calling shell (because setlocal is NOT used
rem here — the caller owns the scope).
rem
rem Usage:
rem   call "scripts\internal\resolve-config.bat" "<skill_dir>"
rem
rem Arguments:
rem   %1 — SKILL_DIR: absolute path to the skill root directory (contains SKILL.md)
rem
rem On validation failure the script prints an ERROR message and
rem exits with code 1.
rem
rem Environment variables set on success:
rem   JTEST_HOME, ANALYZED_PROJECT_PATH, JTEST_UTA_CONFIGURATION, JTEST_COMMIT_FIXES,
rem   JTEST_STATIC_FILTER_RULE, JTEST_SETTINGS, JTEST_STATIC_BASE_REPORT, JTEST_STATIC_BASE_COVERAGE,
rem   JTEST_UTA_SCRIPT_DIR, JTEST_UTA_RESOURCE, JTEST_FIX_ATTEMPTS, JTEST_UTA_NO_OF_MAX_FIXES
rem   (set to empty string when not applicable)
rem =============================================================================

rem We intentionally do NOT use setlocal so variables propagate to the caller.
rem However we need delayed expansion for the config-file parser.
set "_RC_SKILL_DIR=%~1"
if "%_RC_SKILL_DIR%"=="" (
    echo ERROR: SKILL_DIR argument is required.
    exit /b 1
)

rem ===== Step 0: Load optional config file ====================================

if not defined JTEST_SKILLS_CONFIG goto :skip_config
if "%JTEST_SKILLS_CONFIG%"=="" goto :skip_config
if not exist "%JTEST_SKILLS_CONFIG%" (
    echo ERROR: JTEST_SKILLS_CONFIG points to a file that does not exist: %JTEST_SKILLS_CONFIG%. Verify the path and retry.
    exit /b 1
)

for /f "usebackq tokens=1,* delims==" %%A in ("%JTEST_SKILLS_CONFIG%") do (
    setlocal enabledelayedexpansion
    set "_cfgkey=%%A"
    set "_cfgval=%%B"
    rem Skip comments (lines starting with #)
    if not "!_cfgkey:~0,1!"=="#" (
        rem Trim
        for %%K in (!_cfgkey!) do set "_cfgkey=%%K"
        rem Only set if not already defined
        if "!_cfgkey!"=="JTEST_HOME" if not defined JTEST_HOME endlocal & set "JTEST_HOME=%%B" & setlocal enabledelayedexpansion
        if "!_cfgkey!"=="ANALYZED_PROJECT_PATH" if not defined ANALYZED_PROJECT_PATH endlocal & set "ANALYZED_PROJECT_PATH=%%B" & setlocal enabledelayedexpansion
        if "!_cfgkey!"=="JTEST_UTA_CONFIGURATION" if not defined JTEST_UTA_CONFIGURATION endlocal & set "JTEST_UTA_CONFIGURATION=%%B" & setlocal enabledelayedexpansion
        if "!_cfgkey!"=="JTEST_COMMIT_FIXES" if not defined JTEST_COMMIT_FIXES endlocal & set "JTEST_COMMIT_FIXES=%%B" & setlocal enabledelayedexpansion
        if "!_cfgkey!"=="JTEST_STATIC_FILTER_RULE" if not defined JTEST_STATIC_FILTER_RULE endlocal & set "JTEST_STATIC_FILTER_RULE=%%B" & setlocal enabledelayedexpansion
        if "!_cfgkey!"=="JTEST_SETTINGS" if not defined JTEST_SETTINGS endlocal & set "JTEST_SETTINGS=%%B" & setlocal enabledelayedexpansion
        if "!_cfgkey!"=="JTEST_STATIC_BASE_REPORT" if not defined JTEST_STATIC_BASE_REPORT endlocal & set "JTEST_STATIC_BASE_REPORT=%%B" & setlocal enabledelayedexpansion
        if "!_cfgkey!"=="JTEST_STATIC_BASE_COVERAGE" if not defined JTEST_STATIC_BASE_COVERAGE endlocal & set "JTEST_STATIC_BASE_COVERAGE=%%B" & setlocal enabledelayedexpansion
        if "!_cfgkey!"=="JTEST_UTA_SCRIPT_DIR" if not defined JTEST_UTA_SCRIPT_DIR endlocal & set "JTEST_UTA_SCRIPT_DIR=%%B" & setlocal enabledelayedexpansion
        if "!_cfgkey!"=="JTEST_RESOURCE" if not defined JTEST_RESOURCE endlocal & set "JTEST_RESOURCE=%%B" & setlocal enabledelayedexpansion
        if "!_cfgkey!"=="JTEST_UTA_RESOURCE" if not defined JTEST_UTA_RESOURCE endlocal & set "JTEST_UTA_RESOURCE=%%B" & setlocal enabledelayedexpansion
        if "!_cfgkey!"=="JTEST_FIX_ATTEMPTS" if not defined JTEST_FIX_ATTEMPTS endlocal & set "JTEST_FIX_ATTEMPTS=%%B" & setlocal enabledelayedexpansion
        if "!_cfgkey!"=="JTEST_UTA_NO_OF_MAX_FIXES" if not defined JTEST_UTA_NO_OF_MAX_FIXES endlocal & set "JTEST_UTA_NO_OF_MAX_FIXES=%%B" & setlocal enabledelayedexpansion
    )
    endlocal
)

:skip_config


rem ===== Step 1: Resolve required & optional settings =========================

rem ---- JTEST_HOME ------------------------------------------------------------
if defined JTEST_HOME if not "%JTEST_HOME%"=="" goto :jtest_home_ok
where jtestcli.exe >nul 2>&1
if %ERRORLEVEL% equ 0 (
    for /f "delims=" %%P in ('where jtestcli.exe') do set "JTEST_HOME=%%~dpP"
    rem Strip trailing backslash
    if "%JTEST_HOME:~-1%"=="\" set "JTEST_HOME=%JTEST_HOME:~0,-1%"
    goto :jtest_home_ok
)
echo ERROR: JTEST_HOME is not set and jtestcli was not found on PATH. Set the JTEST_HOME environment variable and retry.
exit /b 1
:jtest_home_ok

rem ---- ANALYZED_PROJECT_PATH ----------------------------------------------------------
if not defined ANALYZED_PROJECT_PATH (
    echo ERROR: ANALYZED_PROJECT_PATH is not set or does not point to an existing directory. Set the ANALYZED_PROJECT_PATH environment variable and retry.
    exit /b 1
)
if "%ANALYZED_PROJECT_PATH%"=="" (
    echo ERROR: ANALYZED_PROJECT_PATH is not set or does not point to an existing directory. Set the ANALYZED_PROJECT_PATH environment variable and retry.
    exit /b 1
)
if not exist "%ANALYZED_PROJECT_PATH%\" (
    echo ERROR: ANALYZED_PROJECT_PATH is not set or does not point to an existing directory. Set the ANALYZED_PROJECT_PATH environment variable and retry.
    exit /b 1
)

rem ---- JTEST_UTA_CONFIGURATION ----------------------------------------------
if not defined JTEST_UTA_CONFIGURATION set "JTEST_UTA_CONFIGURATION=builtin://Create Unit Tests"
if "%JTEST_UTA_CONFIGURATION%"=="" set "JTEST_UTA_CONFIGURATION=builtin://Create Unit Tests"

rem ---- JTEST_COMMIT_FIXES ----------------------------------------------------
if not defined JTEST_COMMIT_FIXES set "JTEST_COMMIT_FIXES=false"
if "%JTEST_COMMIT_FIXES%"=="" set "JTEST_COMMIT_FIXES=false"

rem ---- JTEST_STATIC_FILTER_RULE (optional) ------------------------------------------
if not defined JTEST_STATIC_FILTER_RULE set "JTEST_STATIC_FILTER_RULE="

rem ---- JTEST_SETTINGS --------------------------------------------------------
if defined JTEST_SETTINGS (
    if not "%JTEST_SETTINGS%"=="" (
        if not exist "%JTEST_SETTINGS%" (
            echo ERROR: JTEST_SETTINGS points to a file that does not exist: %JTEST_SETTINGS%. Verify the path and retry.
            exit /b 1
        )
    )
)
if not defined JTEST_SETTINGS set "JTEST_SETTINGS="

rem ---- JTEST_STATIC_BASE_REPORT -----------------------------------------------------
if defined JTEST_STATIC_BASE_REPORT (
    if not "%JTEST_STATIC_BASE_REPORT%"=="" (
        if not exist "%JTEST_STATIC_BASE_REPORT%" (
            echo ERROR: JTEST_STATIC_BASE_REPORT points to a file that does not exist: %JTEST_STATIC_BASE_REPORT%. Verify the path and retry.
            exit /b 1
        )
    )
)
if not defined JTEST_STATIC_BASE_REPORT set "JTEST_STATIC_BASE_REPORT="

rem ---- JTEST_STATIC_BASE_COVERAGE ---------------------------------------------------
if defined JTEST_STATIC_BASE_COVERAGE (
    if not "%JTEST_STATIC_BASE_COVERAGE%"=="" (
        if not exist "%JTEST_STATIC_BASE_COVERAGE%" (
            echo ERROR: JTEST_STATIC_BASE_COVERAGE points to a file that does not exist: %JTEST_STATIC_BASE_COVERAGE%. Verify the path and retry.
            exit /b 1
        )
    )
)
if not defined JTEST_STATIC_BASE_COVERAGE set "JTEST_STATIC_BASE_COVERAGE="

rem ---- JTEST_UTA_SCRIPT_DIR ------------------------------------------------------------
set "_RC_SCRIPT_DIR_SOURCE=(default)"
if not defined JTEST_UTA_SCRIPT_DIR (
    set "JTEST_UTA_SCRIPT_DIR=%_RC_SKILL_DIR%\scripts"
) else if "%JTEST_UTA_SCRIPT_DIR%"=="" (
    set "JTEST_UTA_SCRIPT_DIR=%_RC_SKILL_DIR%\scripts"
) else (
    set "_RC_SCRIPT_DIR_SOURCE=(override)"
)

if not exist "%JTEST_UTA_SCRIPT_DIR%\" (
    echo ERROR: JTEST_UTA_SCRIPT_DIR points to a directory that does not exist: %JTEST_UTA_SCRIPT_DIR%. Verify the path and retry.
    exit /b 1
)

rem Validate required scripts exist (prefer .bat, then .ps1)
set "_RC_BV_OK=0"
if exist "%JTEST_UTA_SCRIPT_DIR%\build-verify\build-verify.bat" set "_RC_BV_OK=1"
if exist "%JTEST_UTA_SCRIPT_DIR%\build-verify\build-verify.ps1" set "_RC_BV_OK=1"
if "%_RC_BV_OK%"=="0" (
    echo ERROR: JTEST_UTA_SCRIPT_DIR=%JTEST_UTA_SCRIPT_DIR% is missing required script build-verify.bat ^(or .ps1^). Provide both build-verify and jtest-analyze scripts and retry.
    exit /b 1
)

set "_RC_JA_OK=0"
if exist "%JTEST_UTA_SCRIPT_DIR%\jtest-analyze\jtest-analyze.bat" set "_RC_JA_OK=1"
if exist "%JTEST_UTA_SCRIPT_DIR%\jtest-analyze\jtest-analyze.ps1" set "_RC_JA_OK=1"
if "%_RC_JA_OK%"=="0" (
    echo ERROR: JTEST_UTA_SCRIPT_DIR=%JTEST_UTA_SCRIPT_DIR% is missing required script jtest-analyze.bat ^(or .ps1^). Provide both build-verify and jtest-analyze scripts and retry.
    exit /b 1
)

rem ---- JTEST_RESOURCE (set by the skill before calling; default to empty) ----
if not defined JTEST_RESOURCE set "JTEST_RESOURCE="

rem ---- JTEST_UTA_RESOURCE -- UTA scope for testing (set by the skill before calling; default to empty) ------
if not defined JTEST_UTA_RESOURCE set "JTEST_UTA_RESOURCE="

rem ---- JTEST_FIX_ATTEMPTS -- Number of extra attempts to fix the test -----------
if not defined JTEST_FIX_ATTEMPTS set "JTEST_FIX_ATTEMPTS=3"

rem ---- JTEST_UTA_NO_OF_MAX_FIXES -- Limit the application of fixes for test -----------
if not defined JTEST_UTA_NO_OF_MAX_FIXES set "JTEST_UTA_NO_OF_MAX_FIXES="


rem ===== Step 2: Verify Jtest installation ====================================
if not exist "%JTEST_HOME%\jtestcli.exe" (
    echo ERROR: jtestcli not found in JTEST_HOME=%JTEST_HOME%. Verify the Jtest installation path.
    exit /b 1
)

rem ===== Print resolved configuration =========================================
echo.
echo Resolved configuration:
if defined JTEST_SKILLS_CONFIG (
    echo   JTEST_SKILLS_CONFIG          = %JTEST_SKILLS_CONFIG%
) else (
    echo   JTEST_SKILLS_CONFIG          = (not set^)
)
echo   JTEST_HOME               = %JTEST_HOME%
echo   ANALYZED_PROJECT_PATH             = %ANALYZED_PROJECT_PATH%
echo   JTEST_UTA_CONFIGURATION  = %JTEST_UTA_CONFIGURATION%
echo   JTEST_COMMIT_FIXES       = %JTEST_COMMIT_FIXES%
if "%JTEST_STATIC_FILTER_RULE%"=="" (
    echo   JTEST_STATIC_FILTER_RULE        = (not set^)
) else (
    echo   JTEST_STATIC_FILTER_RULE        = %JTEST_STATIC_FILTER_RULE%
)
if "%JTEST_SETTINGS%"=="" (
    echo   JTEST_SETTINGS           = (not set^)
) else (
    echo   JTEST_SETTINGS           = %JTEST_SETTINGS%
)
if "%JTEST_STATIC_BASE_REPORT%"=="" (
    echo   JTEST_STATIC_BASE_REPORT        = (not set^)
) else (
    echo   JTEST_STATIC_BASE_REPORT        = %JTEST_STATIC_BASE_REPORT%
)
if "%JTEST_STATIC_BASE_COVERAGE%"=="" (
    echo   JTEST_STATIC_BASE_COVERAGE      = (not set^)
) else (
    echo   JTEST_STATIC_BASE_COVERAGE      = %JTEST_STATIC_BASE_COVERAGE%
)
echo   JTEST_UTA_SCRIPT_DIR               = %JTEST_UTA_SCRIPT_DIR% %_RC_SCRIPT_DIR_SOURCE%
if "%JTEST_RESOURCE%"=="" (
    echo   ANALYSIS_SCOPE           = (none -- full project^)
) else (
    echo   ANALYSIS_SCOPE           = %JTEST_RESOURCE%
)
if "%JTEST_UTA_RESOURCE%"=="" (
    echo   JTEST_UTA_RESOURCE        = (not set^)
) else (
    echo   JTEST_UTA_RESOURCE        = %JTEST_UTA_RESOURCE%
)
if "%JTEST_FIX_ATTEMPTS%"=="" (
    echo   JTEST_FIX_ATTEMPTS        = (not set^)
) else (
    echo   JTEST_FIX_ATTEMPTS        = %JTEST_FIX_ATTEMPTS%
)
if "%JTEST_UTA_NO_OF_MAX_FIXES%"=="" (
    echo   JTEST_UTA_NO_OF_MAX_FIXES          = (not set^)
) else (
    echo   JTEST_UTA_NO_OF_MAX_FIXES          = %JTEST_UTA_NO_OF_MAX_FIXES%
)
echo.

rem Clean up internal variables
set "_RC_SKILL_DIR="
set "_RC_SCRIPT_DIR_SOURCE="
set "_RC_BV_OK="
set "_RC_JA_OK="

exit /b 0

