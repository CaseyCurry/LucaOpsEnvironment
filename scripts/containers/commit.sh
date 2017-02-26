#!/bin/bash
git add containers

if [ -n "$(git diff --cached --exit-code)" ]
then
  git commit -a -m "manage containers"
  git push origin master
fi
