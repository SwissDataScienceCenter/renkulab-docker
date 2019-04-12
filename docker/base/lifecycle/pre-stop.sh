#!/bin/bash

GIT_STATUS=`git status -s`
if [ -z "$GIT_STATUS" ] ; then
  exit 0
fi

CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`
CURRENT_SHA=`git rev-parse --short HEAD`
AUTOSAVE_BRANCH="renku/autosave/$JUPYTERHUB_USER/${CURRENT_BRANCH}/${CURRENT_SHA}"
git checkout -b "$AUTOSAVE_BRANCH"
git add .
git commit -am "Auto-saving for $JUPYTERHUB_USER on branch $CURRENT_BRANCH and commit $CURRENT_SHA"
git push origin "$AUTOSAVE_BRANCH"
git checkout master
git branch -D "$AUTOSAVE_BRANCH"
