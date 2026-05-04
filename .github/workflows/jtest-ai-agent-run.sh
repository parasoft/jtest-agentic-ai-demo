#!/bin/bash

echo "jtest-autofix-dummy begin..."


# TODO - move to env
export JTEST_SKILLS_CONFIG=/home/mali/dev/git/github/jtest-agentic-ai-demo/jtest-skills.config

echo "Use jtest-static-analysis to analyse and fix violations in the project. Commit each fix separately" | codex exec --yolo
#copilot -p "Use jtest-static-analysis to analyse and fix violations in the project. Commit each fix separately"  --allow-all-tools  --add-dir /home/mali/dev/git/github/jtest-agentic-ai-demo

#echo `pwd`
#date >> dummy.txt
#git add dummy.txt
#git commit -m "jtest-autofix-dummy: 1 update of dummy.txt"
#
#date >> dummy.txt
#git add dummy.txt
#git commit -m "jtest-autofix-dummy: 2 update of dummy.txt"
#
#date >> dummy.txt
#git add dummy.txt
#git commit -m "jtest-autofix-dummy: 3 update of dummy.txt"

echo "jtest-autofix-dummy finished."