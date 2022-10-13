#!/bin/bash

# Variables
PATH_PUBLIC="${1}"
USERNAME="${2}"

# Comprobamos si esta bloqueado
if [ -f  $PATH_PUBLIC/.dep/deploy.lock ]; then
	echo "Error: Deploy esta bloqueado, ejecuta la tarea unlock"
	exit 1
else
	echo "$USERNAME" > $PATH_PUBLIC/.dep/deploy.lock
fi