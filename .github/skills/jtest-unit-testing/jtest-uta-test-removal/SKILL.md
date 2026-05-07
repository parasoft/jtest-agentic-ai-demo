---
name: jtest-uta-test-removal
description: Remove individual failing tests from Java projects with generated tests. Use this skill when you want to clean up test suites by deleting tests that cannot be fixed and are persistently failing.
labels:
   - java
   - code-quality
   - jtest
   - parasoft
   - UTA Post Processing
   - coverage
metadata:
   author: Parasoft
   version: "2.6"
   mode: non-interactive
   requires:
      - Maven or Gradle project
---

# UTA Tests Removal Skill

## Overview

This skill enables GitHub Copilot CLI to remove individual failing tests from Java projects. It identifies tests that are failing, attempts no fixes, and removes them directly from the test classes.

> **Non-interactive / nightly mode**: This skill operates fully autonomously. It **never** prompts the user for input. All required settings must be provided via environmental variables or in `.config` file before skill is invoked. If a required setting cannot be determined automatically, the skill prints a descriptive error message to the console and terminates immediately with a non-zero exit code.

## When to Use This Skill

Use this skill when:
- It is referred from `jtest-unit-testing` skill.
- User mentions remove failing tests, delete failing tests, clean up failing tests, drop failing tests.
- It is referred from another skill as a cleanup step.

Never use this skill when not explicitly mentioned by the user or another skill. This skill is not for fixing tests, improving tests, or any other modifications — it is strictly for removing tests that are persistently failing and cannot be fixed.

<!-- ## Preparation

1. Check if environmental variable `JTEST_SKILLS_CONFIG` is set.
2. If `JTEST_SKILLS_CONFIG` points to an existing file with extension `.config` then:
   - Do steps from **Load Config File** subsection.
3. If `JTEST_SKILLS_CONFIG` is not set do:
   - Locate the file for current running skill.
   - In the directory with current running skill locate file `skill.config`.
   - If such file exists do:
      - Set environmental variable `JTEST_SKILLS_CONFIG` to location of `skill.config` file.
      - Do steps from **Load Config File** subsection.
   - **otherwise** do not set `JTEST_SKILLS_CONFIG`.

## Load Config File

Before reading any other environment variable, check for a config file:

1. Read the `JTEST_SKILLS_CONFIG` environment variable.
2. If not set, skip this step entirely — no config file is loaded.
3. If set, verify that the file exists at the specified path. **If the file does not exist**: print 
`ERROR: JTEST_SKILLS_CONFIG points to a file that does not exist: [path]. Verify the path and retry.` 
and terminate immediately.
4. Parse the file line by line using the following rules:
   - Skip blank lines.
   - Skip lines whose first non-whitespace character is `#` (comments).
   - For each remaining line, split on the **first** `=` character. The left part is the key; the right part is the value. Trim leading and trailing whitespace from both key and value. 
   **Do not** strip surrounding quotes — values must not be quoted.
   - Recognized keys: `ANALYZED_PROJECT_PATH`, `JTEST_COMMIT_FIXES`, `JTEST_UTA_SCRIPT_DIR`. Ignore any other key silently.
5. For each recognized key loaded from the file, set it as an environmental variable **only if the corresponding environment variable is not already set**. **Environment variables always take precedence over file values.** **DO NOT RESET ENVIRONMENTAL VARIABLES THAT ALREADY ARE SET BY THE VALUES FROM `JTEST_SKILLS_CONFIG` FILE!**.

**Config file format example (`skill.config`):**
```properties
# UTA Test Remove skill configuration
ANALYZED_PROJECT_PATH=/home/user/projects/myapp
JTEST_COMMIT_FIXES=false
```
-->

## Prerequisites

All settings are read exclusively from environment variables. No interactive prompts are issued.

| Variable | Required | Description |
|---|---|---|
| `JTEST_SKILLS_CONFIG` | Optional | Absolute path to a properties file (`key=value` format) from which all other settings below can be loaded. Environment variables always take precedence over values defined in this file. |
| `ANALYZED_PROJECT_PATH` | **Required** | Absolute path to the Java project root to analyze. |
| `JTEST_COMMIT_FIXES` | Optional | Set to `true` to commit the removals. Any other value or absence means changes are left as local uncommitted changes. |
| `JTEST_UTA_SCRIPT_DIR` | Optional | Absolute path to a directory containing custom build/analysis scripts. When set, the skill calls the scripts in this directory instead of invoking Maven/Gradle directly. |

## Critical Constraints

**DO NOT create, modify, or delete any files other than junit test files that are strictly related to the failing tests being removed.**

