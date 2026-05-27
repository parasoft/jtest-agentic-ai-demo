# =============================================================================
# build-verify.ps1  —  Build the project and run unit tests
#
# Called by the UTA Test Creation skill (always, via SCRIPT_DIR).
#
# Environment variables provided by the skill (always set before this script
# is invoked):
#   ANALYZED_PROJECT_PATH             – Absolute path to the project root
#
# Exit codes:
#   0  – Build and all unit tests passed
#   1  – Build failed or one or more tests failed
# =============================================================================

$ErrorActionPreference = "Stop"

Write-Host "[build-verify] ANALYZED_PROJECT_PATH = $env:ANALYZED_PROJECT_PATH"

Set-Location -Path $env:ANALYZED_PROJECT_PATH

# ---------------------------------------------------------------------------
# Detect build wrapper / fall back to system tool
# ---------------------------------------------------------------------------
$buildCmd = $null

$TEST_ARGS = @("test")

if (Test-Path "mvnw.cmd") {
    $buildCmd = ".\mvnw.cmd"
    if ($args.Count -gt 0) {
        $TEST_ARGS += "-Dtest=$($args[0])"
    }
}
elseif (Test-Path "gradlew.bat") {
    $buildCmd = ".\gradlew.bat"
    if ($args.Count -gt 0) {
        $TEST_ARGS += "--tests"
        $TEST_ARGS += $args[0]
    }
} else {
    if (Get-Command "mvn" -ErrorAction SilentlyContinue) {
        $buildCmd = "mvn"
        if ($args.Count -gt 0) {
            $TEST_ARGS += "-Dtest=$($args[0])"
        }
    } elseif (Get-Command "gradle" -ErrorAction SilentlyContinue) {
        $buildCmd = "gradle"
        if ($args.Count -gt 0) {
            $TEST_ARGS += "--tests"
            $TEST_ARGS += $args[0]
        }
    }
}

if (-not $buildCmd) {
    Write-Error "ERROR: No build tool found. Provide mvnw.cmd, gradlew.bat, mvn, or gradle on PATH."
    exit 1
}

Write-Host "[build-verify] Using build command: $buildCmd"

# ---------------------------------------------------------------------------
# Run tests — customise arguments below for your project
# ---------------------------------------------------------------------------
& $buildCmd @TEST_ARGS
$exitCode = $LASTEXITCODE

if ($exitCode -ne 0) {
    Write-Error "ERROR: Build or unit tests failed with exit code $exitCode."
    exit $exitCode
}

Write-Host "[build-verify] Build and tests passed."
exit 0

