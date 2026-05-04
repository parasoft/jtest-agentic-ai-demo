#!/bin/bash

echo "jtest-autofix-dummy begin..."

copilot -p "use jtest-static-analysis to analyse and fix violations in the project. Commit each fix separately" --allow-all-tools

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