Do not generate summary files, markdown reports, tracking documents, analysis notes, or any other auxiliary files in the repository or anywhere else. The only file modifications permitted are:
1. Removing failing test methods (and their javadoc and potential helper methods) from Java junit test files. Only tests added during the current run session can be removed, and only if they are failing.
2. Deleting Java junit test files that were added in this run session and became empty after all failing tests were removed.
3. Git operations (commit, revert).

**If `JTEST_COMMIT_FIXES=true` the removals must be committed in their own separate git commit.**

**No user interaction is permitted at any point. All values must come from environment variables, the config file, or be auto-detected. If a required value cannot be determined, print a clear error message to the console and terminate immediately with a non-zero exit code.**

**DO NOT attempt to fix tests. This skill only removes failing tests.**

## IMPORTANT INSTRUCTIONS TO FOLLOW:
1. Strictly implement each step one by one, consequently.
2. After successful implementation of the step briefly report the result from the step.
3. Treat variables in Prerequisites as global ones.
4. **DO NOT CHANGE THE VARIABLES FROM Prerequisites! THEY ARE FINAL!**
5. USE RESULTS FROM PREVIOUS STEP IN NEXT STEP.

## How This Skill Works

### Step 1: Resolve Required Settings from Environment

#### Resolve `ANALYZED_PROJECT_PATH`

1. Read the `ANALYZED_PROJECT_PATH` environment variable.
2. **If not set or the path does not exist**: print `ERROR: ANALYZED_PROJECT_PATH is not set or does not point to an existing directory. Set the ANALYZED_PROJECT_PATH environment variable and retry.` and terminate immediately.

#### Resolve `JTEST_COMMIT_FIXES`

1. Read the `JTEST_COMMIT_FIXES` environment variable.
2. Commits are performed only if the value is exactly `true` (case-insensitive). Any other value or absence means changes are left as local uncommitted changes.

#### Resolve `JTEST_UTA_SCRIPT_DIR`

1. Read the `JTEST_UTA_SCRIPT_DIR` environment variable.
2. If set, verify that the directory exists. **If the directory does not exist**: print `ERROR: JTEST_UTA_SCRIPT_DIR points to a directory that does not exist: [path]. Verify the path and retry.` and terminate immediately.
3. Verify that required script files are present inside `JTEST_UTA_SCRIPT_DIR/build-verify` subdirectory:
   - Windows: `build-verify.bat` (or `build-verify.ps1`);
   - Linux/macOS: `build-verify.sh`;
   - The `.bat` / `.ps1` / `.sh` variants are checked in that priority order; the first match for each script is used.
   - **If required script is missing**: print `ERROR: JTEST_UTA_SCRIPT_DIR=[path] is missing required script [script-name]. Provide build-verify script and retry.` and terminate immediately.

#### Print Resolved Variables

After all variables have been resolved successfully, print a summary of all resolved values to the console before proceeding to Step 2. Use the following format exactly:

```
Resolved configuration:
  JTEST_SKILLS_CONFIG       = [resolved value or "(not set)"]
  ANALYZED_PROJECT_PATH     = [resolved value]
  JTEST_COMMIT_FIXES        = [resolved value or "false (default)"]
```

### Step 2: Run Existing Tests from project located at `ANALYZED_PROJECT_PATH`

1. **Detect Build System**
   - If `JTEST_UTA_SCRIPT_DIR` is not set, print the following error message:
   `ERROR: The build-verify scripts are not properly set at JTEST_UTA_SCRIPT_DIR=[JTEST_UTA_SCRIPT_DIR].`
   and terminate immediately.
   - **Otherwise** handle the build system from `build-verify` scripts.

2. **Run unit tests** (compilation is performed implicitly as part of the test run)
   - **If `JTEST_UTA_SCRIPT_DIR` is set** — call the custom build-verify script:
     - Windows (`.bat`): `[JTEST_UTA_SCRIPT_DIR]\build-verify\build-verify.bat`
     - Windows (`.ps1`): `powershell -ExecutionPolicy Bypass -File "[JTEST_UTA_SCRIPT_DIR]\build-verify\build-verify.ps1"`
     - Linux/macOS: `bash "[JTEST_UTA_SCRIPT_DIR]/build-verify/build-verify.sh"`
     - The script receives the following environment variables automatically (they are already set): `ANALYZED_PROJECT_PATH`.
     - The script **must** exit with code `0` on success and a non-zero code on failure.
   - **Otherwise** (no `JTEST_UTA_SCRIPT_DIR`):
      - print the following error message:
         `ERROR: The build-verify scripts are not properly set at JTEST_UTA_SCRIPT_DIR=[JTEST_UTA_SCRIPT_DIR].`

### Step 3: Identify Failing Tests

