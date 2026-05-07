#!/usr/bin/env bash
# =============================================================================
# build-verify.sh  —  Build the project and run unit tests
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

set -euo pipefail

echo "[build-verify] ANALYZED_PROJECT_PATH = ${ANALYZED_PROJECT_PATH}"

cd "${ANALYZED_PROJECT_PATH}"

# ---------------------------------------------------------------------------
# Detect build wrapper / fall back to system tool
# ---------------------------------------------------------------------------
BUILD_CMD=""
TEST_CMD=test

if [ -f "./mvnw" ]; then
    BUILD_CMD="./mvnw"
    if [ -n "$1" ]; then
        TEST_CMD="${TEST_CMD} -Dtest=${1}"
    fi
elif [ -f "./gradlew" ]; then
    BUILD_CMD="./gradlew"
    if [ -n "$1" ]; then
        TEST_CMD="${TEST_CMD} --tests ${1}"
    fi
elif command -v mvn >/dev/null 2>&1; then
    BUILD_CMD="mvn"
    if [ -n "$1" ]; then
        TEST_CMD="${TEST_CMD} -Dtest=${1}"
    fi
elif command -v gradle >/dev/null 2>&1; then
    BUILD_CMD="gradle"
    if [ -n "$1" ]; then
        TEST_CMD="${TEST_CMD} --tests ${1}"
    fi
else
    echo "ERROR: No build tool found. Provide mvnw, gradlew, mvn, or gradle on PATH." >&2
    exit 1
fi

echo "[build-verify] Using build command: ${BUILD_CMD}"

# ---------------------------------------------------------------------------
# Run tests — customise arguments below for your project
# ---------------------------------------------------------------------------
${BUILD_CMD} ${TEST_CMD}
EXIT_CODE=$?

if [ "${EXIT_CODE}" -ne 0 ]; then
    echo "ERROR: Build or unit tests failed with exit code ${EXIT_CODE}." >&2
    exit "${EXIT_CODE}"
fi

echo "[build-verify] Build and tests passed."
exit 0

