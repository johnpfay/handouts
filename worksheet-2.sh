#!/bin/sh

## Configure git
git config --global user.name johnpfay
git config --global user.email john.fay@duke.edu

## Change the "origin" remote URL and push
git remote set-url origin https://github.com/johnpfay/handouts.git

## Set the SESYNC-CI repository upstream and pull updates
git remote add upstream https://github.com/sesync-ci/handouts.git
git pull upstream master