1. Check if list `FINAL_LIST_OF_TESTS_TO_PROCESS` is set as environmental variable and is available. 
2. **If `FINAL_LIST_OF_TESTS_TO_PROCESS` IS SET as an environmental variable, BUT is EMPTY print `INFO: No failing tests found. Nothing to remove.` and proceed to Step 5.** 
2. **If `FINAL_LIST_OF_TESTS_TO_PROCESS` IS NOT SET as an environmental variable, then do:**
   1. Collect all tests that fail or end with error from the test run in Step 2.
   2. If there are no failing tests, print `INFO: No failing tests found. Nothing to remove.` and proceed to Step 5.
   3. Create a list of failing tests with:
      - Fully qualified test class name.
      - Test method name.
      - Failure reason (short summary from stack trace or test output).
   4. Put the list of failing tests into `FINAL_LIST_OF_TESTS_TO_PROCESS` environment variable for the next steps.

### Step 4: Remove Failing Tests

1. Iterate over the list of failing tests `FINAL_LIST_OF_TESTS_TO_PROCESS`, and for each failing test do the following:
   1. Locate the source file for the test class under `ANALYZED_PROJECT_PATH`.
   2. Identify the full range of the test unit to remove — the test method **and** its javadoc comment immediately above it (if present) **and** its potential helper methods if they are only used by the failing test (also if present).
   3. Remove the identified test unit from the source file. Do **not** remove unrelated methods, fields, imports, or class-level declarations.
   4. If removing the test method leaves the test class completely empty (no remaining test methods), remove the entire test class file. Class is considered empty if it contains no test methods, regardless of presence of other methods, fields, imports, or class-level declarations.
2. After all removals, run the tests again as in Step 2.2.
   - **If the test run still reports failures** for tests that were not in the original failing list: print `WARNING: New failures detected after removal. Review the changes manually.` and continue to Step 5 without reverting.

### Step 5: Commit the Changes but only if `JTEST_COMMIT_FIXES=true`

**By default, do NOT commit any changes.** Skip this step unless `JTEST_COMMIT_FIXES` is set to exactly `true` (case-insensitive) in the environment.

**If `JTEST_COMMIT_FIXES=true`**: Stage only the modified/deleted files (`git add <file> ...`) and commit with a message in the format:
```
Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>
```

**If `JTEST_COMMIT_FIXES` is not set or not `true`**: Leave the changed files as uncommitted local changes and proceed to the summary.

### Step 6: Summary

Report:
- Total number of tests removed.
- List of tests **that have been REMOVED** in format `TestClassTest#testMethod`. Add a short failure reason next to each test (e.g. `TestClassTest#testMethod - NullPointerException in SomeClass.java:123`).
- List of test class files **that have been DELETED** (if any were left empty).
- Files with uncommitted local changes (if committing was not requested).
- Successful commits (if committing was requested).

## Error Handling

All errors are printed to the console (stderr) and cause immediate termination with a non-zero exit code. No user interaction is performed.

| Condition | Console message | Action |
|---|---|---|
| `JTEST_SKILLS_CONFIG` file not found | `ERROR: JTEST_SKILLS_CONFIG points to a file that does not exist: [path]. Verify the path and retry.` | Terminate immediately |
| `ANALYZED_PROJECT_PATH` not set or path does not exist | `ERROR: ANALYZED_PROJECT_PATH is not set or does not point to an existing directory. Set the ANALYZED_PROJECT_PATH environment variable and retry.` | Terminate immediately |
| No supported build file found | `ERROR: No supported build file (pom.xml, build.gradle) found in ANALYZED_PROJECT_PATH=[ANALYZED_PROJECT_PATH]. Only Maven and Gradle projects are supported.` | Terminate immediately |
| `JTEST_UTA_SCRIPT_DIR` directory not found | `ERROR: JTEST_UTA_SCRIPT_DIR points to a directory that does not exist: [path]. Verify the path and retry.` | Terminate immediately |
| Required script missing in `JTEST_UTA_SCRIPT_DIR` | `ERROR: JTEST_UTA_SCRIPT_DIR=[path] is missing required script [script-name]. Provide build-verify script and retry.` | Terminate immediately |

## Implementation Details

### Build System Detection Logic

1. Check for `pom.xml` in project root => Maven
2. Check for `build.gradle` or `build.gradle.kts` => Gradle
3. If neither found => Error: Unsupported build system

### Command Construction

**Maven:**
- Use wrapper if available: `./mvnw` (Linux/macOS) or `mvnw.cmd` (Windows)
- Fallback to system Maven: `mvn`
- Goal: `test`

**Gradle:**
- Use wrapper if available: `./gradlew` (Linux/macOS) or `gradlew.bat` (Windows)
- Fallback to system Gradle: `gradle`
- Task: `test`

### Exit Code Interpretation

- `0`: Success - removal completed (or nothing to remove)
- `Non-zero`: Error occurred
