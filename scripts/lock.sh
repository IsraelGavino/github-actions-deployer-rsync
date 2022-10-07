#!/bin/bash

# Variables
PATH_DEPLOY="${1}/deploy"
USERNAME="${2}"

# Comprobamos si esta bloqueado
if [ -f  $PATH_DEPLOY/.dep/deploy.lock ]; then
	echo "Error: Deploy esta bloqueado, ejecuta la tarea unlock"
	exit 1
else
	echo "$USERNAME" > $PATH_DEPLOY/.dep/deploy.lock
fi