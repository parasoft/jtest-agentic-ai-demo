@echo off
rem =============================================================================
rem build-verify.bat  —  Build the project and run unit tests
rem
rem Called by the UTA Test Creation skill (always, via SCRIPT_DIR).
rem
rem Environment variables provided by the skill (always set before this script
rem is invoked):
rem   ANALYZED_PROJECT_PATH             – Absolute path to the project root
rem
rem Exit codes:
rem   0  – Build and all unit tests passed
rem   1  – Build failed or one or more tests failed
rem =============================================================================

setlocal enabledelayedexpansion

echo [build-verify] ANALYZED_PROJECT_PATH = %ANALYZED_PROJECT_PATH%

cd /d "%ANALYZED_PROJECT_PATH%" || (
    echo ERROR: Cannot change to ANALYZED_PROJECT_PATH=%ANALYZED_PROJECT_PATH%
    exit /b 1
)

rem ---------------------------------------------------------------------------
rem Detect build wrapper / fall back to system tool
rem ---------------------------------------------------------------------------
if exist "mvnw.cmd" (
    set BUILD_CMD=mvnw.cmd
) else if exist "gradlew.bat" (
    set BUILD_CMD=gradlew.bat
) else (
    rem Try system tools — prefer Maven if pom.xml exists
    if exist "pom.xml" (
        where mvn >nul 2>&1 && set BUILD_CMD=mvn
    ) else (
        where mvn >nul 2>&1 && set BUILD_CMD=mvn
        if not defined BUILD_CMD (
            where gradle >nul 2>&1 && set BUILD_CMD=gradle
        )
    )
)

if not defined BUILD_CMD (
    echo ERROR: No build tool found. Provide mvnw.cmd, gradlew.bat, mvn, or gradle on PATH.
    exit /b 1
)

echo [build-verify] Using build command: %BUILD_CMD%

rem ---------------------------------------------------------------------------
rem Run tests — customise arguments below for your project
rem ---------------------------------------------------------------------------
set "TEST_CMD=test"

if "%BUILD_CMD%"=="mvnw.cmd" (
    if not "%~1"=="" (
        set "TEST_CMD=!TEST_CMD! -Dtest=%~1"
    )
    call mvnw.cmd !TEST_CMD!
) else if "%BUILD_CMD%"=="mvn" (
    if not "%~1"=="" (
        set "TEST_CMD=!TEST_CMD! -Dtest=%~1"
    )
    call mvn !TEST_CMD!
) else if "%BUILD_CMD%"=="gradlew.bat" (
    if not "%~1"=="" (
        set "TEST_CMD=!TEST_CMD! --tests %~1"
    )
    call gradlew.bat !TEST_CMD!
) else (
    if not "%~1"=="" (
        set "TEST_CMD=!TEST_CMD! --tests %~1"
    )
    call gradle !TEST_CMD!
)

set EXIT_CODE=%ERRORLEVEL%

if %EXIT_CODE% neq 0 (
    echo ERROR: Build or unit tests failed with exit code %EXIT_CODE%.
    exit /b %EXIT_CODE%
)

echo [build-verify] Build and tests passed.
exit /b 0

