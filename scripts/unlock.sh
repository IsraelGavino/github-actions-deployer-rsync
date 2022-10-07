#!/bin/bash

# Variables
PATH_DEPLOY="${1}/deploy"

# Eliminamos el lock
rm -f $PATH_DEPLOY/.dep/deploy.lock