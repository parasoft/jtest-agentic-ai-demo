#!/bin/bash
export JTEST_SKILLS_CONFIG=/home/mali/dev/git/github/jtest-agentic-ai-demo/jtest-skills.config
copilot -p "Use jtest-static-analysis to analyse and fix violations in the project. Use jtest-unit-testing to increase coverage. Commit each change separately. Create a summary and enlist in point what was changed in the project."  --allow-all-tools  --add-dir /home/mali/dev/git/github/jtest-agentic-ai-demo
