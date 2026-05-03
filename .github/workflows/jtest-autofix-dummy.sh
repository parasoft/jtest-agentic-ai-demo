#!/bin/bash

echo "jtest-autofix-dummy begin..."

echo `pwd`
date >> dummy.txt
git add dummy.txt
git commit -m "jtest-autofix-dummy: update dummy.txt"

echo "jtest-autofix-dummy finished."