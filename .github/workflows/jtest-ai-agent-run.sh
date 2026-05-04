#!/bin/bash

echo "jtest-autofix-dummy begin..."

echo `pwd`
date >> dummy.txt
git add dummy.txt
git commit -m "jtest-autofix-dummy: 1 update of dummy.txt"

date >> dummy.txt
git add dummy.txt
git commit -m "jtest-autofix-dummy: 2 update of dummy.txt"

date >> dummy.txt
git add dummy.txt
git commit -m "jtest-autofix-dummy: 3 update of dummy.txt"

echo "jtest-autofix-dummy finished."