# =============================================================================
# jtest-analyze.ps1  —  Template for running UTA tests creation
#
# Called by the UTA Test Creation skill (always, via SCRIPT_DIR).
#
# Environment variables provided by the skill (always set before this script
# is invoked):
#   JTEST_HOME               – Jtest installation directory
#   ANALYZED_PROJECT_PATH    – Absolute path to the project root
#   JTEST_UTA_CONFIGURATION  – Jtest test configuration name
#   JTEST_SETTINGS           – Absolute path to Jtest settings file (may be empty)
#   JTEST_UTA_RESOURCE       - Pattern to narrow down the scope to test
#
# Exit codes:
#   0  – Analysis completed successfully; report.xml produced
#   1  – Analysis failed
#
# =============================================================================

$ErrorActionPreference = "Stop"

Write-Host "[jtest-analyze] ANALYZED_PROJECT_PATH = $env:ANALYZED_PROJECT_PATH"
Write-Host "[jtest-analyze] JTEST_HOME   = $env:JTEST_HOME"

Set-Location -Path $env:ANALYZED_PROJECT_PATH

# ---------------------------------------------------------------------------
# Build the -Djtest.settings argument (omit when JTEST_SETTINGS is empty)
# ---------------------------------------------------------------------------
$settingsArg = @()
if ($env:JTEST_SETTINGS -and $env:JTEST_SETTINGS -ne "") {
    $settingsArg = @("-Djtest.settings=`"$($env:JTEST_SETTINGS)`"")
}

# ---------------------------------------------------------------------------
# Build the -Djtest.resources argument (omit when JTEST_UTA_RESOURCE is empty)
# ---------------------------------------------------------------------------
$scopeToTestArg = @()
if ($env:JTEST_UTA_RESOURCE -and $env:JTEST_UTA_RESOURCE -ne "") {
    $scopeToTestArg = @("-Djtest.resources=`"$($env:JTEST_UTA_RESOURCE)`"")
}

# ---------------------------------------------------------------------------
# Detect build wrapper / fall back to system tool
# ---------------------------------------------------------------------------
$buildCmd  = $null
$buildType = $null

if (Test-Path "mvnw.cmd") {
    $buildCmd  = ".\mvnw.cmd"
    $buildType = "maven"
} elseif (Test-Path "gradlew.bat") {
    $buildCmd  = ".\gradlew.bat"
    $buildType = "gradle"
} else {
    if (Get-Command "mvn" -ErrorAction SilentlyContinue) {
        $buildCmd  = "mvn"
        $buildType = "maven"
    } elseif (Get-Command "gradle" -ErrorAction SilentlyContinue) {
        $buildCmd  = "gradle"
        $buildType = "gradle"
    }
}

if (-not $buildCmd) {
    Write-Error "ERROR: No build tool found. Provide mvnw.cmd, gradlew.bat, mvn, or gradle on PATH."
    exit 1
}

Write-Host "[jtest-analyze] Using build command: $buildCmd (type: $buildType)"

# ---------------------------------------------------------------------------
# Run Jtest analysis — customise arguments below for your project
# ---------------------------------------------------------------------------
if ($buildType -eq "maven") {
    & $buildCmd jtest:jtest `
        "-Djtest.config=`"$($env:JTEST_UTA_CONFIGURATION)`"" `
        @settingsArg `
        @scopeToTestArg
} else {
    $initScript = Join-Path $env:JTEST_HOME "integration\gradle\init.gradle"
    & $buildCmd jtest `
        "-I$initScript" `
        "-Djtest.config=`"$($env:JTEST_UTA_CONFIGURATION)`"" `
        @settingsArg `
        @scopeToTestArg
}

$exitCode = $LASTEXITCODE

if ($exitCode -ne 0) {
    Write-Error "ERROR: Jtest analysis exited with code $exitCode."
    exit $exitCode
}

Write-Host "[jtest-analyze] Analysis completed successfully."
exit 0

