#!/bin/sh -l

ls -lah

DIR=`pwd`

echo "You are in $DIR"
DEPOYMENT_STAGE=$1
REPO_NAME=$2

# TODO find a way to pass environmental variables into 
# REPO_NAME=`cut -d "/" -f2- <<< "$GITHUB_REPOSITORY"`

echo "Grabbing $DEPOYMENT_STAGE env file for $REPO_NAME"

ls -lah config/$REPO_NAME

mv config/$REPO_NAME/.env.$DEPOYMENT_STAGE ./.env

ls -lah
